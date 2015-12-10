package com.ctm.web.energy.apply.controller;

import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.Info;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostReqestPayload;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.ctm.web.energy.apply.services.EnergyApplyService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.IOException;
import java.util.Arrays;

@Api(basePath = "/rest/energy", value = "Energy Apply")
@RestController
@RequestMapping("/rest/energy")
public class EnergyApplyController extends CommonQuoteRouter<EnergyApplyPostReqestPayload> {
    private static final Logger LOGGER = LoggerFactory.getLogger(EnergyApplyController.class);

    @Autowired
    EnergyApplyService energyService;

    @ApiOperation(value = "apply.json", notes = "Request a energy quote", produces = "application/json")
    @RequestMapping(value = "/apply.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public EnergyApplyWebResponseModel getQuote(@Valid EnergyApplyPostReqestPayload applyPostReqestPayload,
                                                HttpServletRequest request) throws IOException, ServiceConfigurationException, DaoException {

        LOGGER.info("START-------");
        for (String key : request.getParameterMap().keySet()) {
            LOGGER.info("{}:{}", key, Arrays.toString(request.getParameterValues(key)));
        }
        LOGGER.info("FINISH-------");

        EnergyApplicationDetails energyApplicationDetails = mapPostRequestToModel(applyPostReqestPayload);

        Brand brand = initRouter(request, Vertical.VerticalType.ENERGY);
        updateTransactionIdAndClientIP(request, applyPostReqestPayload);
        EnergyApplyWebResponseModel outcome = energyService.apply(applyPostReqestPayload, brand);
        if (outcome != null) {
            Data dataBucket = getDataBucket(request, applyPostReqestPayload.getTransactionId());
            Info info = new Info();
            info.setTrackingKey(dataBucket.getString("data/utilities/trackingKey"));
            info.setTransactionId(applyPostReqestPayload.getTransactionId());
            outcome.setTransactionId(applyPostReqestPayload.getTransactionId());
        }
        return outcome;
    }


    private EnergyApplicationDetails mapPostRequestToModel(EnergyApplyPostReqestPayload applyPostReqestPayload) {
//        Address postRequestAddress = applyPostReqestPayload.getUtilities().getApplication().getDetails().getAddress();
//        AddressDetails.newBuilder().
//                dpId(postRequestAddress.getDpId()).
//                unitType(postRequestAddress.getUnitType()).
//                unitNo

//
//        private String dpId;
//        private String unitType;
//        private String unitNo;
//        private String houseNo;
//        private String FloorNo;
//        private String street;
//        private String streetId;
//        private String suburb;
//        private String postCode;
//        private String state;

//        EnergyApplicationDetails energyApplicationDetails = EnergyApplicationDetails.newBuilder().build();
        return null; //energyApplicationDetails;
    }

}
