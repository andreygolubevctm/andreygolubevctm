package com.ctm.web.energy.quote.adapter;

import com.ctm.energy.quote.request.model.*;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.form.model.HouseHoldDetails;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

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
        return null;
    }

    private Preferences createPreferences(EnergyResultsWebRequest quote) {
        return null;
    }

    private Gas createGas(EnergyResultsWebRequest quote ) {
        return null;
    }

    private HouseholdDetails createHouseHoldDetails(EnergyResultsWebRequest quote) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseHoldDetails());
        Boolean movingIn = householdDetailsMaybe.isPresent() && toBoolean(householdDetailsMaybe.get().getMovingIn());
        return new HouseholdDetails(
                householdDetailsMaybe.map(HouseHoldDetails::getSuburb).orElse(null),
                householdDetailsMaybe.map(HouseHoldDetails::getPostcode).orElse(null),
                movingIn, householdDetailsMaybe.map(HouseHoldDetails::getMovingInDate)
                .map(v -> LocalDate.parse(v, AUS_FORMAT))
                .orElse(null), householdDetailsMaybe.map(HouseHoldDetails::getTariff).orElse(null));
    }

    protected static boolean toBoolean(String value) {
        return StringUtils.equals("Y", value);
    }
    protected static Electricity createElectricity(EnergyResultsWebRequest quote) {
        final Optional<HouseHoldDetails> householdDetailsMaybe = Optional.ofNullable(quote.getHouseHoldDetails());
        if (householdDetailsMaybe.isPresent() && householdDetailsMaybe.get().getWhatToCompare().equals("E") || householdDetailsMaybe.get().getWhatToCompare().equals("EG") ) {
            return new Electricity(getUsageDetails(quote), getHouseholdType(quote),
            getHasBill(quote), getHasSolarPanels(householdDetailsMaybe), getCurrentSupplier(quote));
        } else {
            return null;
        }
    }

    private static boolean getHasBill(EnergyResultsWebRequest quote) {
        return false;
    }

    private static boolean getHasSolarPanels(Optional<HouseHoldDetails> householdDetailsMaybe) {
        return householdDetailsMaybe.isPresent() && toBoolean(householdDetailsMaybe.get().getHasSolarPanels());
    }

    private static String getCurrentSupplier(EnergyResultsWebRequest quote) {
        return null;
    }

    private static HouseholdType getHouseholdType(EnergyResultsWebRequest quote) {
        return null;
    }

    private static ElectricityUsageDetails getUsageDetails(EnergyResultsWebRequest quote) {
        return null;
    }
}
