package com.ctm.energy.quote.request.model;


import com.ctm.interfaces.common.aggregator.request.QuoteRequest;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModelProperty;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Optional;

import static java.util.Optional.ofNullable;

public class EnergyQuoteRequest implements QuoteRequest {

    @JsonSerialize(using = ValueSerializer.class)
    @ApiModelProperty(dataType = "java.lang.Long")
    private TransactionId transactionId;

    @NotNull
    @Valid
    private  HouseholdDetails householdDetails;

    @Valid
    private ContactDetails contactDetails;

    private Electricity electricity;

    private Gas gas;

    @NotNull
    private  List<EnergyType> energyTypes;

    private  Preferences preferences;

    public EnergyQuoteRequest(HouseholdDetails householdDetails,
                              Electricity electricity, Gas gas,
                              Preferences preferences,
                              List<EnergyType> energyTypes,
                              TransactionId transactionId,
                              ContactDetails contactDetails) {
        this.householdDetails = householdDetails;
        this.electricity = electricity;
        this.gas = gas;
        this.preferences = preferences;
        this.energyTypes = energyTypes;
        this.transactionId = transactionId;
        this.contactDetails = contactDetails;
    }

    @SuppressWarnings("unused")
    private EnergyQuoteRequest(){};

    public HouseholdDetails getHouseholdDetails() {
        return householdDetails;
    }

    public List<EnergyType> getEnergyTypes() {
        return energyTypes;
    }

    public Optional<Electricity> getElectricity() {
        return ofNullable(electricity);
    }

    public Optional<Gas> getGas() {
        return ofNullable(gas);
    }

    public Preferences getPreferences() {
        return preferences;
    }

    public TransactionId getTransactionId() {
        return transactionId;
    }

    public ContactDetails getContactDetails() {
        return contactDetails;
    }
}
