package com.ctm.web.reward.router;

import com.ctm.reward.model.*;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.reward.services.RewardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

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
    public GetCampaignsResponse getCampaigns(final HttpServletRequest request) {
		return rewardService.getAllActiveCampaigns(request);
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
    public FindResponse findOrders(@Valid @RequestBody final FindRequest form, final HttpServletRequest request) {
    	return rewardService.findOrders(form, request);
    }
}
