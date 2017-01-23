package com.ctm.web.reward.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.reward.model.GetTrackingStatus;
import com.ctm.reward.model.TrackingStatusResponse;
import com.ctm.reward.model.UpdateTrackingStatus;
import com.ctm.reward.model.UpdateTrackingStatusResponse;
import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.email.services.token.EmailTokenServiceFactory;
import com.ctm.web.core.services.SettingsService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import rx.Observable;
import rx.schedulers.Schedulers;

import java.util.Map;

@Service
public class RewardTrackingService {
	private static final Logger LOGGER = LoggerFactory.getLogger(RewardTrackingService.class);

	private static final String REWARD_ENDPOINT_TRACKING_STATUS = "/orderlines/getTrackingStatus";
	private static final String REWARD_ENDPOINT_TRACKING_OPTIN = "/orderlines/updateTrackingOptIn";
	private static final int SERVICE_TIMEOUT = 10000;

	private Client<GetTrackingStatus, TrackingStatusResponse> rewardGetTracking;
	private Client<UpdateTrackingStatus, UpdateTrackingStatusResponse> rewardTrackingOptin;

	@Value("${ctm.reward.url}")
	private String rewardServiceUrl;

	@Autowired
	public RewardTrackingService(Client<GetTrackingStatus, TrackingStatusResponse> rewardGetTracking,
								 Client<UpdateTrackingStatus, UpdateTrackingStatusResponse> rewardTrackingOptin) {
		this.rewardGetTracking = rewardGetTracking;
		this.rewardTrackingOptin = rewardTrackingOptin;
	}

	public TrackingStatusResponse getTrackingStatus(final String trackingToken) {
		if (trackingToken == null || StringUtils.isBlank(trackingToken)) {
			LOGGER.error("Reward: Invalid token. trackingToken={}", trackingToken);
			return null;
		}
		try {
			// Decrypt the access token
			// It just contains "transactionId" which we hijacked to hold the orderLineId
			final EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(SettingsService.getPageSettings(0, "GENERIC"));
			final Map<String, String> params = emailTokenService.decryptToken(trackingToken);
			final String unencrypedOrderLineId = params.get("transactionId");
			final String tokenAction = params.get("action");

			if (!"TOY_TRACKER".equals(tokenAction)) {
				LOGGER.error("Reward: Error getting tracking status. orderLineId={}, tokenAction={}", unencrypedOrderLineId, tokenAction);
				return null;
			}

			GetTrackingStatus request = new GetTrackingStatus();
			request.setUnEncryptedOrderLineId(Integer.parseInt(unencrypedOrderLineId));

			LOGGER.info("Reward: Get tracking status. orderLineId={}", unencrypedOrderLineId);

			final String url = rewardServiceUrl + REWARD_ENDPOINT_TRACKING_STATUS;
			return rewardGetTracking.post(RestSettings.<GetTrackingStatus>builder()
					.request(request)
					.response(TrackingStatusResponse.class)
					.jsonHeaders()
					.url(url)
					.timeout(SERVICE_TIMEOUT)
					.retryAttempts(1)
					.build())
					.observeOn(Schedulers.io())
					.onErrorResumeNext(throwable -> {
						LOGGER.error("Reward: Error getting tracking status. orderLineId={}, url={}", unencrypedOrderLineId, url, throwable);
						return Observable.just(null);
					})
					.toBlocking()
					.single();

		} catch (Exception e) {
			LOGGER.error("Reward: Error getting tracking status. trackingToken={}", trackingToken, e);
			return null;
		}
	}

	public UpdateTrackingStatusResponse optOutOfTracking(final String trackingToken) {
		if (trackingToken == null || StringUtils.isBlank(trackingToken)) {
			LOGGER.error("Reward: Invalid token. trackingToken={}", trackingToken);
			return null;
		}
		try {
			// Decrypt the access token
			// It just contains "transactionId" which we hijacked to hold the orderLineId
			final EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(SettingsService.getPageSettings(0, "GENERIC"));
			final Map<String, String> params = emailTokenService.decryptToken(trackingToken);
			final String unencrypedOrderLineId = params.get("transactionId");
			final String tokenAction = params.get("action");

			if (!"TOY_TRACKER_UNSUBSCRIBE".equals(tokenAction)) {
				LOGGER.error("Reward: Error updating tracking optin. orderLineId={}, tokenAction={}", unencrypedOrderLineId, tokenAction);
				return null;
			}

			UpdateTrackingStatus request = new UpdateTrackingStatus();
			request.setUnEncryptedOrderLineId(Integer.parseInt(unencrypedOrderLineId));
			request.setTrackerOptIn(false);

			LOGGER.info("Reward: optOutOfTracking. orderLineId={}", unencrypedOrderLineId);

			final String url = rewardServiceUrl + REWARD_ENDPOINT_TRACKING_OPTIN;
			return rewardTrackingOptin.post(RestSettings.<UpdateTrackingStatus>builder()
					.request(request)
					.response(UpdateTrackingStatusResponse.class)
					.jsonHeaders()
					.url(url)
					.timeout(SERVICE_TIMEOUT)
					.retryAttempts(1)
					.build())
					.observeOn(Schedulers.io())
					.onErrorResumeNext(throwable -> {
						LOGGER.error("Reward: Error updating tracking optin. orderLineId={}, url={}", unencrypedOrderLineId, url, throwable);
						return Observable.just(null);
					})
					.toBlocking()
					.single();

		} catch (Exception e) {
			LOGGER.error("Reward: Error updating tracking optin. trackingToken={}", trackingToken, e);
			return null;
		}
	}
}
