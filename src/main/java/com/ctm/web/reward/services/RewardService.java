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

	public static final String XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID = "current/encryptedOrderLineId";
	public static final int XPATH_SEQUENCE_NO_ENCRYPTED_ORDER_LINE_ID = -99;

	public static final String REWARD_ENDPOINT_GET_ORDER = "/orders/get";
	public static final String REWARD_ENDPOINT_CREATE_ORDER = "/orders/create";
	public static final String REWARD_ENDPOINT_UPDATE_SALE_STATUS = "/orderlines/updateSaleStatus";
	public static final String REWARD_ENDPOINT_UPDATE_ORDER_LINE = "/orderlines/update";

	public static final int SERVICE_TIMEOUT = 10000;

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

	@Autowired
	public RewardService(Client<OrderForm, UpdateResponse> rewardUpdateOrderClient,
						 Client<UpdateSaleStatus, UpdateSaleStatusResponse> rewardUpdateSalesStatusClient,
						 Client<OrderForm, OrderFormResponse> rewardCreateOrderClient,
						 Client<GetOrder, OrderFormResponse> rewardGetOrderClient,
						 RewardCampaignService rewardCampaignService,
						 ApplicationService applicationService,
						 SessionDataServiceBean sessionDataServiceBean) {
		this.rewardUpdateOrderClient = rewardUpdateOrderClient;
		this.rewardUpdateSalesStatusClient = rewardUpdateSalesStatusClient;
		this.rewardCreateOrderClient = rewardCreateOrderClient;
		this.rewardGetOrderClient = rewardGetOrderClient;
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

			final OrderFormResponse response = createOrder(data, authenticatedData, saleStatus, campaign.getCampaignCode());
			if (response != null && response.getEncryptedOrderLineId().isPresent()) {
				return response.getEncryptedOrderLineId().get();
			} else {
				// Error is logged in createOrder()
				return null;
			}
		}
		catch (Exception e) {
			LOGGER.error("Reward: Failed to createPlaceholderOrderForOnline. transactionId={}", transactionId, e);
			return null;
		}
	}

	public OrderFormResponse createOrder(final Data data, Optional<AuthenticatedData> authenticatedData,
										 final SaleStatus saleStatus, final String campaignCode) {
		try {
			RewardRequestParser rewardRequestParser = new RewardRequestParser();
			OrderForm orderForm = rewardRequestParser.adaptFromDatabucket(authenticatedData, data, saleStatus, campaignCode);
			OrderFormResponse orderFormResponse = remoteCreateOrder(orderForm);

			if (orderFormResponse != null && orderFormResponse.getStatus() && orderFormResponse.getEncryptedOrderLineId().isPresent()) {
				data.put(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID, orderFormResponse.getEncryptedOrderLineId().get());
				LOGGER.info("Reward: Created order. rootId={}, getEncryptedOrderLineId={}",
						orderForm.getOrderHeader().getRootId().orElse(0L), orderFormResponse.getEncryptedOrderLineId().get());
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
		// TODO how to get if user is in group CTM-CC-REWARDS
		return getOrder(redemptionId, authenticatedData.map(AuthenticatedData::getUid), false);
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
				.toBlocking()
				.first();
	}

	public UpdateResponse updateOrder(final OrderForm form) {
		try {
			final UpdateResponse response = remoteUpdateOrder(form);

			if (response != null && response.getStatus()) {
				LOGGER.info("Reward: Updated order. orderHeaderId={}, ", form.getOrderHeader().getOrderHeaderId());
				return response;
			} else {
				throw new Exception("Update order failed. status=" + ((response != null) ? response.getStatus() : "")
						+ ", message={}" + ((response != null) ? response.getMessage() : ""));
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
				.toBlocking()
				.first();
	}
}
