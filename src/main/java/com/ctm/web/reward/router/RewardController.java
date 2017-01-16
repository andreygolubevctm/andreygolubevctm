package com.ctm.web.reward.router;

import com.ctm.reward.model.GetCampaignsResponse;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.reward.services.RewardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.ZonedDateTime;
import java.util.Optional;

@RestController
@RequestMapping("/rest/reward")
public class RewardController {
    private static final String GET_REDEMPTION = "/get";
    private static final String ADHOC = "/adhoc";
    private static final String UPDATE = "/update";
    private static final String REDEMPTION = "/redemption";
    private static final String CAMPAIGNS_GET = "/campaigns/get.json";

//    @Autowired
//    private Client<GetRedemption, RedemptionForm> getRedemptionClient;
//
//    @Autowired
//    private Client<RedemptionForm, RedemptionForm> redemptionClient;

    @Value("${ctm.reward.url}")
    private String rewardServiceBase;

    private RewardService rewardService;

    @Autowired
    public RewardController(RewardService rewardService) {
        this.rewardService = rewardService;
    }

    @RequestMapping(value = CAMPAIGNS_GET,
            method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public GetCampaignsResponse get(@RequestParam(value = "brandCode", required = false, defaultValue = "ctm") String brandCode,
                                    @RequestParam(value = "vertical", required = false, defaultValue = "health") String vertical,
                                    @RequestParam(value = "effective", required = false) ZonedDateTime effective) {
        if (effective == null) {
            effective = ZonedDateTime.now();
        }
        return rewardService.getAllActiveCampaigns(Vertical.VerticalType.findByCode(vertical), brandCode, effective);
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
//
//    @RequestMapping(value = UPDATE,
//            method = RequestMethod.POST,
//            consumes = MediaType.APPLICATION_JSON_VALUE,
//            produces = MediaType.APPLICATION_JSON_VALUE)
//    public RedemptionForm update(@Valid @RequestBody final RedemptionForm form) {
//        return redemptionClient.post(form, RedemptionForm.class, rewardServiceBase + REDEMPTION + UPDATE).toBlocking().first();
//    }
}
