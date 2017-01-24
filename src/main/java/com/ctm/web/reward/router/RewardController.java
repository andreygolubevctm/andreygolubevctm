package com.ctm.web.reward.router;

import com.ctm.reward.model.GetCampaignsResponse;
import com.ctm.reward.model.OrderForm;
import com.ctm.reward.model.UpdateResponse;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.reward.services.RewardService;
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
    private static final String UPDATE = "/order/update";
    private static final String CAMPAIGNS_GET = "/campaigns/get.json";

    @Value("${ctm.reward.url}")
    private String rewardServiceBase;

    private RewardService rewardService;

    @Autowired
    public RewardController(SessionDataServiceBean sessionDataServiceBean,
							IPAddressHandler ipAddressHandler,
							RewardService rewardService) {
		super(sessionDataServiceBean, ipAddressHandler);
        this.rewardService = rewardService;
    }

    @RequestMapping(value = CAMPAIGNS_GET,
            method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public GetCampaignsResponse get(HttpServletRequest request) {
		return rewardService.getAllActiveCampaigns(request);
    }

//    @RequestMapping(value = GET_REDEMPTION,
//            method = RequestMethod.GET,
//            consumes = MediaType.APPLICATION_JSON_VALUE,
//            produces = MediaType.APPLICATION_JSON_VALUE)
//    public RedemptionForm get(@Valid @RequestParam final String encryptedRedemptionId) {
//        final GetRedemption getRedemption = new GetRedemption(encryptedRedemptionId);
//        return getRedemptionClient.post(getRedemption, RedemptionForm.class, rewardServiceBase + REDEMPTION + GET_REDEMPTION).toBlocking().first();
//    }
//
//    @RequestMapping(value = ADHOC,
//            method = RequestMethod.POST,
//            consumes = MediaType.APPLICATION_JSON_VALUE,
//            produces = MediaType.APPLICATION_JSON_VALUE)
//    public RedemptionForm adhoc(@Valid @RequestBody final RedemptionForm form) {
//        return redemptionClient.post(form, RedemptionForm.class, rewardServiceBase + REDEMPTION + ADHOC).toBlocking().first();
//    }

    @RequestMapping(value = UPDATE,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public UpdateResponse update(@Valid @RequestBody final OrderForm form) {
        return rewardService.updateOrder(form);
    }
}
