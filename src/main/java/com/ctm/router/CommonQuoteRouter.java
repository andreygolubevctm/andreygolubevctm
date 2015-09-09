package com.ctm.router;

import com.ctm.dao.EmailMasterDao;
import com.ctm.dao.StampingDao;
import com.ctm.dao.transaction.TransactionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.CompetitionEntry;
import com.ctm.model.EmailMaster;
import com.ctm.model.formData.Request;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.FatalErrorService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.services.competition.CompetitionService;
import com.ctm.services.email.EmailDetailsService;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public abstract class CommonQuoteRouter<REQUEST extends Request> {

    protected static final Logger LOGGER = LoggerFactory.getLogger(CommonQuoteRouter.class);

    protected Brand initRouter(MessageContext context){
        // - Start common -- taken from Carlos' car branch
        ApplicationService.setVerticalCodeOnRequest(context.getHttpServletRequest(), Vertical.VerticalType.TRAVEL.getCode());
        Brand brand = null;
        try {
            brand = ApplicationService.getBrandFromRequest(context.getHttpServletRequest());

        } catch (DaoException e) {
            throw new RouterException(e);
        }
        return brand;
    }

    protected Data getDataBucket(MessageContext context, Long transactionId) {
        SessionDataService service = new SessionDataService();
        try {
            return service.getDataForTransactionId(context.getHttpServletRequest(), transactionId.toString(), true);
        } catch (DaoException | SessionException e) {
            throw new RouterException(e);
        }
    }

    protected String updateClientIP(MessageContext context, REQUEST data){

        SessionDataService service = new SessionDataService();
        String clientIpAddress = null;

        Data dataBucket = getDataBucket(context, data.getTransactionId());

        if(dataBucket != null && dataBucket.getString("current/transactionId") != null){
            data.setTransactionId(Long.parseLong(dataBucket.getString("current/transactionId")));
            clientIpAddress = (String) dataBucket.get("quote/clientIpAddress");
        }
        if (StringUtils.isBlank(clientIpAddress)) {
            clientIpAddress = context.getHttpServletRequest().getRemoteAddr();
        }
        data.setClientIpAddress(clientIpAddress);
        return clientIpAddress;
    }

    protected void addCompetitionEntry(MessageContext context, Long transactionId, CompetitionEntry entry) {

        try {
            SessionDataService service = new SessionDataService();

            HttpServletRequest request = context.getHttpServletRequest();
            PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
            String brandCode = pageSettings.getBrandCode();
            Integer brandId = pageSettings.getBrandId();
            Integer verticalId = pageSettings.getVertical().getId();
            String verticalCode = pageSettings.getVerticalCode();

            // STEP 1: Validate the input received before proceeding
            List<SchemaValidationError> errors = FormValidation.validate(entry, verticalCode);

            if (entry.getCompetitionId() == 2 && StringUtils.isBlank(entry.getLastName())) {
                SchemaValidationError e = new SchemaValidationError();
                e.setMessage("Your last name is required.");
                errors.add(e);
            }

            if (entry.isPhoneNumberRequired() && StringUtils.isBlank(entry.getPhoneNumber())) {
                SchemaValidationError e = new SchemaValidationError();
                e.setMessage("Your phone number is required.");
                errors.add(e);
            }

            if (errors.isEmpty()) {

                // STEP 2: Write email data to aggregator.email_master and get the EmailID
                StampingDao stampingDao = new StampingDao(pageSettings.getBrandId(), pageSettings.getBrandCode(), verticalCode);
                EmailMasterDao emailMasterDao = new EmailMasterDao(brandId, brandCode, verticalCode);
                EmailDetailsService emailDetailsService = new EmailDetailsService(emailMasterDao, new TransactionDao(), null, brandCode,
                        null, stampingDao, verticalCode);

                String operator = "ONLINE";
                AuthenticatedData authenticatedSessionData = service.getAuthenticatedSessionData(request);
                if (authenticatedSessionData != null) {
                    operator = authenticatedSessionData.getUid();
                }


                EmailMaster emailDetailsRequest = new EmailMaster();
                emailDetailsRequest.setEmailAddress(entry.getEmail());
                emailDetailsRequest.setFirstName(entry.getFirstName());
                emailDetailsRequest.setLastName(entry.getLastName());
                emailDetailsRequest.setOptedInMarketing(true, verticalCode);
                emailDetailsRequest.setSource(entry.getSource());
                EmailMaster emailMaster = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, request.getRemoteAddr());

                if (emailMaster == null) {
                    SchemaValidationError e = new SchemaValidationError();
                    e.setMessage("Failed to retrieve the emailId to make the entry.");
                    errors.add(e);
                }

                if (errors.isEmpty()) {

                    // STEP 3: Write competition details to ctm.competition_data

                    List<Pair<String, String>> items = new ArrayList<>();
                    items.add(Pair.of("firstname", entry.getFirstName()));
                    items.add(Pair.of("lastname", entry.getLastName()));
                    items.add(Pair.of("phone", entry.getPhoneNumber()));

                    boolean added = CompetitionService.addCompetitionEntry(entry.getCompetitionId(), emailMaster.getEmailId(), items);

                    if (!added) {
                        SchemaValidationError e = new SchemaValidationError();
                        e.setMessage("Failed to create entry in database.");
                        errors.add(e);
                    }
                }
            }

            if (!errors.isEmpty()) {

                String sessionId = StringUtils.left(request.getSession().getId(), 64);
                String page = request.getServletPath();

                String errorMessage = errors.stream()
                        .map(s -> "error:" + s.getMessage())
                        .collect(Collectors.joining(","));

                LOGGER.error("ENTRY ERRORS: {}", errorMessage);

                String data = "competition_id:" + entry.getCompetitionId() +
                        " email:" + entry.getEmail() +
                        " firstname:" + entry.getFirstName() +
                        " lastname:" + entry.getLastName() +
                        " phone:" + entry.getPhoneNumber();


                // add errors using FatalErrorService
                FatalErrorService.logFatalError(brandId, page, sessionId, false, "Competition error", errorMessage,
                        transactionId.toString(), data, brandCode);
                return;
            }
        } catch (Exception e) {
            LOGGER.error("Exception encountered while trying to add a competition entry.", e);
            throw new RouterException(e);
        }
    }

}
