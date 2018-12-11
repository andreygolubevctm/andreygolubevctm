package com.ctm.web.reward.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.reward.model.*;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.reward.utils.RewardRequestParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.SerializationFeature;
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

	private static final String ELEVATED_USER_GROUP = "CTM-CC-REWARDS";
	public static final String XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID = "current/encryptedOrderLineId";
	public static final int XPATH_SEQUENCE_NO_ENCRYPTED_ORDER_LINE_ID = -99;

	public static final String REWARD_ENDPOINT_GET_ORDER = "/orders/get";
	public static final String REWARD_ENDPOINT_CREATE_ORDER = "/orders/create";
	public static final String REWARD_ENDPOINT_UPDATE_SALE_STATUS = "/orderlines/updateSaleStatus";
	public static final String REWARD_ENDPOINT_UPDATE_ORDER_LINE = "/orderlines/update";
	public static final String REWARD_ENDPOINT_FIND_ORDER_LINES = "/orderlines/find";

	public static final int SERVICE_TIMEOUT = 30000;
	public static final int SERVICE_TIMEOUT_FIND = 50000;

	@Value("${ctm.reward.url}")
	private String rewardServiceUrl;

	@Autowired
	private SerializationMappers objectMapper;

	private RewardCampaignService rewardCampaignService;
	private ApplicationService applicationService;
	private SessionDataServiceBean sessionDataServiceBean;
	private Client<OrderForm, UpdateResponse> rewardUpdateOrderClient;
	private Client<UpdateSaleStatus, UpdateSaleStatusResponse> rewardUpdateSalesStatusClient;
	private Client<OrderForm, OrderFormResponse> rewardCreateOrderClient;
	private Client<GetOrder, OrderFormResponse> rewardGetOrderClient;
	private Client<FindRequest, FindResponse> rewardFindOrdersClient;

	@Autowired
	public RewardService(Client<OrderForm, UpdateResponse> rewardUpdateOrderClient,
						 Client<UpdateSaleStatus, UpdateSaleStatusResponse> rewardUpdateSalesStatusClient,
						 Client<OrderForm, OrderFormResponse> rewardCreateOrderClient,
						 Client<GetOrder, OrderFormResponse> rewardGetOrderClient,
						 Client<FindRequest, FindResponse> rewardFindOrdersClient,
						 RewardCampaignService rewardCampaignService,
						 ApplicationService applicationService,
						 SessionDataServiceBean sessionDataServiceBean) {
		this.rewardUpdateOrderClient = rewardUpdateOrderClient;
		this.rewardUpdateSalesStatusClient = rewardUpdateSalesStatusClient;
		this.rewardCreateOrderClient = rewardCreateOrderClient;
		this.rewardGetOrderClient = rewardGetOrderClient;
		this.rewardFindOrdersClient = rewardFindOrdersClient;
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

		final Optional<AuthenticatedData> authenticatedData = Optional.ofNullable(sessionDataServiceBean.getAuthenticatedSessionData(request));

		boolean getFromCache = true;
		boolean operatorElevated = false;
		ZonedDateTime effective = ZonedDateTime.now();
		final Date appDate = ApplicationService.getApplicationDateIfSet(request);
		if (appDate != null) {
			effective = ZonedDateTime.ofInstant(appDate.toInstant(), ZoneId.systemDefault());
			LOGGER.info("Reward: getAllActiveCampaigns effective date overridden by session applicationDate: {}", effective);
			getFromCache = false;
		}
		else if (authenticatedData.map(AuthenticatedData::getUid).isPresent() && hasElevatedPrivileges(request)) {
			// These people can do adhoc orders so make sure they do not get cached response
			LOGGER.info("Reward: getAllActiveCampaigns cache busted. operatorId={}", authenticatedData.map(AuthenticatedData::getUid).orElse(null));
			getFromCache = false;
			operatorElevated = true;
		}
		//TODO else if get the "journey start time" from session

		return getAllActiveCampaigns(vertical, brand.getCode(), effective, getFromCache, operatorElevated);
	}

	public GetCampaignsResponse getAllActiveCampaigns(final Vertical.VerticalType vertical, final String brandCode,
													  final ZonedDateTime effectiveDateTime,
													  final boolean getFromCache,
													  final boolean operatorElevated) {
		// Round the time so we can hit the cache
		final ZonedDateTime roundedEffective = roundupMinutes(effectiveDateTime);
		return rewardCampaignService.getAllActiveCampaigns(vertical, brandCode, roundedEffective, getFromCache,
				operatorElevated);
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
		request.setSaleStatus(saleStatus);

		final String loggerPattern = "Reward: Set sale status: status={}, encryptedOrderLineId={}, saleStatus={}";

		rewardUpdateSalesStatusClient.post(RestSettings.<UpdateSaleStatus>builder()
				.request(request)
				.response(UpdateSaleStatusResponse.class)
				.jsonHeaders()
				.url(rewardServiceUrl + REWARD_ENDPOINT_UPDATE_SALE_STATUS)
				.timeout(SERVICE_TIMEOUT)
				.build())
				.observeOn(Schedulers.io())
				.subscribe(response -> LOGGER.info(loggerPattern, response.getStatus(), encryptedOrderLineId, saleStatus),
						error -> LOGGER.error(loggerPattern, false, encryptedOrderLineId, saleStatus, error));
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
			if (authenticatedData.map(AuthenticatedData::getUid).map(s -> !s.isEmpty()).orElse(false)) {
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

			final OrderFormResponse response = createOrderAndUpdateBucket(data, authenticatedData, saleStatus, campaign.getCampaignCode());
			if (response != null && response.getEncryptedOrderLineId().isPresent()) {
				return response.getEncryptedOrderLineId().get();
			} else {
				// Error is logged in createOrderAndUpdateBucket()
				return null;
			}
		}
		catch (Exception e) {
			LOGGER.error("Reward: Failed to createPlaceholderOrderForOnline. errorMessage={}, transactionId={}", e.getMessage(), transactionId, e);
			return null;
		}
	}

	public OrderFormResponse createOrderAndUpdateBucket(final Data data, final Optional<AuthenticatedData> authenticatedData,
														final SaleStatus saleStatus, final String campaignCode) {
		try {
			RewardRequestParser rewardRequestParser = new RewardRequestParser();
			OrderForm orderForm = rewardRequestParser.adaptFromDatabucket(authenticatedData, data, saleStatus, campaignCode);
			OrderFormResponse orderFormResponse = remoteCreateOrder(orderForm);

			if (orderFormResponse != null && orderFormResponse.getStatus() && orderFormResponse.getEncryptedOrderLineId().isPresent()) {
				data.put(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID, orderFormResponse.getEncryptedOrderLineId().get());
				LOGGER.info("Reward: Created order. rootId={}, encryptedOrderLineId={}, campaignCode={}",
						orderForm.getOrderHeader().getRootId().orElse(0L),
						orderFormResponse.getEncryptedOrderLineId().get(),
						campaignCode);
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

	public OrderFormResponse createAdhocOrder(final OrderForm form, final HttpServletRequest request) {
		final Optional<AuthenticatedData> authenticatedData = Optional.ofNullable(sessionDataServiceBean.getAuthenticatedSessionData(request));

		final String operatorId = authenticatedData.map(AuthenticatedData::getUid).orElse(null);

		// Must be logged into Simples and be in elevated privilege group
		if (authenticatedData.map(AuthenticatedData::getUid).isPresent() && hasElevatedPrivileges(request)) {
			// Check mandatory fields
			if (form.getOrderHeader().getReasonCode().isPresent()
					&& form.getOrderHeader().getOrderLine().getRewardTypeId().isPresent()) {
				// Push operatorId onto model as creator
				form.getOrderHeader().getOrderLine().setCreatedByOperator(operatorId);
				form.getOrderHeader().getOrderLine().setUpdatedByOperator(operatorId);

				OrderFormResponse orderFormResponse = remoteCreateOrder(form);

				LOGGER.info("Reward: Created adhoc order. operator={}, campaignCode={}, status={}",
						operatorId,
						form.getOrderHeader().getOrderLine().getCampaignCode(),
						orderFormResponse.getStatus());
				return orderFormResponse;
			} else {
				LOGGER.error("Reward: Adhoc order model must have: reasonCode, createdByOperator, rewardTypeId. operator={}",
						operatorId);
				OrderFormResponse response = new OrderFormResponse();
				response.setStatus(false);
				response.setMessage("Adhoc order model must have: reasonCode, createdByOperator, rewardTypeId.");
				return response;
			}
		}
		else {
			LOGGER.error("Reward: Not authenticated to create adhoc order.");
			OrderFormResponse response = new OrderFormResponse();
			response.setStatus(false);
			response.setMessage("Not authenticated to create order.");
			return response;
		}
	}

	public String getOrderAsJson(final String redemptionId, final HttpServletRequest request) {
		OrderFormResponse order = getOrder(redemptionId, request);
		try {
			objectMapper.getJsonMapper().configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
			return objectMapper.getJsonMapper().writeValueAsString(order);
		} catch (JsonProcessingException e) {
			LOGGER.error("Reward: Failed to serialise. redemptionId={}", redemptionId);
			return "{}";
		}
	}

	public OrderFormResponse getOrder(final String redemptionId, final HttpServletRequest request) {
		final Optional<AuthenticatedData> authenticatedData = Optional.ofNullable(sessionDataServiceBean.getAuthenticatedSessionData(request));
		return getOrder(redemptionId, authenticatedData.map(AuthenticatedData::getUid), hasElevatedPrivileges(request));
	}

	/**
		 * Get reward order.
		 * @param redemptionId The encrypted orderLineId
		 * @param operatorId Optional operator username
		 * @param operatorElevated Whether or not the operator has elevated privileges
		 */
	public OrderFormResponse getOrder(final String redemptionId, final Optional<String> operatorId, final boolean operatorElevated) {
		GetOrder request = new GetOrder(redemptionId);
		request.setOperatorElevated(operatorElevated);
		operatorId.ifPresent(request::setOperatorId);

		final String url = rewardServiceUrl + REWARD_ENDPOINT_GET_ORDER;
		return rewardGetOrderClient.post(RestSettings.<GetOrder>builder()
				.request(request)
				.response(OrderFormResponse.class)
				.jsonHeaders()
				.url(url)
				.timeout(SERVICE_TIMEOUT)
				.retryAttempts(1)
				.build())
				.observeOn(Schedulers.io())
				.onErrorResumeNext(throwable -> {
					LOGGER.error("Reward: Failed to get order. url={}, redemptionId={}, operatorId={}, operatorElevated={}",
							url, redemptionId, operatorId.orElse(""), operatorElevated, throwable);
					OrderFormResponse response = new OrderFormResponse();
					response.setStatus(false);
					return Observable.just(response);
				})
				.doOnNext(response -> {
					if (response.getStatus()) {
						LOGGER.info("Reward: getOrder success. redemptionId={}, operatorId={}, operatorElevated={}",
								redemptionId, operatorId.orElse(""), operatorElevated);
					}
				})
				.toBlocking()
				.first();
	}

	public FindResponse findOrders(final FindRequest form, final HttpServletRequest request) {
		final Optional<AuthenticatedData> authenticatedData = Optional.ofNullable(sessionDataServiceBean.getAuthenticatedSessionData(request));

		// Must be logged into Simples and be in elevated privilege group
		if (authenticatedData.map(AuthenticatedData::getUid).isPresent() && hasElevatedPrivileges(request)) {
			form.setSearchParam(form.getSearchParam().trim());
			final String url = rewardServiceUrl + REWARD_ENDPOINT_FIND_ORDER_LINES;
			return rewardFindOrdersClient.post(RestSettings.<FindRequest>builder()
					.request(form)
					.response(FindResponse.class)
					.jsonHeaders()
					.url(url)
					.timeout(SERVICE_TIMEOUT_FIND)
					.retryAttempts(1)
					.build())
					.observeOn(Schedulers.io())
					.onErrorResumeNext(throwable -> {
						LOGGER.error("Reward: Failed to find orders. url={}, searchParam={}", url, form.getSearchParam());
						FindResponse response = new FindResponse();
						response.setStatus(false);
						return Observable.just(response);
					})
					.doOnNext(response -> {
						if (response != null && response.getStatus() != null && response.getStatus()) {
							LOGGER.info("Reward: findOrders success. searchParam={}", form.getSearchParam());
						}
					})
					.toBlocking()
					.first();
		} else {
			LOGGER.error("Reward: Not authenticated to find orders.");
			FindResponse response = new FindResponse();
			response.setStatus(false);
			response.setMessage("Not authenticated to find orders.");
			return response;
		}
	}

	private OrderFormResponse remoteCreateOrder(final OrderForm form) {
		final String url = rewardServiceUrl + REWARD_ENDPOINT_CREATE_ORDER;
		return rewardCreateOrderClient.post(RestSettings.<OrderForm>builder()
				.request(form)
				.response(OrderFormResponse.class)
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
//				.doOnNext(response -> {
//					if (response != null && response.getStatus() != null && response.getStatus()) {
//						LOGGER.info("Reward: Created order. rootId={}, getEncryptedOrderLineId={}",
//								Optional.ofNullable(form).map(OrderForm::getOrderHeader).map(OrderHeader::getRootId).map(Optional::get).orElse(null),
//								Optional.of(response).map(OrderFormResponse::getEncryptedOrderLineId).map(Optional::get).orElse(null));
//					}
//				})
				.toBlocking()
				.first();
	}

	public UpdateResponse updateOrder(final OrderForm form, final HttpServletRequest request) {
		try {
			// Push operatorId as model updater if present
			final Optional<AuthenticatedData> authenticatedData = Optional.ofNullable(sessionDataServiceBean.getAuthenticatedSessionData(request));
			authenticatedData.map(AuthenticatedData::getUid).ifPresent(uid -> form.getOrderHeader().getOrderLine().setUpdatedByOperator(uid));

			final UpdateResponse response = remoteUpdateOrder(form);

			if (response != null && response.getStatus()) {
				return response;
			} else {
				throw new Exception("Update order failed. status=" + ((response != null) ? response.getStatus() : "")
						+ ", message=" + ((response != null) ? response.getMessage() : ""));
			}
		}
		catch (Exception e) {
			LOGGER.error("Reward: Failed to update order.", e);
			UpdateResponse response = new UpdateResponse();
			response.setStatus(false);
			return response;
		}
	}

	private UpdateResponse remoteUpdateOrder(final OrderForm form) {
		final String url = rewardServiceUrl + REWARD_ENDPOINT_UPDATE_ORDER_LINE;
		return rewardUpdateOrderClient.post(RestSettings.<OrderForm>builder()
				.request(form)
				.response(UpdateResponse.class)
				.jsonHeaders()
				.url(url)
				.timeout(SERVICE_TIMEOUT)
				.build())
				.observeOn(Schedulers.io())
				.onErrorResumeNext(throwable -> {
					LOGGER.error("Reward: Failed to update order. url={}", url, throwable);
					UpdateResponse response = new UpdateResponse();
					response.setStatus(false);
					return Observable.just(response);
				})
				.doOnCompleted(() -> {
					Optional<OrderLine> orderLine = Optional.ofNullable(form).map(OrderForm::getOrderHeader).map(OrderHeader::getOrderLine);
					LOGGER.info("Reward: Updated order. encryptedOrderLineId={}, updatedByOperator={}, orderStatus={}",
							orderLine.map(OrderLine::getEncryptedOrderLineId).orElse(null),
							orderLine.map(OrderLine::getUpdatedByOperator).orElse(null),
							orderLine.map(OrderLine::getOrderStatus).orElse(null));
				})
				.toBlocking()
				.first();
	}

	private boolean hasElevatedPrivileges(final HttpServletRequest request) {
		return request.isUserInRole(ELEVATED_USER_GROUP);
	}
}
