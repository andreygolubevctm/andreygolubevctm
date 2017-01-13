package com.ctm.web.reward.router;

import com.ctm.httpclient.Client;
import com.ctm.redemption.model.GetRedemption;
import com.ctm.redemption.model.RedemptionForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/rest/reward")
public class RewardController {
    private static final String GET_REDEMPTION = "/get";
    private static final String ADHOC = "/adhoc";
    private static final String UPDATE = "/update";
    public static final String REDEMPTION = "/redemption";

    @Autowired
    private Client<GetRedemption, RedemptionForm> getRedemptionClient;

    @Autowired
    private Client<RedemptionForm, RedemptionForm> redemptionClient;

    @Value("${ctm.reward.url}")
    private String redemptionUrl;

    @RequestMapping(value = GET_REDEMPTION,
            method = RequestMethod.GET,
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public RedemptionForm get(@Valid @RequestParam final String encryptedRedemptionId) {
        final GetRedemption getRedemption = new GetRedemption(encryptedRedemptionId);
        return getRedemptionClient.post(getRedemption, RedemptionForm.class, redemptionUrl + REDEMPTION + GET_REDEMPTION).toBlocking().first();
    }

    @RequestMapping(value = ADHOC,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public RedemptionForm adhoc(@Valid @RequestBody final RedemptionForm form) {
        return redemptionClient.post(form, RedemptionForm.class, redemptionUrl + REDEMPTION + ADHOC).toBlocking().first();
    }

    @RequestMapping(value = UPDATE,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public RedemptionForm update(@Valid @RequestBody final RedemptionForm form) {
        return redemptionClient.post(form, RedemptionForm.class, redemptionUrl + REDEMPTION + UPDATE).toBlocking().first();
    }
}
