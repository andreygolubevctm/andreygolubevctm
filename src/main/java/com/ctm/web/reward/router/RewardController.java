package com.ctm.web.reward.router;

import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.reward.model.*;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.reward.services.RewardService;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

@RestController
@RequestMapping("/rest/reward")
public class RewardController extends CommonQuoteRouter {
    private static final String ORDER_CREATE = "/order/create";
    private static final String ORDER_UPDATE = "/order/update";
    private static final String ORDER_FIND = "/order/find.json";
    private static final String CAMPAIGNS_GET = "/campaigns/get.json";

    @Value("${ctm.reward.url}")
    private String rewardServiceBase;

	private SerializationMappers objectMapper;

	private RewardService rewardService;

    @Autowired
    public RewardController(SessionDataServiceBean sessionDataServiceBean,
							IPAddressHandler ipAddressHandler,
							RewardService rewardService,
							SerializationMappers objectMapper) {
		super(sessionDataServiceBean, ipAddressHandler);
        this.rewardService = rewardService;
        this.objectMapper = objectMapper;

		this.objectMapper.getJsonMapper()
				.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false)
				.setSerializationInclusion(JsonInclude.Include.NON_NULL)
				.registerModule(new Jdk8Module())
				.registerModule(new JavaTimeModule());
	}

    @RequestMapping(value = CAMPAIGNS_GET,
            method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public String getCampaigns(final HttpServletRequest request) throws JsonProcessingException {
		GetCampaignsResponse campaigns = rewardService.getAllActiveCampaigns(request);
		// Remove properties that should not be made public
		if (campaigns != null) {
			campaigns.getCampaigns().forEach(campaign -> {
				campaign.setCampaignSettings(null);
				campaign.setStartDtTm(null);
				campaign.setEndDtTm(null);
				campaign.getRewards().forEach(reward -> {
					reward.setCreatedTmstmp(null);
					reward.setUpdatedTmstmp(null);
					reward.setProviderName(null);
					reward.setProviderRewardCode(null);
				});
			});
		}
		return objectMapper.getJsonMapper().writeValueAsString(campaigns);
	}

	@RequestMapping(value = ORDER_CREATE,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public OrderFormResponse createOrder(@Valid @RequestBody final OrderForm form, final HttpServletRequest request) {
        return rewardService.createAdhocOrder(form, request);
    }

    @RequestMapping(value = ORDER_UPDATE,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public UpdateResponse updateOrder(@Valid @RequestBody final OrderForm form, final HttpServletRequest request) {
        return rewardService.updateOrder(form, request);
    }

    @RequestMapping(value = ORDER_FIND,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public String findOrders(@Valid @RequestBody final FindRequest form, final HttpServletRequest request) throws JsonProcessingException {
		FindResponse findResponse = rewardService.findOrders(form, request);
		return objectMapper.getJsonMapper().writeValueAsString(findResponse);
    }
}
