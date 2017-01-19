package com.ctm.web.reward.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.reward.model.Campaign;
import com.ctm.reward.model.GetCampaigns;
import com.ctm.reward.model.GetCampaignsResponse;
import com.ctm.web.core.model.settings.Vertical;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import rx.Observable;
import rx.schedulers.Schedulers;

import java.time.ZonedDateTime;
import java.util.Collections;
import java.util.function.Predicate;

@Service
public class RewardCampaignService {
	private static final Logger LOGGER = LoggerFactory.getLogger(RewardCampaignService.class);

	private static final String REWARD_ENDPOINT_CAMPAIGNS_GET = "/campaigns/get";
	private static final int SERVICE_TIMEOUT = 6000;

	@Value("${ctm.reward.url}")
	private String rewardServiceUrl;

	private Client<GetCampaigns, GetCampaignsResponse> rewardCampaignsGetClient;

	@Autowired
	public RewardCampaignService(Client<GetCampaigns, GetCampaignsResponse> rewardCampaignsGetClient) {
		this.rewardCampaignsGetClient = rewardCampaignsGetClient;
	}

	public static Predicate<Campaign> isValidForPlaceholder() {
		return campaign -> campaign.getActive() && campaign.getEligibleForRedemption();
	}

	@Cacheable(cacheNames = {"rewardGetActiveCampaigns"})
	public GetCampaignsResponse getAllActiveCampaigns(final Vertical.VerticalType vertical, final String brandCode,
													  final ZonedDateTime effectiveDateTime) {
		GetCampaigns request = new GetCampaigns();
		request.setBrandCode(brandCode);
		request.setVerticalCode(vertical.getCode());
		request.setEffectiveDateTime(effectiveDateTime);

		final String url = rewardServiceUrl + REWARD_ENDPOINT_CAMPAIGNS_GET;
		return rewardCampaignsGetClient.post(RestSettings.<GetCampaigns>builder()
				.request(request)
				.response(GetCampaignsResponse.class)
				.jsonHeaders()
				.url(url)
				.timeout(SERVICE_TIMEOUT)
				.build())
				.observeOn(Schedulers.io())
				.onErrorResumeNext(throwable -> {
					LOGGER.error("Reward: Failed to get reward campaigns. url={}", url, throwable);
					GetCampaignsResponse response = new GetCampaignsResponse();
					response.setCampaigns(Collections.emptySet());
					return Observable.just(response);
				})
				.toBlocking()
				.single();
	}
}
