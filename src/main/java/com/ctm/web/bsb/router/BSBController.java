package com.ctm.web.bsb.router;

import com.ctm.web.bsb.services.BSBDetails;
import com.ctm.web.bsb.services.BSBDetailsService;
import com.ctm.web.core.exceptions.DaoException;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;

/**
 * Created by akhurana on 8/09/2016.
 */
@Api(basePath = "/", value = "bsb")
@RestController
public class BSBController {

    @Resource
    private BSBDetailsService bsbDetailsService;

    @ApiOperation(value = "/bsbdetails", notes = "bsb", produces = "application/json")
    @RequestMapping(value = "/bsbdetails", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public BSBDetails getBSBDetails(@RequestParam @NotNull final String bsbNumber) throws DaoException {
        return bsbDetailsService.getBsbDetailsByBsbNumber(bsbNumber);
    }
}
