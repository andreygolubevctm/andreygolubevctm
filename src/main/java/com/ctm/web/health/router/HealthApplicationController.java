package com.ctm.web.health.router;

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
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.TouchService;
import com.ctm.web.core.services.TransactionAccessService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.factory.EmailServiceFactory;
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
import com.ctm.web.health.services.HealthConfirmationService;
import com.ctm.web.health.services.HealthLeadService;
import com.ctm.web.simples.services.TransactionService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.FormParam;
import javax.ws.rs.NotFoundException;
import java.io.IOException;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;
import static java.util.stream.Collectors.toList;

@Api(basePath = "/rest/health", value = "Health Apply")
@RestController
@RequestMapping("/rest/health")
public class HealthApplicationController extends CommonQuoteRouter {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplicationController.class);

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private static final DateTimeFormatter LONG_FORMAT = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss zzz yyyy");
    public static final String PROVIDER_FAILED_MESSAGE = "The provider failed to process the application, Please contact support team.";

    @Autowired
    private HealthApplyService healthApplyService;

    @Autowired
    private JoinService joinService;

    @Autowired
    private TransactionAccessService transactionAccessService;

    private LeadService leadService;

    @Autowired
    private HealthConfirmationService healthConfirmationService;

    @Autowired
    public HealthApplicationController(SessionDataServiceBean sessionDataServiceBean ,
                                       IPAddressHandler ipAddressHandler,
                                       HealthLeadService leadService) {
        super(sessionDataServiceBean, ipAddressHandler);
        this.leadService = leadService;
    }

    @ApiOperation(value = "apply/get.json", notes = "Submit an health application", produces = "application/json")
    @RequestMapping(value = "/apply/get.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public HealthResultWrapper getHealthApply(@ModelAttribute final HealthRequest data,
                                              BindingResult bindingResult,
                                              HttpServletRequest request) throws DaoException, IOException, ServiceConfigurationException, ConfigSettingException {

        if (bindingResult.hasErrors()) {
            for (ObjectError e : bindingResult.getAllErrors()) {
                LOGGER.error("FORM POST MAPPING ERROR: {},", kv("error" , e));
            }
        }

        Vertical.VerticalType vertical = HEALTH;

        // Initialise request
        Brand brand = initRouter(request, vertical);
        updateTransactionIdAndClientIP(request, data);

        // get the response
        final HealthApplyResponse applyResponse = healthApplyService.apply(brand, data);
        // Should only be one payload response
        final HealthApplicationResponse response = applyResponse.getPayload();

        // Create the confirmationId
        final String confirmationId = request.getSession().getId() + "-" + data.getTransactionId();

        // Get the productId removing the PHIO-HEALTH- prefix
        final String productId = data.getQuote().getApplication().getProductId()
                .substring(data.getQuote().getApplication().getProductId().indexOf("HEALTH-") + 7);


        HealthApplicationResult result = new HealthApplicationResult();


        if (Status.Success.equals(response.getSuccess())) {

            result.setSuccess(true);
            result.setConfirmationID(confirmationId);

            request.setAttribute("applicationResponse", applyResponse);
            request.setAttribute("requestData", data);
            request.setAttribute("confirmationId", confirmationId);

            // Record Confirmation touch
            recordTouch(request, data, productId, Touch.TouchType.SOLD);

            // Write to the join table
            joinService.writeJoin(data.getTransactionId(), productId);

            TransactionService.writeAllowableErrors(data.getTransactionId(), getErrors(response.getErrorList(), true));

            // write to transaction_details the policy_no
            writePolicyNoToTransactionDetails(data, response);

            final Data dataBucket = getDataBucket(request, data.getTransactionId());

            healthConfirmationService.createAndSaveConfirmation(request, data, response, confirmationId, dataBucket);

            // TODO: add competition entry

            sendEmail(request, data, vertical, brand, dataBucket);

            leadService.sendLead(4, dataBucket, request, "SOLD");

            // Check outcome was ok --%>
            LOGGER.info("Transaction has been set to confirmed. {},{}", kv("transactionId", data.getTransactionId()), kv("confirmationID", confirmationId));

        } else {

            // Set callCentre property only when it's not a success
            final String callCentre = (String)request.getSession().getAttribute("callCentre");
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
                setToPending(request, data, confirmationId, productId, getErrors(response.getErrorList(), false));
            } else {
                // just record a failure
                recordTouch(request, data, productId, Touch.TouchType.FAIL);
            }

            leadService.sendLead(4, getDataBucket(request, data.getTransactionId()), request, "PENDING");
        }

        LOGGER.debug("Health application complete. {},{}", kv("transactionId", data.getTransactionId()), kv("response", result));

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
        } else if (!nonFatalErrors) {
            sb.append(PROVIDER_FAILED_MESSAGE);
        }
        return sb.toString();
    }

    private void sendEmail(HttpServletRequest request, HealthRequest data, Vertical.VerticalType vertical, Brand brand, Data dataBucket) {
        String confirmationEmailCode;
        try {

            final String email = getEmail(data);
            final WebApplicationContext applicationContext = WebApplicationContextUtils
                    .getWebApplicationContext(request.getServletContext());
            EmailServiceFactory emailServiceFactory = applicationContext.getBean(EmailServiceFactory.class);
            final EmailServiceHandler emailServiceHandler = emailServiceFactory.newInstance(getPageSettingsByCode(brand, vertical),
                    EmailMode.APP, dataBucket);
            confirmationEmailCode = emailServiceHandler.send(request, email, data.getTransactionId());
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

    private void writePolicyNoToTransactionDetails(@FormParam("") HealthRequest data, HealthApplicationResponse response) {
        try {
            transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -2, "health/policyNo", response.getProductId());
        } catch (Exception e) {
            LOGGER.warn("Failed to add transactionDetail {} because {}", data.getTransactionId(), e);
        }
    }

    private void setToPending(HttpServletRequest request, HealthRequest data, String confirmationId, String productId, String errorMessage) throws DaoException {
        recordTouch(request, data, productId, Touch.TouchType.FAIL);

        // Add trigger
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -5, "pending", ZonedDateTime.now().format(LONG_FORMAT));
        // Add fatalerrorreason
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -6, "fatalerrorreason", "Pending: Application failed: " + errorMessage);
        // Add pendingId
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -7, "pendingID", confirmationId);

        // write to join
        joinService.writeJoin(data.getTransactionId(), productId);

    }

    private void recordTouch(HttpServletRequest request, HealthRequest data, String productId, Touch.TouchType type) {
        Touch touch = new Touch();
        touch.setType(type);
        touch.setTransactionId(data.getTransactionId());
        TouchService.getInstance().recordTouchWithProductCode(request, touch, productId);
    }

}
