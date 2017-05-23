package com.ctm.energy.provider.response.model;

import com.ctm.energy.provider.response.model.provider.ElectricityProvider;
import com.ctm.energy.provider.response.model.provider.GasProvider;
import com.ctm.energy.provider.response.model.types.ElectricityTariff;
import com.ctm.interfaces.common.aggregator.response.Quote;
import com.ctm.interfaces.common.types.PartnerError;
import com.ctm.interfaces.common.types.ProductId;
import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.List;

import static java.util.Collections.emptyList;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class EnergyProviders implements Quote {

    @JsonSerialize(using = ValueSerializer.class)
    private ServiceId service;

    @JsonSerialize(using = ValueSerializer.class)
    private ProductId productId;

    private List<ElectricityProvider> electricityProviders;

    @JsonSerialize(using = ValueSerializer.class)
    private ElectricityTariff electricityTariff;

    private List<GasProvider> gasProviders;

    // JSON constructor
    private EnergyProviders() {
    }

    private EnergyProviders(ServiceId serviceId,
                            ProductId productId,
                            List<ElectricityProvider> electricityProviders,
                            List<GasProvider> gasProviders,
                            ElectricityTariff electricityTariff) {
        this.service = serviceId;
        this.productId = productId;
        this.electricityProviders = electricityProviders;
        this.gasProviders = gasProviders;
        this.electricityTariff = electricityTariff;
    }

    @Override
    public ServiceId getService() {
        return service;
    }

    @Override
    public ProductId getProductId() {
        return productId;
    }

    public List<ElectricityProvider> getElectricityProviders() {
        return electricityProviders;
    }

    public List<GasProvider> getGasProviders() {
        return gasProviders;
    }

    public ElectricityTariff getElectricityTariff() {
        return electricityTariff;
    }

    @Override
    public List<PartnerError> getErrorList() {
        return emptyList();
    }

    public static EnergyProviders unavailable(ServiceId serviceId, ProductId productId) {
        return new EnergyProviders(serviceId, productId, null, null, null);
    }

    public static EnergyProviders success(ServiceId serviceId,
                                          ProductId productId,
                                          List<ElectricityProvider> electricityProviders,
                                          List<GasProvider> gasProviders,
                                          ElectricityTariff electricityTariff) {
        return new EnergyProviders(serviceId, productId, electricityProviders, gasProviders, electricityTariff);
    }
}
