package com.ctm.web.reward.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.reward.model.*;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.reward.utils.RewardRequestParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import rx.Observable;
import rx.schedulers.Schedulers;

import javax.servlet.http.HttpServletRequest;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Service
public class RewardService {
	private static final Logger LOGGER = LoggerFactory.getLogger(RewardService.class);

	public static final String XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID = "current/encryptedOrderLineId";
	public static final int XPATH_SEQUENCE_NO_ENCRYPTED_ORDER_LINE_ID = -99;
	public static final String CURRENT_ROOT_ID = "current/rootId";

	public static final String REWARD_ENDPOINT_CREATE_ORDER = "/orders/create";
	public static final String REWARD_ENDPOINT_UPDATE_SALE_STATUS = "/orderlines/updateSaleStatus";
	public static final String REWARD_ENDPOINT_UPDATE_ORDER_LINE = "/orderlines/update";
	public static final String REWARD_ENDPOINT_TRACKING_STATUS = "/orderlines/getTrackingStatus";

	public static final int SERVICE_TIMEOUT = 10000;

	@Value("${ctm.reward.url}")
	private String rewardServiceUrl;

	private TransactionDetailsDao transactionDetailsDao;
	private RewardCampaignService rewardCampaignService;
	private ApplicationService applicationService;
	private SessionDataServiceBean sessionDataServiceBean;
	private Client<UpdateSaleStatus, UpdateSaleStatusResponse> rewardUpdateSalesStatusClient;
	private Client<OrderForm, OrderFormResponse> rewardCreateOrderClient;

	@Autowired
	public RewardService(TransactionDetailsDao transactionDetailsDao,
						 Client<UpdateSaleStatus, UpdateSaleStatusResponse> rewardUpdateSalesStatusClient,
						 Client<OrderForm, OrderFormResponse> rewardCreateOrderClient,
						 RewardCampaignService rewardCampaignService,
						 ApplicationService applicationService,
						 SessionDataServiceBean sessionDataServiceBean) {
		this.transactionDetailsDao = transactionDetailsDao;
		this.rewardUpdateSalesStatusClient = rewardUpdateSalesStatusClient;
		this.rewardCreateOrderClient = rewardCreateOrderClient;
		this.rewardCampaignService = rewardCampaignService;
		this.applicationService = applicationService;
		this.sessionDataServiceBean = sessionDataServiceBean;
	}

	/**
	 * Get list of campaigns that are active and eligible.
	 * EffectiveTime is gathered from applicationDate or journey start time.
	 */
	public GetCampaignsResponse getAllActiveCampaigns(HttpServletRequest request) {
		//TODO Health should not be hardcoded
		final Vertical.VerticalType vertical = HEALTH;
		Brand brand = applicationService.getBrand(request, vertical);

		ZonedDateTime effective = ZonedDateTime.now();
		final Date appDate = ApplicationService.getApplicationDateIfSet(request);
		if (appDate != null) {
			effective = ZonedDateTime.ofInstant(appDate.toInstant(), ZoneId.systemDefault());
			//} else if {
			//TODO get the "journey start time" from session
		}

		return getAllActiveCampaigns(vertical, brand.getCode(), effective);
	}

	public GetCampaignsResponse getAllActiveCampaigns(final Vertical.VerticalType vertical, final String brandCode,
													  final ZonedDateTime effectiveDateTime) {
		// Round the time so we can hit the cache
		final ZonedDateTime roundedEffective = roundupMinutes(effectiveDateTime);
		return rewardCampaignService.getAllActiveCampaigns(vertical, brandCode, roundedEffective);
	}

	/*
	Round the datetime to nearest future 2 minute block
	 */
	protected ZonedDateTime roundupMinutes(ZonedDateTime effective) {
		return effective.withSecond(0).withNano(0).plusMinutes((62 - effective.getMinute()) % 2);
	}

	public void setOrderSaleStatusToFailed(final String encryptedOrderLineId) {
		updateOrderSalesStatus(encryptedOrderLineId, SaleStatus.Failed);
	}

	public void setOrderSaleStatusToSale(final String encryptedOrderLineId) {
		updateOrderSalesStatus(encryptedOrderLineId, SaleStatus.Sale);
	}

