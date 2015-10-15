package com.ctm.router.health;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.factory.EmailServiceFactory;
import com.ctm.model.Confirmation;
import com.ctm.model.Touch;
import com.ctm.model.email.EmailMode;
import com.ctm.model.health.form.Application;
import com.ctm.model.health.form.ContactDetails;
import com.ctm.model.health.form.HealthQuote;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.health.results.HealthResult;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.providers.ResponseError;
import com.ctm.providers.health.healthapply.model.request.payment.details.Frequency;
import com.ctm.providers.health.healthapply.model.response.HealthApplicationResponse;
import com.ctm.providers.health.healthapply.model.response.HealthApplyResponse;
import com.ctm.providers.health.healthapply.model.response.PartnerError;
import com.ctm.providers.health.healthapply.model.response.Status;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.TouchService;
import com.ctm.services.TransactionAccessService;
import com.ctm.services.confirmation.ConfirmationService;
import com.ctm.services.confirmation.JoinService;
import com.ctm.services.email.EmailServiceHandler;
import com.ctm.services.health.HealthApplyService;
import com.ctm.services.simples.ProviderContentService;
import com.ctm.utils.ObjectMapperUtil;
import com.disc_au.web.go.Data;
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
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.ctm.logging.LoggingArguments.kv;
import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;
import static java.lang.Boolean.TRUE;

@Path("/health")
public class HealthApplicationRouter extends CommonQuoteRouter<HealthRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplicationRouter.class);

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private static final DateTimeFormatter LONG_FORMAT = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss zzz yyyy");

    private final HealthApplyService healthApplyService = new HealthApplyService();

    private final JoinService joinService = new JoinService();

    private final ProviderContentService providerContentService = new ProviderContentService();

    private final TransactionAccessService transactionAccessService = new TransactionAccessService();

    private final ConfirmationService confirmationService = new ConfirmationService();

    @POST
    @Path("/apply/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public HealthResult getHealthApply(@Context MessageContext context, @FormParam("") final HealthRequest data) throws DaoException, IOException, ServiceConfigurationException, ConfigSettingException {

        // TODO: implement tokenisation validate

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

        // Check for internal or provider errors and record the failed submission and add comments to the quote for call centre staff
        // Collate the error list messages
        StringBuilder sb = new StringBuilder();
        if (!response.getErrorList().isEmpty()) {
            List<ResponseError> responseErrors = new ArrayList<>();
            for (int i = 0; i < response.getErrorList().size(); i++) {
                // Expects 1 base position value
                final PartnerError partnerError = response.getErrorList().get(i);
                sb.append("[").append(i + 1).append("] ").append(partnerError.getMessage());
                // add the errors as ResponseError
                final ResponseError e = new ResponseError();
                e.setCode(partnerError.getCode());
                e.setDescription(partnerError.getMessage());
                e.setOriginal(partnerError.getMessage());
                e.setText(partnerError.getMessage());
                responseErrors.add(e);
            }
            applyResponse.setErrors(responseErrors);
        }

        // Record touch of the error list messages
        final String errorMessage = sb.toString();
        if (!errorMessage.isEmpty()) {
            setToPending(context, data, confirmationId, productId, errorMessage);
        }

        if (Status.Success.equals(response.getSuccess())) {

            applyResponse.setSuccess(true);
            applyResponse.setConfirmationID(confirmationId);

            context.getHttpServletRequest().setAttribute("applicationResponse", applyResponse);
            context.getHttpServletRequest().setAttribute("requestData", data);

            // Record Confirmation touch
            recordTouch(context, data, productId, Touch.TouchType.SOLD);

            // Write to the join table
            joinService.writeJoin(data.getTransactionId(), productId);

            // TODO: allowable errors???

            // write to transaction_details the policy_no
            writePolicyNoToTransactionDetails(data, response);

            final Data dataBucket = getDataBucket(context, data.getTransactionId());

            createAndSaveConfirmation(context, data, response, confirmationId, dataBucket);

            // TODO: add competition entry

            sendEmail(context, data, vertical, brand, applyResponse, dataBucket);

            // Check outcome was ok --%>
            LOGGER.info("Transaction has been set to confirmed. {},{}", kv("transactionId", data.getTransactionId()), kv("confirmationID", confirmationId));

        } else {

            // Set callCentre property only when it's not a success
            final String callCentre = (String)context.getHttpServletRequest().getSession().getAttribute("callCentre");
            applyResponse.setCallcentre("true".equals(callCentre));
            applyResponse.setSuccess(false);
            applyResponse.setPendingID(confirmationId);

            if (StringUtils.isBlank(errorMessage)) {
                // if online user record a join
                if (!TRUE.equals(callCentre)) {
                    setToPending(context, data, confirmationId, productId, "");
                } else {
                    // just record a failure
                    recordTouch(context, data, productId, Touch.TouchType.FAIL);
                }
            }

        }

        LOGGER.debug("Health application complete. {},{}", kv("transactionId", data.getTransactionId()), kv("response", applyResponse));

        HealthResult healthResult = new HealthResult();
        healthResult.setResult(applyResponse);
        return healthResult;
    }

    private void sendEmail(MessageContext context, HealthRequest data, Vertical.VerticalType vertical, Brand brand, HealthApplyResponse applyResponse, Data dataBucket) {
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

        boolean confirmed = false;

        try {
            confirmed = confirmationService.addConfirmation(confirmation);
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

        // TODO: verify if needed to do write optins

        // Save to store error and pendingId
        // TODO: check that the the transaction is not yet confirmed

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
