package com.ctm.web.energy.quote.adapter;

import com.ctm.energy.quote.request.model.Electricity;
import com.ctm.energy.quote.request.model.*;
import com.ctm.energy.quote.request.model.Gas;
import com.ctm.energy.quote.request.model.preferences.HasEBilling;
import com.ctm.energy.quote.request.model.preferences.NoContract;
import com.ctm.energy.quote.request.model.preferences.RenewableEnergy;
import com.ctm.web.energy.form.model.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;

import static com.ctm.web.health.apply.model.Constants.AUS_FORMAT;


public class EnergyQuoteServiceRequestAdapter implements WebRequestAdapter<EnergyResultsWebRequest, EnergyQuoteRequest> {

    @Override
    public EnergyQuoteRequest adapt(EnergyResultsWebRequest request) {
        return new EnergyQuoteRequest( createHouseHoldDetails(request),
                createElectricity(request),  createGas(request),
                 createPreferences(request),
                createEnergyTypes(request));
    }

    private List<EnergyType> createEnergyTypes(EnergyResultsWebRequest quote) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseHoldDetails());
        List<EnergyType> energyTypes = new ArrayList<>();

        Optional.ofNullable(createGasType(householdDetailsMaybe.map(HouseHoldDetails::getWhatToCompare)))
                .ifPresent(energyTypes::add);
        Optional.ofNullable(createElectricityType(householdDetailsMaybe.map(HouseHoldDetails::getWhatToCompare)))
                .ifPresent(energyTypes::add);
        return energyTypes;
    }

    private EnergyType createGasType(Optional<WhatToCompare> whatToCompare) {
        if (whatToCompare.isPresent()) {
            WhatToCompare whatToCompareValue = whatToCompare.get();
            if (whatToCompareValue.equals(WhatToCompare.G) || whatToCompareValue.equals(WhatToCompare.EG)) {
                return EnergyType.Gas;
            }
        }
            return null;
    }

    private EnergyType createElectricityType(Optional<WhatToCompare> whatToCompare) {
        if (whatToCompare.isPresent()) {
            WhatToCompare whatToCompareValue = whatToCompare.get();
            if (whatToCompareValue.equals(WhatToCompare.E) || whatToCompareValue.equals(WhatToCompare.EG)) {
                return EnergyType.Electricity;
            }
        }
        return null;
    }

    private Preferences createPreferences(EnergyResultsWebRequest quote) {
        final Optional<ResultsDisplayed> resultsDisplayedMaybe = Optional.ofNullable(quote.getResultsDisplayed());
        HasEBilling hasEBilling = resultsDisplayedMaybe.map(ResultsDisplayed :: getPreferEBilling).map( value -> new HasEBilling(value.equals(YesNo.Yes))).orElse(null);
        NoContract noContract = resultsDisplayedMaybe.map(ResultsDisplayed :: getPreferNoContract).map( value -> new NoContract(value.equals(YesNo.Yes))).orElse(null);
        RenewableEnergy renewableEnergy = resultsDisplayedMaybe.map(ResultsDisplayed :: getPreferRenewableEnergy).map( value -> new RenewableEnergy(value.equals(YesNo.Yes))).orElse(null);

        return new Preferences(null,
                hasEBilling,
                noContract,
                null,
                renewableEnergy);
    }


    private Gas createGas(EnergyResultsWebRequest quote ) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseHoldDetails());
        final Optional<EstimateDetails> estimateDetails = Optional.ofNullable(quote.getEstimateDetails());
        if (householdDetailsMaybe.isPresent() && householdDetailsMaybe.get().getWhatToCompare().equals("G") || householdDetailsMaybe.get().getWhatToCompare().equals("EG") ) {
            String currentSupplier = estimateDetails.map(EstimateDetails :: getGas).map(getCurrentSupplier()).orElse(null);
            return new Gas(getGasUsageDetails(estimateDetails), getGasHouseholdType(estimateDetails) , getGasHasBill(householdDetailsMaybe), currentSupplier);
        } else {
            return null;
        }
    }

    private GasUsageDetails getGasUsageDetails(Optional<EstimateDetails> estimateDetailsMaybe) {
        return new GasUsageDetails(estimateDetailsMaybe.map(EstimateDetails :: getSpend ).map(Spend::getGas).map( spendEnergy -> {
            return new BigDecimal(spendEnergy.getAmount());
        }).orElse(null), null, null);
    }

    private static ElectricityUsageDetails  getElectricityUsageDetails(Optional<EstimateDetails> estimateDetailsMaybe) {
        return new ElectricityUsageDetails(estimateDetailsMaybe.map(EstimateDetails :: getSpend ).map(Spend::getElectricity).map( spendEnergy -> {
            return new BigDecimal(spendEnergy.getAmount());
        }).orElse(null), null, null);
    }

    private boolean getGasHasBill(Optional<HouseHoldDetails> householdDetailsMaybe) {
        return householdDetailsMaybe.map(HouseHoldDetails::getRecentGasBill).map(getYesNoBooleanFunction()).orElse(false);
    }

    private HouseholdDetails createHouseHoldDetails(EnergyResultsWebRequest quote) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseHoldDetails());
        return new HouseholdDetails(
                householdDetailsMaybe.map(HouseHoldDetails::getSuburb).orElse(null),
                householdDetailsMaybe.map(HouseHoldDetails::getPostcode).orElse(null),
                householdDetailsMaybe.map(HouseHoldDetails::getMovingIn).map(getYesNoBooleanFunction()).orElse(false),
                householdDetailsMaybe.map(HouseHoldDetails::getMovingInDate)
                .map(v -> LocalDate.parse(v, AUS_FORMAT))
                .orElse(null), householdDetailsMaybe.map(HouseHoldDetails::getTariff).orElse(null));
    }

    protected static Electricity createElectricity(EnergyResultsWebRequest quote) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseHoldDetails());
        final Optional<EstimateDetails> estimateDetails = Optional.ofNullable(quote.getEstimateDetails());
        if (householdDetailsMaybe.isPresent() && householdDetailsMaybe.get().getWhatToCompare().equals("E") || householdDetailsMaybe.get().getWhatToCompare().equals("EG") ) {
            String currentSupplier = estimateDetails.map(EstimateDetails :: getElectricity).map(getCurrentSupplier()).orElse(null);
            return new Electricity(getElectricityUsageDetails(estimateDetails), getHouseholdType(estimateDetails),
            getElectrityHasBill(householdDetailsMaybe), getHasSolarPanels(householdDetailsMaybe), currentSupplier);
        } else {
            return null;
        }
    }

    private static Function<com.ctm.web.energy.form.model.Energy, String> getCurrentSupplier() {
        return (com.ctm.web.energy.form.model.Energy energy) -> energy.getCurrentSupplier();
    }

    private static boolean getElectrityHasBill(Optional<HouseHoldDetails> quote) {
        return quote.map(HouseHoldDetails::getRecentElectricityBill).map(getYesNoBooleanFunction()).orElse(false);
    }

    private static boolean getHasSolarPanels(Optional<HouseHoldDetails> householdDetailsMaybe) {
        return householdDetailsMaybe.map(HouseHoldDetails::getHasSolarPanels).map(getYesNoBooleanFunction()).orElse(false);
    }


    private static HouseholdType getHouseholdType(Optional<EstimateDetails> estimateDetails) {
        return estimateDetails.map(EstimateDetails::getElectricity).map(com.ctm.web.energy.form.model.Energy::getUsage).orElse(null);
    }

    private static HouseholdType getGasHouseholdType(Optional<EstimateDetails> estimateDetails) {
        return estimateDetails.map(EstimateDetails::getGas).map(com.ctm.web.energy.form.model.Energy::getUsage).orElse(null);
    }

    private static Function<YesNo, Boolean> getYesNoBooleanFunction() {
        return value -> value.equals(YesNo.Yes);
    }
}
