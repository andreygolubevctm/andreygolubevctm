package com.ctm.web.energy.product.adapter;

import com.ctm.energy.product.response.model.EnergyProduct;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.energy.form.response.model.EnergyProductInfoWebResponse;
import com.ctm.web.energy.quote.adapter.WebResponseAdapter;
import org.springframework.stereotype.Component;

@Component
public class EnergyProductServiceResponseAdapter implements WebResponseAdapter<EnergyProductInfoWebResponse, Response<EnergyProduct>> {

    @Override
    public EnergyProductInfoWebResponse adapt(Response<EnergyProduct> energyProductResponse) {
        final EnergyProduct energyProduct = energyProductResponse.getPayload().getQuotes().get(0);
        EnergyProductInfoWebResponse response = new EnergyProductInfoWebResponse();
        response.setRetailName(energyProduct.getRetailerName().get().orElse(""));
        response.setPlanName(energyProduct.getPlanName().get().orElse(""));
        response.setPlanDetails(energyProduct.getPlanDetails().get().orElse(""));
        response.setBillingOptions(energyProduct.getBillingOptions().get().orElse(""));
        response.setContractDetails(energyProduct.getContractDetails().get().orElse(""));
        response.setPaymentDetails(energyProduct.getPaymentDetails().get().orElse(""));
        response.setPricingInformation(energyProduct.getPricingInformation().get().orElse(""));
        response.setPrivacyPolicyUrl(energyProduct.getPrivacyPolicyUrl().get().orElse(""));
        response.setTermsUrl(energyProduct.getTermsUrl().get().orElse(""));
        return response;
    }
}
