package com.ctm.web.health.router;

import com.ctm.web.health.model.HealthFundTimeZoneResponse;
import com.ctm.web.health.services.HealthFundTimeZoneService;
import com.sun.istack.NotNull;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * Created by msmerdon on 27/11/2017.
 */
@Api(basePath = "/", value = "Fund Timezone")
@RestController
public class HealthFundTimeZoneController {

    @Resource
    private HealthFundTimeZoneService healthFundTimeZoneService;

    @ApiOperation(value = "health/fund/timezone/valid", notes = "TimeZone Check", produces = "application/json")
    @RequestMapping(value = "/health/fund/timezone/valid", method = RequestMethod.GET, produces = MediaType
            .APPLICATION_JSON_VALUE)
    public HealthFundTimeZoneResponse getHealthFundTimeZoneCheck(@RequestParam @NotNull final String fundCode) throws
            Exception {
        return healthFundTimeZoneService.get(fundCode);
    }
}