	private void updateOrderSalesStatus(final String encryptedOrderLineId, final SaleStatus saleStatus) {
		UpdateSaleStatus request = new UpdateSaleStatus();
		request.setEncryptedOrderLineId(encryptedOrderLineId);
		request.setSaleStatus(saleStatus.name());

		final String loggerPattern = "Reward: Set sale status: status={}, encryptedOrderLineId={}, saleStatus={}";

		rewardUpdateSalesStatusClient.post(RestSettings.<UpdateSaleStatus>builder()
				.request(request)
				.jsonHeaders()
				.url(rewardServiceUrl + REWARD_ENDPOINT_UPDATE_SALE_STATUS)
				.timeout(SERVICE_TIMEOUT)
				.build())
				.observeOn(Schedulers.io())
				.subscribe(response -> LOGGER.info(loggerPattern, response.getStatus(), encryptedOrderLineId, saleStatus),
						error -> LOGGER.error(loggerPattern, false, encryptedOrderLineId, saleStatus, error));
	}

	public TrackingStatus getTrackingStatus(final String trackingToken) {
		//TODO Call reward service
		TrackingStatus trackingStatus = new TrackingStatus();
		trackingStatus.setFirstName("Jeffrey");
		trackingStatus.setOrderStatus("Scheduled");
		trackingStatus.setRewardType("sergei");
		trackingStatus.setStage("1");
		return trackingStatus;
	}

	/**
	 * Add a placeholder order into the Reward service when Online and eligible campaign exists.
	 * @param saleStatus Sale status to assign to the placeholder order
	 * @param transactionId Current tranId used to fetch the session data & databucket
	 * @return null if unsuccessful, otherwise: string is the encryptedOrderLineId of the placeholder record - also known as redemptionId.
	 */
	public String createPlaceholderOrderForOnline(final HttpServletRequest request, final SaleStatus saleStatus, final String transactionId) {
		try {
			final SessionData sessionData = sessionDataServiceBean.getSessionDataForTransactionId(request, transactionId);
			if (sessionData == null) {
				throw new SessionException("Session not found for transactionId=" + transactionId);
			}

			final Data data = sessionData.getSessionDataForTransactionId(transactionId);
			if (data == null) {
				throw new SessionException("Databucket not found for transactionId=" + transactionId);
			}

			final Optional<AuthenticatedData> authenticatedData = Optional.ofNullable(sessionData.getAuthenticatedSessionData());
			if (authenticatedData.isPresent() /*Does this require a getUid.isNotEmpty check?*/) {
				LOGGER.info("Reward: Abort createPlaceholderOrderForOnline because not Online user.");
				return null;
			}

			final GetCampaignsResponse campaigns = getAllActiveCampaigns(request);
			final Campaign campaign = campaigns.getCampaigns().stream()
					.filter(RewardCampaignService.isValidForPlaceholder())
					.findFirst().orElse(null);

			if (campaign == null) {
				LOGGER.info("Reward: Unable to createPlaceholderOrderForOnline because no valid campaign. transactionId={}", transactionId);
				return null;
			}

			OrderFormResponse response = createOrder(data, authenticatedData, saleStatus, campaign.getCampaignCode());
			if (response != null && response.getEncryptedOrderLineId().isPresent()) {
				return response.getEncryptedOrderLineId().get();
			} else {
				return null;
			}
		}
		catch (Exception e) {
			LOGGER.error("Reward: Failed to createPlaceholderOrderForOnline. transactionId={}", transactionId, e);
			return null;
		}
	}

	public OrderFormResponse createOrder(final Data data, Optional<AuthenticatedData> authenticatedSessionData,
										 final SaleStatus saleStatus, final String campaignCode) {
		try {
			RewardRequestParser rewardRequestParser = new RewardRequestParser();
			OrderForm orderForm = rewardRequestParser.adaptFromDatabucket(authenticatedSessionData, data, saleStatus, campaignCode);
			OrderFormResponse orderFormResponse = remoteCreateOrder(orderForm);

			if (orderFormResponse != null && orderFormResponse.getStatus() && orderFormResponse.getEncryptedOrderLineId().isPresent()) {
				data.put(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID, orderFormResponse.getEncryptedOrderLineId().get());
				return orderFormResponse;
			} else {
				throw new Exception("Create order failed. status=" + ((orderFormResponse != null) ? orderFormResponse.getStatus() : "")
						+ ", message={}" + ((orderFormResponse != null) ? orderFormResponse.getMessage() : ""));
			}
		}
		catch (Exception e) {
			LOGGER.error("Reward: Failed to create order. saleStatus={}, campaignCode={}", saleStatus.name(), campaignCode, e);
			OrderFormResponse form = new OrderFormResponse();
			form.setStatus(false);
			return form;
		}
	}

