package com.ctm.web.lifebroker.router;

import com.ctm.web.lifebroker.services.LifebrokerLeadsService;
import com.ctm.web.lifebroker.model.LifebrokerLead;
import com.sun.istack.NotNull;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * Created by msmerdon on 04/12/2017.
 */
@Api(basePath = "/lifebroker", value = "Lifebroker")
@RestController
@RequestMapping("/lifebroker")
public class LifebrokerLeadsController {

    @Resource
    private LifebrokerLeadsService lifebrokerLeadsService;

    @ApiOperation(value = "lead/send", notes = "Simples Lifebroker Lead", produces = "text/html")
    @RequestMapping(value = "/lead/send", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public String sendLead(@RequestParam @NotNull final String transactionId, @RequestParam @NotNull final String email, @RequestParam @NotNull final String phone, @RequestParam @NotNull final String postcode, @RequestParam @NotNull final String name, @RequestParam @NotNull final String call_time) throws Exception {
		return lifebrokerLeadsService.sendLead(transactionId, email, phone, postcode, name, call_time);
	}
}
