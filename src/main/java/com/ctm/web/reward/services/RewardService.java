package com.ctm.web.reward.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.reward.model.*;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.router.HealthApplicationController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import rx.schedulers.Schedulers;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.util.Optional;

@Service
public class RewardService {
	private static final Logger LOGGER = LoggerFactory.getLogger(RewardService.class);

	public static final String XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID = "current/encryptedOrderLineId";
	public static final int XPATH_SEQUENCE_NO_ENCRYPTED_ORDER_LINE_ID = -99;
	public static final String CURRENT_ROOT_ID = "current/rootId";

	public static final String REWARD_ENDPOINT_CREATE_ORDER = "/orders/create";
	public static final String REWARD_ENDPOINT_UPDATE_SALE_STATUS = "/orderlines/updateSaleStatus";
	public static final String REWARD_ENDPOINT_UPDATE_ORDER_LINE = "/orderlines/update";
	public static final String REWARD_ENDPOINT_CAMPAIGNS_GET = "/campaigns/get";

	private static final int SERVICE_TIMEOUT = 10000;

	@Value("${ctm.reward.url}")
	private String rewardServiceUrl;

	private TransactionDetailsDao transactionDetailsDao;
	private Client<UpdateSaleStatus, UpdateSaleStatusResponse> rewardUpdateSalesStatusClient;
	private Client<GetCampaigns, GetCampaignsResponse> rewardCampaignsGetClient;

	@Autowired
	public RewardService(TransactionDetailsDao transactionDetailsDao,
						 Client<UpdateSaleStatus, UpdateSaleStatusResponse> rewardUpdateSalesStatusClient,
						 Client<GetCampaigns, GetCampaignsResponse> rewardCampaignsGetClient) {
		this.transactionDetailsDao = transactionDetailsDao;
		this.rewardUpdateSalesStatusClient = rewardUpdateSalesStatusClient;
		this.rewardCampaignsGetClient = rewardCampaignsGetClient;
	}

	public GetCampaignsResponse getAllActiveCampaigns(final Vertical.VerticalType vertical, final String brandCode,
													  final ZonedDateTime effectiveDateTime) {
		GetCampaigns request = new GetCampaigns();
		request.setBrandCode(brandCode);
		request.setVerticalCode(vertical.getCode());
		request.setEffectiveDateTime(effectiveDateTime);

		return rewardCampaignsGetClient.post(RestSettings.<GetCampaigns>builder()
				.request(request)
				.response(GetCampaignsResponse.class)
				.jsonHeaders()
				.url(rewardServiceUrl + REWARD_ENDPOINT_CAMPAIGNS_GET)
				.timeout(SERVICE_TIMEOUT)
				.build())
				.observeOn(Schedulers.io())
				.toBlocking().single();
	}

	public void setOrderSaleStatusToFailed(final String encryptedOrderLineId) {
		updateOrderSalesStatus(encryptedOrderLineId, SaleStatus.Failed);
	}

	public void setOrderSaleStatusToSuccess(final String encryptedOrderLineId) {
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
