package com.ctm.web.health.lhc;

import com.ctm.web.health.lhc.calculation.LHCCalculationStrategy;
import com.ctm.web.health.lhc.calculation.LHCCalculationStrategyFactory;
import com.ctm.web.health.lhc.model.query.LHCBaseDateQuery;
import com.ctm.web.health.lhc.model.query.LHCCalculationQuery;
import com.ctm.web.health.lhc.model.response.LHCBaseDateDetails;
import com.ctm.web.health.lhc.model.response.LHCBaseDateResponse;
import com.ctm.web.health.lhc.model.response.LHCCalculation;
import com.ctm.web.health.lhc.model.response.LHCCalculationResponse;
import io.swagger.annotations.Api;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.time.LocalDate;
import java.util.Optional;

@Api(basePath = "/lhc", value = "LHC Calculation API")
@RestController
@RequestMapping("/lhc")
public class LHCCalculationController {

    @RequestMapping(value = "/base-dates/post.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_JSON_VALUE},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public static LHCBaseDateResponse calculateLHCBaseData(@RequestBody @Valid LHCBaseDateQuery lhcBaseDateQuery) {
        LHCBaseDateDetails primaryBaseDateDetails = LHCBaseDateDetails.createFrom(lhcBaseDateQuery.getPrimaryDOB());
        Optional<LHCBaseDateDetails> optionalPartnerBaseDateDetails = Optional.ofNullable(lhcBaseDateQuery.getPartnerDOB()).map(LHCBaseDateDetails::createFrom);
        return new LHCBaseDateResponse(primaryBaseDateDetails, optionalPartnerBaseDateDetails);
    }

    @RequestMapping(value = "/calculate/post.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_JSON_VALUE},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public LHCCalculationResponse calculateLHC(@RequestBody @Valid LHCCalculationQuery queryWrapper) {
        LocalDate today = LocalDate.now();
        LHCCalculation primary = new LHCCalculation(LHCCalculationStrategyFactory.getInstance(queryWrapper.getPrimary(), today).calculateLHCPercentage());
        Optional<LHCCalculation> partner = Optional.ofNullable(queryWrapper.getPartner())
                .map(details -> LHCCalculationStrategyFactory.getInstance(details, today))
                .map(LHCCalculationStrategy::calculateLHCPercentage)
                .map(LHCCalculation::new);
        return new LHCCalculationResponse(primary, partner);
    }

}