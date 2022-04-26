package com.ctm.web.health.router;

import com.ctm.reward.model.Campaign;
import com.ctm.reward.model.GetCampaignsResponse;
import com.ctm.reward.model.OrderFormResponse;
import com.ctm.reward.model.SaleStatus;
import com.ctm.schema.address.v1_0_0.State;
import com.ctm.schema.health.v1_0_0.ApplyCompleteEvent;
import com.ctm.schema.health.v1_0_0.ApplyCompleteStatus;
import com.ctm.schema.health.v1_0_0.MembershipType;
import com.ctm.web.core.confirmation.services.DirectToCloudwatchEventsJoinNotificationSender;
import com.ctm.web.core.confirmation.services.JoinService;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailServiceHandler;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadService.services.LeadService;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.rememberme.services.RememberMeService;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.TouchService;
import com.ctm.web.core.services.TransactionAccessService;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.health.apply.model.response.HealthApplicationResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
import com.ctm.web.health.apply.model.response.PartnerError;
import com.ctm.web.health.apply.model.response.Status;
import com.ctm.web.health.exceptions.HealthApplyServiceException;
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
import com.ctm.web.health.utils.HealthRequestParser;
import com.ctm.web.health.validation.HealthApplicationValidation;
import com.ctm.web.reward.services.RewardCampaignService;
import com.ctm.web.reward.services.RewardService;
import com.ctm.web.simples.services.TransactionService;
import com.fasterxml.uuid.Generators;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
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
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.NotFoundException;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.InvalidParameterException;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
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

    private static final DateTimeFormatter LONG_FORMAT = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss zzz yyyy");
    public static final String PROVIDER_FAILED_MESSAGE = "The provider failed to process the application, Please contact support team.";

    @Autowired
    private HealthApplyService healthApplyService;

    @Autowired
    private JoinService joinService;

    @Autowired
    private DirectToCloudwatchEventsJoinNotificationSender cloudWatchNotifier;

    @Autowired
    private TransactionAccessService transactionAccessService;

    @Autowired
    private HealthConfirmationService healthConfirmationService;

    private LeadService leadService;
    private RewardService rewardService;
    private TransactionDetailsDao transactionDetailsDao;
    private RememberMeService rememberMeService;

    @Autowired
    public HealthApplicationController(SessionDataServiceBean sessionDataServiceBean,
                                       IPAddressHandler ipAddressHandler,
                                       TransactionDetailsDao transactionDetailsDao,
                                       HealthLeadService leadService,
                                       RewardService rewardService,
                                       RememberMeService rememberMeService) {
        super(sessionDataServiceBean, ipAddressHandler);
        this.transactionDetailsDao = transactionDetailsDao;
        this.leadService = leadService;
        this.rewardService = rewardService;
        this.rememberMeService = rememberMeService;
    }

    @ApiOperation(value = "apply/get.json", notes = "Submit an health application", produces = "application/json")
    @RequestMapping(value = "/apply/get.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8", MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public HealthResultWrapper getHealthApply(@ModelAttribute final HealthRequest data,
                                              BindingResult bindingResult,
                                              HttpServletRequest request,
                                              final HttpServletResponse httpServletResponse) throws DaoException, IOException, ServiceConfigurationException, ConfigSettingException, GeneralSecurityException, HealthApplyServiceException {

        if (bindingResult.hasErrors()) {
            for (ObjectError e : bindingResult.getAllErrors()) {
                LOGGER.error("FORM POST MAPPING ERROR: {},", kv("error", e));
            }
        }

        if (data.getHealth().getApplication().getPrimary().getFirstname() != null && data.getHealth().getPayment().getMedicare().getFirstName() == null) {
            data.getHealth().getPayment().getMedicare().setFirstName(data.getHealth().getApplication().getPrimary().getFirstname());
        }

        if (data.getHealth().getApplication().getPrimary().getSurname() != null && data.getHealth().getPayment().getMedicare().getSurname() == null) {
            data.getHealth().getPayment().getMedicare().setSurname(data.getHealth().getApplication().getPrimary().getSurname());
        }

        List<SchemaValidationError> validationErrors = HealthApplicationValidation.validateCoverType(data);
        if (!validationErrors.isEmpty()) {
            throw new RouterException(data.getTransactionId(), validationErrors);
        }
        final Vertical.VerticalType vertical = HEALTH;
        final boolean isCallCentre = "true".equals(request.getSession().getAttribute("callCentre")); //TODO should this be isOperatorLoggedIn() ??
        final Optional<AuthenticatedData> authenticatedData = Optional.ofNullable(sessionDataServiceBean.getAuthenticatedSessionData(request));

        // Initialise request
        final Brand brand = initRouter(request, vertical);
        updateTransactionIdAndClientIP(request, data);
        updateApplicationDate(request, data);


        // Create placeholder order, only if ONLINE.
        // There's a chance of failure but RewardService will log any errors.
        // It will also be empty if executed by Consultant, or no active campaigns.
        Optional<String> placeholderRedemptionId = Optional.ofNullable(rewardService.createPlaceholderOrderForOnline(request, SaleStatus.Processing, data.getTransactionId().toString()));
        placeholderRedemptionId.ifPresent(id -> persistRedemptionId(id, data.getTransactionId()));

        // get the response
        HealthApplyResponse applyResponse;

        try {
            applyResponse = healthApplyService.apply(request, brand, data);
        } catch (HealthApplyServiceException e) {
            LOGGER.error(String.format("healthApplyService.apply threw an exception with message: %1$s", e.getMessage()), e);
            if (isCallCentre) {
                final List<ResponseError> errors = new ArrayList<>();
                ResponseError error = new ResponseError();
                error.setCode("APPLY_ERROR");
                error.setDescription(e.getMessage());
                error.setText(e.getMessage());
                error.setOriginal(e.getMessage());
                errors.add(error);
                HealthApplicationResult result = new HealthApplicationResult();
                result.setSuccess(false);
                result.setErrors(errors);
                final HealthResultWrapper resultWrapper = new HealthResultWrapper();
                resultWrapper.setResult(result);
                return resultWrapper;
            } else {
                throw e;
            }
        }

        // Should only be one payload response
        final HealthApplicationResponse response = applyResponse.getPayload();

        // Create the confirmationId
        final String confirmationId = request.getSession().getId() + "-" + data.getTransactionId();

        // Get the productId removing the PHIO-HEALTH- prefix, if required
        final String productId;
        if (data.getQuote().getApplication().getProductId().contains("HEALTH-")) {
            productId = data.getQuote().getApplication().getProductId()
                    .substring(data.getQuote().getApplication().getProductId().indexOf("HEALTH-") + 7);
        } else {
            productId = data.getQuote().getApplication().getProductId();
        }

        // Get the productCode
        final String productCode = data.getQuote().getApplication().getProductName();
        final String providerId = data.getQuote().getApplication().getProviderId();

        LOGGER.info(String.format("isCallCentre: %1$s, confirmationId: %2$s, productId: %3$s, productCode: %4$s, providerId: %5$s", (isCallCentre ? "Y" : "N"), confirmationId, productId, productCode, providerId));

        HealthApplicationResult result = new HealthApplicationResult();

        if (Status.Success.equals(response.getSuccess())) {
            LOGGER.info("Successful response received from health-apply service.");

            result.setSuccess(true);
            result.setConfirmationID(confirmationId);

            request.setAttribute("applicationResponse", applyResponse);
            request.setAttribute("requestData", data);
            request.setAttribute("confirmationId", confirmationId);
            request.setAttribute("providerQuoteId", response.getProductId());

            // Record Confirmation touch
            recordTouch(request, data, productId, Touch.TouchType.SOLD);

            // write to join
            boolean successfulJoin = joinService.writeJoin(data.getTransactionId(), productId, productCode, providerId);

            if (successfulJoin) {
                String providerCode = data.getQuote().getApplication().getProvider();
                String productName = data.getQuote().getApplication().getProductTitle();
                String state = data.getQuote().getSituation().getState();
                String membershipType = data.getQuote().getSituation().getHealthCvr();
                ApplyCompleteEvent applyCompleteEvent = createCompleteEvent(providerCode, productName, state, membershipType, productId, ApplyCompleteStatus.SUCCESS);
                cloudWatchNotifier.send(applyCompleteEvent, response);
            }

            TransactionService.writeAllowableErrors(data.getTransactionId(), getErrors(response.getErrorList(), true));

            // write to transaction_details the policy_no
            writePolicyNoToTransactionDetails(data, response);

            final Data dataBucket = getDataBucket(request, data.getTransactionId());

            // Update the online reward placeholder with the outcome of the join
            if (placeholderRedemptionId.isPresent()) {
                rewardService.setOrderSaleStatusToSale(placeholderRedemptionId.orElse(""));
            }

            if (isCallCentre) {
                final GetCampaignsResponse campaigns = rewardService.getAllActiveCampaigns(request);
                final Campaign campaign = campaigns.getCampaigns().stream()
                        .filter(RewardCampaignService.isValidForPlaceholder())
                        .findFirst().orElse(null);

                // Is there an existing reward order recorded against this transaction?
                final String redemptionId = dataBucket.getString(RewardService.XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID);
                if (redemptionId != null) {
                    // Check if there is current active & eligible campaign
                    if (campaign == null) {
                        rewardService.setOrderSaleStatusToSale(redemptionId);
                    } else {
                        final OrderFormResponse order = rewardService.getOrder(redemptionId, request);
                        if (!order.getStatus()) {
                            // Something went wrong...
                            LOGGER.error("Failed to get order. message={}", order.getMessage());
                        } else if (order.getOrderHeader().getSaleStatus() != SaleStatus.Sale) {
                            // If existing order is not "sold" then mark as sold
                            rewardService.setOrderSaleStatusToSale(redemptionId);
                        } else {
                            // Create a new reward placeholder because this is a split transaction
                            final OrderFormResponse orderResponse = rewardService.createOrderAndUpdateBucket(dataBucket, authenticatedData, SaleStatus.Sale, campaign.getCampaignCode());
                            if (orderResponse != null && orderResponse.getEncryptedOrderLineId().isPresent()) {
                                persistRedemptionId(orderResponse.getEncryptedOrderLineId().get(), data.getTransactionId());
                            }
                        }
                    }
                } else if (campaign != null) {
                    // No order recorded against this transaction and current active campaign
                    // Create a new placeholder reward order
                    final OrderFormResponse orderResponse = rewardService.createOrderAndUpdateBucket(dataBucket, authenticatedData, SaleStatus.Sale, campaign.getCampaignCode());
                    if (orderResponse != null && orderResponse.getEncryptedOrderLineId().isPresent()) {
                        persistRedemptionId(orderResponse.getEncryptedOrderLineId().get(), data.getTransactionId());
                    }
                }
            }

            healthConfirmationService.createAndSaveConfirmation(request, data, response, confirmationId, dataBucket);

            // TODO: add competition entry

            sendEmail(request, data, vertical, brand, dataBucket);

            leadService.sendLead(4, dataBucket, request, "SOLD", brand.getCode());

            // Check outcome was ok --%>
            LOGGER.info("Transaction has been set to confirmed. {},{}", kv("transactionId", data.getTransactionId()), kv("confirmationID", confirmationId));

        } else {
            LOGGER.info("Valid but failed response received from health-apply service.");

            // Update the online placeholder with the outcome of the join
            if (!isCallCentre && placeholderRedemptionId.isPresent()) {
                rewardService.setOrderSaleStatusToFailed(placeholderRedemptionId.get());
            }

            // Set callCentre property only when it's not a success
            result.setCallcentre(isCallCentre);
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
            if (!isCallCentre) {
                setToPending(request, data, confirmationId, productId, productCode, providerId, getErrors(response.getErrorList(), false));
            } else {
                // just record a failure
                recordTouch(request, data, productId, Touch.TouchType.FAIL);
            }

            leadService.sendLead(4, getDataBucket(request, data.getTransactionId()), request, "PENDING", brand.getCode());
        }

        LOGGER.info("Health application complete. {},{}", kv("transactionId", data.getTransactionId()), kv("response", result));

        rememberMeService.deleteCookie(Vertical.VerticalType.HEALTH.name(), request, httpServletResponse);

        final HealthResultWrapper resultWrapper = new HealthResultWrapper();
        resultWrapper.setResult(result);
        return resultWrapper;
    }


    private boolean isOperatorLoggedIn(final Optional<AuthenticatedData> authenticatedSessionData) {
        return authenticatedSessionData.map(AuthenticatedData::getUid).map(s -> !s.isEmpty()).orElse(false);
    }

    private void persistRedemptionId(final String redemptionId, final long transactionId) {
        TransactionDetail td = new TransactionDetail(RewardService.XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID, redemptionId);
        td.setSequenceNo(RewardService.XPATH_SEQUENCE_NO_ENCRYPTED_ORDER_LINE_ID);
        try {
            transactionDetailsDao.addTransactionDetailsWithDuplicateKeyUpdate(transactionId, td);
            LOGGER.info("Reward: Persisted redemptionId. redemptionId={}, transactionId={}", redemptionId, transactionId);
        } catch (DaoException e) {
            LOGGER.error("Reward: Failed to persist redemptionId. redemptionId={}, transactionId={}", redemptionId, transactionId);
        }
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
            confirmationEmailCode = emailServiceHandler.send(request, email, data.getTransactionId(), HealthRequestParser.getProductIdFromHealthRequest(data));
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
            if (StringUtils.isNotEmpty(response.getProductId())) {
                transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -2, "health/policyNo", response.getProductId());
            } else {
                throw new InvalidParameterException("Cannot insert transaction detail for xpath: health/policyNo with empty textValue.");
            }
        } catch (Exception e) {
            LOGGER.warn("Failed to add transactionDetail {} because {}", data.getTransactionId(), e);
        }
    }

    private void setToPending(HttpServletRequest request, HealthRequest data, String confirmationId, String productId, String productCode, String providerId, String errorMessage) throws DaoException {
        recordTouch(request, data, productId, Touch.TouchType.FAIL);

        // Add trigger
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -5, "pending", ZonedDateTime.now().format(LONG_FORMAT));
        // Add fatalerrorreason
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -6, "fatalerrorreason", "Pending: Application failed: " + errorMessage);
        // Add pendingId
        transactionAccessService.addTransactionDetailsWithDuplicateKeyUpdate(data.getTransactionId(), -7, "pendingID", confirmationId);

        // write to join
        boolean successfulJoin = joinService.writeJoin(data.getTransactionId(), productId, productCode, providerId);

        if (successfulJoin) {
            String providerCode = data.getQuote().getApplication().getProvider();
            String productName = data.getQuote().getApplication().getProductTitle();
            String state = data.getQuote().getSituation().getState();
            String membershipType = data.getQuote().getSituation().getHealthCvr();
            ApplyCompleteEvent applyCompleteEvent = createCompleteEvent(providerCode, productName, state, membershipType, productId, ApplyCompleteStatus.ERROR);
            cloudWatchNotifier.send(applyCompleteEvent, request.getAttribute("applicationResponse"));
        }
    }

    private void recordTouch(HttpServletRequest request, HealthRequest data, String productId, Touch.TouchType type) {
        String providerCode = data.getQuote().getApplication().getProvider();
        String productName = data.getQuote().getApplication().getProductTitle();
        Touch touch = new Touch();
        touch.setType(type);
        touch.setTransactionId(data.getTransactionId());
        TouchService.getInstance().recordTouchWithProductCode(request, touch, productId, productName, providerCode);
    }

    private ApplyCompleteEvent createCompleteEvent(String providerCode, String productName, String state, String membershipType, String productId, ApplyCompleteStatus status) {
        ApplyCompleteEvent applyCompleteEvent = new ApplyCompleteEvent()
                .withWhitelabel("CTM")
                .withProviderCode(providerCode)
                .withSaleID(Generators.timeBasedGenerator().generate().toString())
                .withSaleDate(ZonedDateTime.now())
                .withProductName(productName)
                .withState(State.fromValue(state))
                .withMembershipType(MembershipType.fromValue(getMembershipType(membershipType)))
                .withProductID(productId)
                .withApplyCompleteStatus(status)
                .withSource("healthApply");

        return applyCompleteEvent;
    }

    private String getMembershipType(String type) {
        switch (type) {
            case "SM":
            case "SF":
                return "SINGLE";
            case "C":
                return "COUPLE";
            case "SPF":
                return "SINGLE_PARENT_FAMILY";
            case "F":
                return "FAMILY";
            case "EF":
                return "EXTENDED_FAMILY";
            case "ESP":
                return "EXTENDED_SINGLE_PARENT_FAMILY";
        }
        return "";
    }
}
