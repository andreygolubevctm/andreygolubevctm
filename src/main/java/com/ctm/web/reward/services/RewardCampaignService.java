package com.ctm.web.reward.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.reward.model.GetCampaigns;
import com.ctm.reward.model.GetCampaignsResponse;
import com.ctm.web.core.model.settings.Vertical;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import rx.schedulers.Schedulers;

import java.time.ZonedDateTime;

@Service
public class RewardCampaignService {
	public static final String REWARD_ENDPOINT_CAMPAIGNS_GET = "/campaigns/get";

	@Value("${ctm.reward.url}")
	private String rewardServiceUrl;

	private Client<GetCampaigns, GetCampaignsResponse> rewardCampaignsGetClient;

	@Autowired
	public RewardCampaignService(Client<GetCampaigns, GetCampaignsResponse> rewardCampaignsGetClient) {
		this.rewardCampaignsGetClient = rewardCampaignsGetClient;
	}

	@Cacheable(cacheNames = {"rewardGetActiveCampaigns"})
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
				.timeout(RewardService.SERVICE_TIMEOUT)
				.build())
				.observeOn(Schedulers.io())
				.toBlocking()
				.single();
	}
}
