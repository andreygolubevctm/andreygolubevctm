package com.ctm.web.health.router;

import com.ctm.web.core.confirmation.model.Confirmation;
import com.ctm.web.core.confirmation.services.ConfirmationService;
import com.ctm.web.core.confirmation.services.JoinService;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailServiceHandler;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadService.services.LeadService;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.TouchService;
import com.ctm.web.core.services.TransactionAccessService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.health.apply.model.request.payment.details.Frequency;
import com.ctm.web.health.apply.model.response.HealthApplicationResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
import com.ctm.web.health.apply.model.response.PartnerError;
import com.ctm.web.health.apply.model.response.Status;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.ContactDetails;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.results.HealthApplicationResult;
import com.ctm.web.health.model.results.HealthResultWrapper;
import com.ctm.web.health.model.results.ResponseError;
import com.ctm.web.health.services.HealthApplyService;
import com.ctm.web.health.services.HealthLeadService;
import com.ctm.web.health.services.ProviderContentService;
import com.ctm.web.simples.services.TransactionService;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.io.IOException;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;
import static java.util.stream.Collectors.toList;

@Path("/health")
public class HealthApplicationRouter extends CommonQuoteRouter<HealthRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplicationRouter.class);

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private static final DateTimeFormatter LONG_FORMAT = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss zzz yyyy");
    public static final String PROVIDER_FAILED_MESSAGE = "The provider failed to process the application, Please contact support team.";

    private final HealthApplyService healthApplyService = new HealthApplyService();

    private final JoinService joinService = new JoinService();

    private final ProviderContentService providerContentService = new ProviderContentService();

    private final TransactionAccessService transactionAccessService = new TransactionAccessService();

    private final ConfirmationService confirmationService = new ConfirmationService();

    private final LeadService leadService = new HealthLeadService();

    @POST
    @Path("/apply/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public HealthResultWrapper getHealthApply(@Context MessageContext context, @FormParam("") final HealthRequest data) throws DaoException, IOException, ServiceConfigurationException, ConfigSettingException {

        Vertical.VerticalType vertical = HEALTH;

        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data);

        // get the response
        final HealthApplyResponse applyResponse = healthApplyService.apply(brand, data);
        // Should only be one payload response
        final HealthApplicationResponse response = applyResponse.getPayload().getQuotes().get(0);

        // Create the confirmationId
        final String confirmationId = context.getHttpServletRequest().getSession().getId() + "-" + data.getTransactionId();

        // Get the productId removing the PHIO-HEALTH- prefix
        final String productId = data.getQuote().getApplication().getProductId()
                .substring(data.getQuote().getApplication().getProductId().indexOf("HEALTH-") + 7);


        HealthApplicationResult result = new HealthApplicationResult();


        if (Status.Success.equals(response.getSuccess())) {

            result.setSuccess(true);
            result.setConfirmationID(confirmationId);

            context.getHttpServletRequest().setAttribute("applicationResponse", applyResponse);
            context.getHttpServletRequest().setAttribute("requestData", data);
            context.getHttpServletRequest().setAttribute("confirmationId", confirmationId);

            // Record Confirmation touch
            recordTouch(context, data, productId, Touch.TouchType.SOLD);

            // Write to the join table
            joinService.writeJoin(data.getTransactionId(), productId);

            TransactionService.writeAllowableErrors(data.getTransactionId(), getErrors(response.getErrorList(), true));

            // write to transaction_details the policy_no
            writePolicyNoToTransactionDetails(data, response);

            final Data dataBucket = getDataBucket(context, data.getTransactionId());

            createAndSaveConfirmation(context, data, response, confirmationId, dataBucket);

            // TODO: add competition entry

            sendEmail(context, data, vertical, brand, dataBucket);

            // Check outcome was ok --%>
            LOGGER.info("Transaction has been set to confirmed. {},{}", kv("transactionId", data.getTransactionId()), kv("confirmationID", confirmationId));

        } else {

            // Set callCentre property only when it's not a success
            final String callCentre = (String)context.getHttpServletRequest().getSession().getAttribute("callCentre");
            result.setCallcentre("true".equals(callCentre));
            result.setSuccess(false);
            result.setPendingID(confirmationId);

            // Check for internal or provider errors and record the failed submission and add comments to the quote for call centre staff
            // Collate the error list messages

            final List<ResponseError> errors = response.getErrorList()
                    .stream()
                    .map(partnerError -> {
                        // add the errors as ResponseError
                        final ResponseError e = new ResponseError();
                        e.setCode(partnerError.getCode());
                        e.setDescription(partnerError.getMessage());
                        e.setOriginal(partnerError.getMessage());
                        e.setText(partnerError.getMessage());
                        return e;
                    }).collect(toList());
            if (!errors.isEmpty()) {
                result.setErrors(errors);
            } else {
                final ResponseError e = new ResponseError();
                e.setCode("SERVICE_FAILED");
                e.setDescription(PROVIDER_FAILED_MESSAGE);
                e.setOriginal(PROVIDER_FAILED_MESSAGE);
                e.setText(PROVIDER_FAILED_MESSAGE);
                result.setErrors(Collections.singletonList(e));
            }


            // if online user record a join and add to transaction details
            if (!"true".equals(callCentre)) {
                setToPending(context, data, confirmationId, productId, getErrors(response.getErrorList(), false));
            } else {
                // just record a failure
                recordTouch(context, data, productId, Touch.TouchType.FAIL);
            }

        }

        LOGGER.debug("Health application complete. {},{}", kv("transactionId", data.getTransactionId()), kv("response", result));

        leadService.sendLead(4, getDataBucket(context, data.getTransactionId()), context.getHttpServletRequest());

        final HealthResultWrapper resultWrapper = new HealthResultWrapper();
        resultWrapper.setResult(result);
        return resultWrapper;
    }

    private String getErrors(List<PartnerError> errors, boolean nonFatalErrors) {
        // Check for internal or provider errors and record the failed submission and add comments to the quote for call centre staff
        // Collate the error list messages
        final StringBuilder sb = new StringBuilder();
        if (!errors.isEmpty()) {
            int i = 0;
            for (PartnerError error : errors) {
                // Non fatal errors
                final PartnerError partnerError = errors.get(i);
                if (nonFatalErrors && !error.isFatal()) {
                    sb.append("[").append(i + 1).append("] ").append(partnerError.getMessage());
                    i++;
                } else {
                    sb.append("[").append(i + 1).append("] ").append(partnerError.getMessage());
                    i++;
                }
            }
        } else {
            sb.append(PROVIDER_FAILED_MESSAGE);
        }
        return sb.toString();
    }

    private void sendEmail(MessageContext context, HealthRequest data, Vertical.VerticalType vertical, Brand brand, Data dataBucket) {
        String confirmationEmailCode;
        try {

            final String email = getEmail(data);

            final EmailServiceHandler emailServiceHandler = EmailServiceFactory.newInstance(getPageSettingsByCode(brand, vertical), EmailMode.APP, dataBucket);
            confirmationEmailCode = emailServiceHandler.send(context.getHttpServletRequest(), email, data.getTransactionId());
        } catch (SendEmailException se) {
            confirmationEmailCode = "0";
        }

        try {
            transactionAccessService.addTransactionDetails(data.getTransactionId(), -1, "health/confirmationEmailCode", confirmationEmailCode);
        } catch (DaoException e) {
            LOGGER.warn("Failed to Update transaction details with {}", kv("confirmationEmailCode", confirmationEmailCode), e);
        }
    }

    private String getEmail(HealthRequest data) {
        final Optional<HealthRequest> hasData = Optional.ofNullable(data);
        return hasData.map(HealthRequest::getQuote)
                .map(HealthQuote::getApplication)
                .map(Application::getEmail)
                .orElseGet(() -> hasData.map(HealthRequest::getQuote)
                                        .map(HealthQuote::getContactDetails)
                                        .map(ContactDetails::getEmail)
                                        .orElseThrow(() -> new NotFoundException("Email not found")));
    }

    private void createAndSaveConfirmation(MessageContext context, HealthRequest data, HealthApplicationResponse response, String confirmationId, Data dataBucket) throws DaoException, ConfigSettingException, JsonProcessingException {
        final String productSelected = StringUtils.removeEnd(
                StringUtils.removeStart(dataBucket.getString("confirmation/health"), "<![CDATA["),
                "]]>");

        final ConfirmationData confirmationData = new ConfirmationData(data.getTransactionId().toString(),
                LocalDate.parse(data.getQuote().getPayment().getDetails().getStart(), AUS_FORMAT),
                Frequency.fromCode(data.getQuote().getPayment().getDetails().getFrequency()).name(),
                providerContentService.getProviderContentText(context.getHttpServletRequest(), data.getHealth().getApplication().getProviderName(), "ABT"),
                providerContentService.getProviderContentText(context.getHttpServletRequest(), data.getHealth().getApplication().getProviderName(), "NXT"),
                productSelected,
                response.getProductId());

        Confirmation confirmation = new Confirmation();
        confirmation.setKey(confirmationId);
        confirmation.setTransactionId(data.getTransactionId());
        confirmation.setXmlData(ObjectMapperUtil.getXmlMapper().writeValueAsString(confirmationData));

        try {
            confirmationService.addConfirmation(confirmation);
        } catch (Exception e) {
            LOGGER.warn("Failed to add confirmation {}", kv("confirmationId", confirmationId), e);
        }
    }

    private void writePolicyNoToTransactionDetails(@FormParam("") HealthRequest data, HealthApplicationResponse response) {
        try {
            transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -2, "health/policyNo", response.getProductId());
        } catch (Exception e) {
            LOGGER.warn("Failed to add transactionDetail {} because {}", data.getTransactionId(), e);
        }
    }

    private void setToPending(MessageContext context, HealthRequest data, String confirmationId, String productId, String errorMessage) throws DaoException {
        recordTouch(context, data, productId, Touch.TouchType.FAIL);

        // Add trigger
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -5, "pending", ZonedDateTime.now().format(LONG_FORMAT));
        // Add fatalerrorreason
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -6, "fatalerrorreason", "Pending: Application failed: " + errorMessage);
        // Add pendingId
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -7, "pendingID", confirmationId);

        // write to join
        joinService.writeJoin(data.getTransactionId(), productId);

    }

    private void recordTouch(MessageContext context, HealthRequest data, String productId, Touch.TouchType type) {
        Touch touch = new Touch();
        touch.setType(type);
        touch.setTransactionId(data.getTransactionId());
        TouchService.getInstance().recordTouchWithProductCode(context.getHttpServletRequest(), touch, productId);
    }

}
