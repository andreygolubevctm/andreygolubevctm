package com.ctm.web.energy.quote.adapter;

import com.ctm.energy.quote.response.model.Discount;
import com.ctm.energy.quote.response.model.EnergyQuote;
import com.ctm.energy.quote.response.model.Retailer;
import com.ctm.energy.quote.response.model.Savings;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.energy.form.response.model.EnergyResponseError;
import com.ctm.web.energy.form.response.model.EnergyResults;
import com.ctm.web.energy.form.response.model.EnergyResultsPlanModel;
import com.ctm.web.energy.form.response.model.EnergyResultsWebResponse;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


public class EnergyQuoteServiceResponseAdapter implements WebResponseAdapter<EnergyResultsWebResponse, Response<EnergyQuote>> {

    @Override
    public EnergyResultsWebResponse adapt(Response<EnergyQuote> response) {
        List<EnergyQuote> quotes = response.getPayload().getQuotes();
        List<EnergyResponseError> errors = null;
        EnergyResults results = null;
        if(quotes.isEmpty()){
            errors = new ArrayList<>();
            EnergyResponseError error = new EnergyResponseError();
            error.setMessage("getResults is empty");
            errors.add(error);
        } else {
            results = new EnergyResults();
            List<EnergyResultsPlanModel> plans = new ArrayList();
            for (EnergyQuote quote : quotes) {
                EnergyResultsPlanModel energyResultsPlanModel = new EnergyResultsPlanModel();
                energyResultsPlanModel.setAvailable("Y");
                energyResultsPlanModel.setCancellationFees(quote.getCancellationFees());
                energyResultsPlanModel.setContractPeriod(quote.getContractPeriod());
                mapDetails(quote, energyResultsPlanModel);
                energyResultsPlanModel.setEstimatedCost(quote.getEstimatedCost().doubleValue());
                energyResultsPlanModel.setPlanId(Integer.parseInt(quote.getProductId().get()));
                energyResultsPlanModel.setPlanName(quote.getPlanName());
                energyResultsPlanModel.setPreviousPrice(0);
                energyResultsPlanModel.setPrice(quote.getEstimatedCost().doubleValue());
                mapRetailer(quote, energyResultsPlanModel);

                energyResultsPlanModel.setYearlySavings(quote.getYearlySavings().map(Savings::getElectricity).map(BigDecimal::doubleValue).orElse(0d));

                results.setUniqueCustomerId(quote.getUniqueCustomerId());
                plans.add(energyResultsPlanModel);
            }
            results.setPlans(plans);
        }
        EnergyResultsWebResponse energyResultsWebResponse = new EnergyResultsWebResponse(results, errors);
        return energyResultsWebResponse;
    }

    private void mapRetailer(EnergyQuote quote, EnergyResultsPlanModel energyResultsPlanModel) {
        Optional<Retailer> retailerMaybe = Optional.ofNullable(quote.getRetailer());
        energyResultsPlanModel.setRetailerId(retailerMaybe.map(Retailer::getRetailerId).orElse(null));
        energyResultsPlanModel.setRetailerName(retailerMaybe.map(Retailer::getRetailerName).orElse(null));
    }

    private void mapDetails(EnergyQuote quote, EnergyResultsPlanModel energyResultsPlanModel) {
        Optional<Discount> discountMaybe = Optional.ofNullable(quote.getDiscount());
        energyResultsPlanModel.setDiscountDetails(discountMaybe.map(Discount::getDetails).orElse(null));
        energyResultsPlanModel.setEbillingDiscounts(discountMaybe.map(Discount::geteBilling).orElse(null));
        energyResultsPlanModel.setGuaranteedDiscounts(discountMaybe.map(Discount::getGuaranteed).orElse(null));
        energyResultsPlanModel.setOtherDiscounts(discountMaybe.map(Discount::getOther).orElse(null));
        energyResultsPlanModel.setPayontimeDiscounts(discountMaybe.map(Discount::getPayOnTime).orElse(null));
    }
}
