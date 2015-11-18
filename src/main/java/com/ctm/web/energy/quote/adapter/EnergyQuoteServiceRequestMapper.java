package com.ctm.web.energy.quote.adapter;

import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.quote.model.EnergyQuoteRequest;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;


@Mapper
public interface EnergyQuoteServiceRequestMapper  {

    @Mappings({
            @Mapping(source = "quote.houseHoldDetails.suburb", target = "serviceAddress.suburb"),
            @Mapping(source = "quote.houseHoldDetails.postcode", target = "serviceAddress.postCode"),
            @Mapping(source = "quote.houseHoldDetails.whatToCompare", target = "serviceAddress.whatToCompare"),
            @Mapping(source = "quote.houseHoldDetails.isConnection", target = "serviceAddress.movingIn"),
            @Mapping(source = "quote.houseHoldDetails.solarPanels", target = "serviceAddress.hasSolarPanels"),
            @Mapping(source = "quote.houseHoldDetails.howToEstimate", target = "serviceAddress.howToEstimate")
    })
    EnergyQuoteRequest adapt(EnergyResultsWebRequest request);

}