	private OrderFormResponse remoteCreateOrder(final OrderForm form) {
		final String url = rewardServiceUrl + REWARD_ENDPOINT_CREATE_ORDER;
		return rewardCreateOrderClient.post(RestSettings.<OrderForm>builder()
				.request(form)
				.jsonHeaders()
				.url(url)
				.timeout(SERVICE_TIMEOUT)
				.build())
				.observeOn(Schedulers.io())
				.onErrorResumeNext(throwable -> {
					LOGGER.error("Reward: Failed to create order. url={}", url, throwable);
					OrderFormResponse response = new OrderFormResponse();
					response.setStatus(false);
					return Observable.just(response);
				})
				.toBlocking()
				.first();
	}

//	private RedemptionForm saveRedemption(final HttpServletRequest request,
//										  final HealthRequest healthRequest,
//										  final Optional<AuthenticatedData> authenticatedSessionData,
//										  final String uri,
//										  final String touchType) throws DaoException {
//		final Data dataBucket = getDataBucket(request, healthRequest.getTransactionId());
//		final Optional<String> encryptedRedemptionId = Optional.ofNullable(dataBucket.getString(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID));
//
//		final RedemptionForm redemptionFormRequest = RedemptionForm.newBuilder()
//				.redemption(createRedemption(healthRequest, authenticatedSessionData, touchType, dataBucket))
//				.encryptedRedemptionId(encryptedRedemptionId.orElse(null))
//				.build();
//
//		final RedemptionForm redemptionFormResponse = saveRedemptionClient.post(redemptionFormRequest, RedemptionForm.class, rewardServiceUrl + uri)
//				.toBlocking().first();
//
//		dataBucket.put(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID, redemptionFormResponse.getEncryptedRedemptionId().get());
//
//		addRedemptionIdTransactionDetail(healthRequest, redemptionFormResponse);
//
//		return redemptionFormResponse;
//	}

//	private Redemption createRedemption(final HealthRequest healthRequest, final Optional<AuthenticatedData> authenticatedSessionData, final String touchType, final Data dataBucket) {
//		final Long rootId = Long.parseLong(dataBucket.getString(CURRENT_ROOT_ID));
//		final Optional<String> encryptedRedemptionId = Optional.ofNullable(dataBucket.getString(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID));
//
//		final Redemption.Builder redemptionBuilder = Redemption.newBuilder()
//				//.campaignId(Long.valueOf(request.getParameter("campaignId")))
//				.campaignId(1L) // HARD CODING campaignId for the time being!!!
//				.contactEmail(healthRequest.getHealth().getApplication().getEmail())
//				.createdTimestamp(LocalDateTime.now())
//				.firstName(healthRequest.getHealth().getApplication().getPrimary().getFirstname())
//				.lastName(healthRequest.getHealth().getApplication().getPrimary().getSurname())
//				.phoneNumber(Optional.ofNullable(healthRequest.getHealth().getApplication().getMobile())
//						.orElse(healthRequest.getHealth().getApplication().getOther()))
//				.rootId(rootId)
//				.touchType(touchType)
//				.shippingAddress(healthRequest.getHealth().getApplication().getAddress().getFullAddressLineOne())
//				//.signOnReceiptFlag(Boolean.valueOf(request.getParameter("signOnReceiptFlag")))
//				.signOnReceiptFlag(Boolean.FALSE); // HARD CODING signOnReceiptFlag for the time being!!!
//
//		if(encryptedRedemptionId.isPresent()) {
//			redemptionBuilder.updatedByOperator(authenticatedSessionData.map(AuthenticatedData::getUid).orElse(null));
//			redemptionBuilder.updatedTimestamp(LocalDateTime.now());
//		} else {
//			redemptionBuilder.createdByOperator(authenticatedSessionData.map(AuthenticatedData::getUid).orElse(null));
//			redemptionBuilder.createdTimestamp(LocalDateTime.now());
//		}
//
//		return redemptionBuilder.build();
//	}

//	private void addRedemptionIdTransactionDetail(final HealthRequest healthRequest, final RedemptionForm redemptionFormResponse) throws DaoException {
//		final TransactionDetail transactionDetail = new TransactionDetail();
//		transactionDetail.setSequenceNo(RewardService.XPATH_SEQUENCE_NO_ENCRYPTED_ORDER_LINE_ID);
//		transactionDetail.setTextValue(redemptionFormResponse.getEncryptedRedemptionId().get());
//		transactionDetail.setXPath(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID);
//		transactionDetailsDao.addTransactionDetailsWithDuplicateKeyUpdate(healthRequest.getTransactionId(), transactionDetail);
//	}
}
