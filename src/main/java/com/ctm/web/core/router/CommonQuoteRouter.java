package com.ctm.web.core.router;

import com.ctm.web.core.competition.services.CompetitionService;
import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.dao.StampingDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.CompetitionEntry;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.Info;
import com.ctm.web.core.services.*;
import com.ctm.web.core.services.tracking.TrackingKeyService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public abstract class CommonQuoteRouter<REQUEST extends Request> {

    private SessionDataServiceBean sessionDataServiceBean;

    public CommonQuoteRouter(SessionDataServiceBean sessionDataServiceBean) {
        this.sessionDataServiceBean = sessionDataServiceBean;
    }

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonQuoteRouter.class);

    protected Brand initRouter(MessageContext context, Vertical.VerticalType vertical){
        return initRouter(context.getHttpServletRequest(), vertical);
    }

    protected Brand initRouter(HttpServletRequest httpServletRequest, Vertical.VerticalType vertical){
        // - Start common -- taken from Carlos' car branch
        ApplicationService.setVerticalCodeOnRequest(httpServletRequest, vertical.getCode());

        try {
            return ApplicationService.getBrandFromRequest(httpServletRequest);

        } catch (DaoException e) {
            throw new RouterException(e);
        }

    }

    protected SessionDataServiceBean getSessionDataServiceBean() {
        return sessionDataServiceBean;
    }

    protected Data getDataBucket(MessageContext context, Long transactionId) {
        return getDataBucket(context.getHttpServletRequest(),  transactionId);
    }

    protected Data getDataBucket(HttpServletRequest request, Long transactionId) {
        try {
            return sessionDataServiceBean.getDataForTransactionId(request, transactionId.toString(), true);
        } catch (DaoException | SessionException e) {
            throw new RouterException(e);
        }
    }

    protected String updateTransactionIdAndClientIP(MessageContext context, REQUEST data){
        return updateTransactionIdAndClientIP(context.getHttpServletRequest(),  data);
    }

    protected String updateTransactionIdAndClientIP(HttpServletRequest request, REQUEST data){
        final String clientIpAddress;
        Data dataBucket = getDataBucket(request, data.getTransactionId());

        if(dataBucket != null && dataBucket.getString("current/transactionId") != null){
            data.setTransactionId(Long.parseLong(dataBucket.getString("current/transactionId")));
        }
        if (StringUtils.isBlank((String) dataBucket.get("quote/clientIpAddress"))) {
            clientIpAddress = request.getRemoteAddr();
        } else {
            clientIpAddress = (String) dataBucket.get("quote/clientIpAddress");
        }
        data.setClientIpAddress(clientIpAddress);

        return clientIpAddress;
    }

    protected Info generateInfoKey(final REQUEST data, final MessageContext context) {
        return generateInfoKey(data, context.getHttpServletRequest());
    }

    protected Info generateInfoKey(final REQUEST data, final HttpServletRequest request) {
        // Generate the Tracking Key for Omniture tracking
        Info info = new Info();
        info.setTransactionId(data.getTransactionId());
        try {
            String trackingKey = TrackingKeyService.generate(
                    request, data.getTransactionId());
            info.setTrackingKey(trackingKey);
        } catch (Exception e) {
            throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
        }
        return info;
    }

    protected void checkIPAddressCount(Brand brand, Vertical.VerticalType vertical, MessageContext context) {
        checkIPAddressCount(brand, vertical, context.getHttpServletRequest());
    }

    protected void checkIPAddressCount(Brand brand, Vertical.VerticalType vertical, HttpServletRequest request) {
        IPCheckService ipCheckService = new IPCheckService();
        PageSettings pageSettings = getPageSettingsByCode(brand, vertical);
        if(!ipCheckService.isPermittedAccess(request, pageSettings)) {
            LOGGER.error("Access attempts exceeded for IP {} in {}", request.getRemoteAddr(), vertical.getCode());
            throw new RouterException("Access attempts exceeded");
        }
    }

    protected PageSettings getPageSettingsByCode(Brand brand, Vertical.VerticalType vertical) {
        return SettingsService.getPageSettingsByCode(brand.getCode(), vertical.getCode());
    }

    protected void addCompetitionEntry(MessageContext context, Long transactionId, CompetitionEntry entry) throws ConfigSettingException, DaoException, EmailDetailsException {

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
            AuthenticatedData authenticatedSessionData = sessionDataServiceBean.getAuthenticatedSessionData(request);
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
        }
    }

    protected void updateApplicationDate(MessageContext context, REQUEST data) {
        updateApplicationDate(context.getHttpServletRequest(), data);
    }

    protected void updateApplicationDate(HttpServletRequest request, REQUEST data) {
        getApplicationDate(request).ifPresent(data::setRequestAt);
    }

    protected Optional<LocalDateTime> getApplicationDate(HttpServletRequest request) {
        final Date date = ApplicationService.getApplicationDateIfSet(request);
        if (date != null) {
            return Optional.of(LocalDateTime.ofInstant(date.toInstant(), ZoneId.systemDefault()));
        }
        return Optional.empty();
    }


}
