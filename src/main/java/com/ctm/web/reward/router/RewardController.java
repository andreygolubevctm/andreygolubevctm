package com.ctm.web.reward.router;

import com.ctm.reward.model.GetCampaignsResponse;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.reward.services.RewardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@RestController
@RequestMapping("/rest/reward")
public class RewardController extends CommonQuoteRouter {
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
    	//TODO Health should not be hardcoded
		final Vertical.VerticalType vertical = HEALTH;
		final Brand brand = initRouter(request, vertical);

		ZonedDateTime effective = ZonedDateTime.now();
		Optional<LocalDateTime> applicationDate = getApplicationDate(request);
		if (applicationDate.isPresent()) {
			effective = ZonedDateTime.of(applicationDate.get(), ZoneId.systemDefault());
		//} else if {
			//TODO get the "journey start time" from session
		}

		effective = roundupMinutes(effective);
		return rewardService.getAllActiveCampaigns(vertical, brand.getCode(), effective);
    }

    /*
    Round the datetime to nearest future 2 minute block
     */
	protected ZonedDateTime roundupMinutes(ZonedDateTime effective) {
		return effective.withSecond(0).withNano(0).plusMinutes((62 - effective.getMinute()) % 2);
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
