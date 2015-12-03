package com.ctm.web.energy.quote.adapter;

import com.ctm.energy.quote.request.model.*;
import com.ctm.energy.quote.request.model.Electricity;
import com.ctm.energy.quote.request.model.Gas;
import com.ctm.energy.quote.request.model.preferences.*;
import com.ctm.energy.quote.request.model.usage.*;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.energy.form.model.Energy;
import com.ctm.web.energy.form.model.*;
import com.ctm.web.energy.form.model.Usage;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;



public class EnergyQuoteServiceRequestAdapter implements WebRequestAdapter<EnergyResultsWebRequest, EnergyQuoteRequest> {

    @Override
    public EnergyQuoteRequest adapt(EnergyResultsWebRequest request) {
        EnergyPayLoad utilities = request.getUtilities();
        return new EnergyQuoteRequest(
                createHouseHoldDetails(utilities),
                createElectricity(utilities),
                createGas(utilities),
                createPreferences(utilities),
                createEnergyTypes(utilities),
                createTransactionId(request),
                createContactDetails(utilities)
        );
    }

    private TransactionId createTransactionId(EnergyResultsWebRequest request) {
        return TransactionId.instanceOf(request.getTransactionId());
    }

    private ContactDetails createContactDetails(EnergyPayLoad request) {
        Optional<ResultsDisplayed> resultsDisplayedMaybe = Optional.ofNullable(request.getResultsDisplayed());
        Boolean optinPhone = resultsDisplayedMaybe.map(ResultsDisplayed::getOptinPhone).map(getYesNoBooleanFunction()).orElse(false);
        return new ContactDetails(optinPhone, null, resultsDisplayedMaybe.map(ResultsDisplayed :: getFirstName).orElse(null), resultsDisplayedMaybe.map(ResultsDisplayed :: getPhone).orElse(null));
    }

