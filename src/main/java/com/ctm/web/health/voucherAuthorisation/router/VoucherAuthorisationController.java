package com.ctm.web.health.voucherAuthorisation.router;

import com.ctm.web.health.voucherAuthorisation.services.VoucherAuthorisation;
import com.ctm.web.health.voucherAuthorisation.services.VoucherAuthorisationService;
import com.ctm.web.core.exceptions.DaoException;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;

/**
 * Created by msmerdon on 5/10/2016.
 */
@Api(basePath = "/", value = "voucher")
@RestController
public class VoucherAuthorisationController {

    @Resource
    private VoucherAuthorisationService voucherAuthorisationService;

    @ApiOperation(value = "/voucher/authorise", notes = "authorise voucher", produces = "application/json")
    @RequestMapping(value = "/voucher/authorise", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public VoucherAuthorisation getAuthorisation(@RequestParam @NotNull final String code, HttpServletRequest request) throws DaoException {
        return voucherAuthorisationService.getAuthorisation(request, code);
    }
}
