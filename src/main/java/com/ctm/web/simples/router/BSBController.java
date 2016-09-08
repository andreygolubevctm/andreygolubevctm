package com.ctm.web.simples.router;

import com.ctm.web.simples.model.BSBResponse;
import com.sun.istack.NotNull;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by akhurana on 8/09/2016.
 */
@Api(basePath = "/", value = "bsb")
@RestController
public class BSBController {

    @ApiOperation(value = "/bsbdetails", notes = "bsb", produces = "application/json")
    @RequestMapping(value = "/bsbdetails", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public BSBResponse getBSBDetails(@RequestParam @NotNull final String bsbNumber) {
        return new BSBResponse("032-639", "Greenhills Kiosk", "K123 Greenhills Shopping Cntre", "East Maitland", "2323", "NSW");
    }
}