    private List<EnergyType> createEnergyTypes(EnergyPayLoad quote) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseholdDetails());
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
            if (hasGas(whatToCompareValue)) {
                return EnergyType.Gas;
            }
        }
            return null;
    }

    private boolean hasGas(WhatToCompare whatToCompareValue) {
        return whatToCompareValue.equals(WhatToCompare.G) || whatToCompareValue.equals(WhatToCompare.EG);
    }

    private static boolean hasElectricity(WhatToCompare whatToCompareValue) {
        return whatToCompareValue.equals(WhatToCompare.E) || whatToCompareValue.equals(WhatToCompare.EG);
    }

    private EnergyType createElectricityType(Optional<WhatToCompare> whatToCompare) {
        if (whatToCompare.isPresent()) {
            WhatToCompare whatToCompareValue = whatToCompare.get();
            if (hasElectricity(whatToCompareValue)) {
                return EnergyType.Electricity;
            }
        }
        return null;
    }

    private Preferences createPreferences(EnergyPayLoad quote) {
        final Optional<ResultsDisplayed> resultsDisplayedMaybe = Optional.ofNullable(quote.getResultsDisplayed());
        HasEBilling hasEBilling = resultsDisplayedMaybe.map(ResultsDisplayed :: getPreferEBilling).map( value -> new HasEBilling(value.equals(YesNo.Y))).orElse(new HasEBilling(false));
        NoContract noContract = resultsDisplayedMaybe.map(ResultsDisplayed :: getPreferNoContract).map( value -> new NoContract(value.equals(YesNo.Y))).orElse(new NoContract(false));
        RenewableEnergy renewableEnergy = resultsDisplayedMaybe.map(ResultsDisplayed :: getPreferRenewableEnergy).map( value -> new RenewableEnergy(value.equals(YesNo.Y))).orElse(new RenewableEnergy(false));

        return new Preferences(new DisplayDiscount(false),
                hasEBilling,
                noContract,
                new HasPayBillsOnTime(false),
                renewableEnergy);
    }


    private Gas createGas(EnergyPayLoad quote ) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseholdDetails());
        final Optional<EstimateDetails> estimateDetails = Optional.ofNullable(quote.getEstimateDetails());
        boolean hasHouseholdDetails = householdDetailsMaybe.isPresent();
        WhatToCompare whatToCompare = householdDetailsMaybe.map(HouseHoldDetails::getWhatToCompare).orElse(null);
        if (hasHouseholdDetails && hasGas(whatToCompare) ) {
            String currentSupplier = estimateDetails.map(EstimateDetails :: getUsage).map(Usage::getGas).map(getCurrentSupplier()).orElse(null);
            return new Gas(getGasUsageDetails(estimateDetails, householdDetailsMaybe),
                    getGasHouseholdType(estimateDetails) ,
                    getGasHasBill(householdDetailsMaybe),
                    currentSupplier);
        } else {
            return null;
        }
    }

    private GasUsageDetails getGasUsageDetails(Optional<EstimateDetails> estimateDetailsMaybe, Optional<HouseHoldDetails> householdDetailsMaybe) {
        boolean hasUsage = householdDetailsMaybe.map(HouseHoldDetails::getRecentGasBill).map(getYesNoBooleanFunction()).orElse(false);
        if(hasUsage) {
            Integer days =getDays(estimateDetailsMaybe.map(EstimateDetails::getSpend).map(Spend::getGas));
            return new GasUsageDetails(estimateDetailsMaybe.map(EstimateDetails::getSpend)
                    .map(Spend::getGas)
                    .map(spendEnergy -> new BigDecimal(spendEnergy.getAmount())).orElse(null), days,
                    createGasUsage(estimateDetailsMaybe));
        }else {
            return null;
        }
    }

    private GasUsage createGasUsage(Optional<EstimateDetails> estimateDetailsMaybe) {
        final Optional<Energy> gas = estimateDetailsMaybe
                .map(EstimateDetails::getUsage)
                .map(Usage::getGas);
        return new GasUsage(gas
                .map(Energy::getPeak)
                .map(Rate::getAmount)
                .map(BigDecimal::new)
                .orElse(BigDecimal.ZERO),
                gas
                .map(Energy::getOffpeak)
                .map(Rate::getAmount)
                .map(BigDecimal::new)
                .orElse(BigDecimal.ZERO));
    }

    private static ElectricityUsageDetails  getElectricityUsageDetails(Optional<EstimateDetails> estimateDetailsMaybe, Optional<HouseHoldDetails> householdDetailsMaybe) {
        boolean hasUsage = householdDetailsMaybe.map(HouseHoldDetails::getRecentElectricityBill).map(getYesNoBooleanFunction()).orElse(false);
        if(hasUsage) {
            Integer days = getDays(estimateDetailsMaybe.map(EstimateDetails::getSpend).map(Spend::getElectricity));
            return new ElectricityUsageDetails(estimateDetailsMaybe.map(EstimateDetails::getSpend).map(Spend::getElectricity)
                    .map(spendEnergy -> new BigDecimal(spendEnergy.getAmount())).orElse(null), days, getElectricityUsage(estimateDetailsMaybe));
        }else {
            return null;
        }
    }

    private static Integer getDays(Optional<SpendEnergy> spendEnergyMaybe) {
        return spendEnergyMaybe.map(SpendEnergy::getDays).orElse(null);
    }

    private static ElectricityUsage getElectricityUsage(Optional<EstimateDetails> estimateDetailsMaybe) {
        ElectricityUsage electricityUsage = null;
        ElectricityMeterType meter = getElectricityMeterType(estimateDetailsMaybe);
        Float offPeakUsage = estimateDetailsMaybe.map(EstimateDetails::getUsage)
                .map(Usage::getElectricity)
                .map(Energy::getOffpeak)
                .map(Rate::getAmount)
                .orElse(0F);
        Float shoulderAmount = estimateDetailsMaybe.map(EstimateDetails::getUsage)
                .map(Usage::getElectricity)
                .map(Energy::getShoulder)
                .map(Rate::getAmount)
                .orElse(0F);
        Float peakUsage = estimateDetailsMaybe.map(EstimateDetails::getUsage)
                .map(Usage::getElectricity)
                .map(Energy::getPeak)
                .map(Rate::getAmount)
                .orElse(0F);

        if(meter != null) {
            switch (meter) {
                case TimeOfUse:
                    electricityUsage = new TimeOfUseUsage(new BigDecimal(peakUsage), new BigDecimal(offPeakUsage), new BigDecimal(shoulderAmount));
                    break;
                case Single:
                    electricityUsage = new SingleRateUsage(new BigDecimal(peakUsage));
                    break;
                case TwoRate:
                    electricityUsage = new TwoRateUsage(new BigDecimal(peakUsage), new BigDecimal(offPeakUsage));
                    break;
            }
        }
        return electricityUsage;
    }

    private static ElectricityMeterType getElectricityMeterType(Optional<EstimateDetails> estimateDetailsMaybe) {
        return estimateDetailsMaybe.map(EstimateDetails::getElectricity)
                .map(com.ctm.web.energy.form.model.Electricity::getMeter)
                .map(EnergyQuoteServiceRequestAdapter::getElectricityMeterType)
                .orElse(null);
    }

    private static ElectricityMeterType getElectricityMeterType(MeterType meterType) {
        switch (meterType) {
            case S:
                return ElectricityMeterType.Single;
            case T:
                return ElectricityMeterType.TwoRate;
            case M:
                return ElectricityMeterType.TimeOfUse;
            default:
                throw new RuntimeException("Unsupported MeterType " + meterType);
        }
    }


    private boolean getGasHasBill(Optional<HouseHoldDetails> householdDetailsMaybe) {
        return householdDetailsMaybe.map(HouseHoldDetails::getRecentGasBill).map(getYesNoBooleanFunction()).orElse(false);
    }

    private HouseholdDetails createHouseHoldDetails(EnergyPayLoad quote) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseholdDetails());
        return new HouseholdDetails(
                householdDetailsMaybe.map(HouseHoldDetails::getSuburb).orElse(null),
                householdDetailsMaybe.map(HouseHoldDetails::getPostcode).orElse(null),
                householdDetailsMaybe.map(HouseHoldDetails::getMovingIn).map(getYesNoBooleanFunction()).orElse(false),
                householdDetailsMaybe.map(HouseHoldDetails::getMovingInDate)
                .map(LocalDateUtils::parseAUSLocalDate)
                .orElse(null), householdDetailsMaybe.map(HouseHoldDetails::getTariff).orElse(null));
    }

    protected static Electricity createElectricity(EnergyPayLoad quote) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseholdDetails());
        final Optional<EstimateDetails> estimateDetails = Optional.ofNullable(quote.getEstimateDetails());
        boolean hasHouseholdDetails = householdDetailsMaybe.isPresent();
        WhatToCompare whatToCompare = householdDetailsMaybe.map(HouseHoldDetails::getWhatToCompare).orElse(null);
        if (hasHouseholdDetails && hasElectricity(whatToCompare)  ) {
            String currentSupplier = estimateDetails.map(EstimateDetails :: getUsage).map(Usage::getElectricity).map(getCurrentSupplier()).orElse(null);
            return new Electricity(getElectricityUsageDetails(estimateDetails, householdDetailsMaybe), getHouseholdType(estimateDetails),
            getElectrityHasBill(householdDetailsMaybe), getHasSolarPanels(householdDetailsMaybe), currentSupplier);
        } else {
            return null;
        }
    }

    private static Function<com.ctm.web.energy.form.model.Energy, String> getCurrentSupplier() {
        return Energy::getCurrentSupplier;
    }

    private static boolean getElectrityHasBill(Optional<HouseHoldDetails> quote) {
        return quote.map(HouseHoldDetails::getRecentElectricityBill).map(getYesNoBooleanFunction()).orElse(false);
    }

    private static boolean getHasSolarPanels(Optional<HouseHoldDetails> estimateDetailsMaybe) {
        return estimateDetailsMaybe.map(HouseHoldDetails::getSolarPanels).map(getYesNoBooleanFunction()).orElse(false);
    }


    private static HouseholdType getHouseholdType(Optional<EstimateDetails> estimateDetails) {
        return estimateDetails.map(EstimateDetails::getElectricity).map(com.ctm.web.energy.form.model.Energy::getUsage).orElse(null);
    }

    private static HouseholdType getGasHouseholdType(Optional<EstimateDetails> estimateDetails) {
        return estimateDetails.map(EstimateDetails::getGas).map(com.ctm.web.energy.form.model.Energy::getUsage).orElse(null);
    }

    private static Function<YesNo, Boolean> getYesNoBooleanFunction() {
        return value -> value.equals(YesNo.Y);
    }
}
