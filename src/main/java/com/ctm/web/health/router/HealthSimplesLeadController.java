package com.ctm.web.health.router;

import com.ctm.web.health.services.HealthSimplesLeadService;
import com.ctm.web.health.simples.model.CliReturn;
import com.ctm.web.health.simples.model.CliReturnResponse;
import com.ctm.web.health.model.leadservice.DelayLead;
import com.ctm.web.health.model.leadservice.DelayLeadResponse;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;

@Api(basePath = "/rest/simples", value = "Health Simples Lead")
@RestController
@RequestMapping("/rest/simples")
public class HealthSimplesLeadController {

    @Autowired
    private HealthSimplesLeadService healthSimplesLeadService;

    @RequestMapping(value = "/clifilter/add.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"})
    public CliReturnResponse cliReturn(@Valid @NotNull final CliReturn data) throws Exception {
        return healthSimplesLeadService.sendCliReturnNote(data);
    }

    @RequestMapping(value = "/delayLead/chat.json",
            method= RequestMethod.POST,
            consumes={MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"})
    public DelayLeadResponse delayLead(@Valid @NotNull final DelayLead data) throws Exception {
        return healthSimplesLeadService.sendDelayLead(data);
    }

}
