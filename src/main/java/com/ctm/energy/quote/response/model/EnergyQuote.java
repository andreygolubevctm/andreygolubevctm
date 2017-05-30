package com.ctm.energy.quote.response.model;

import com.ctm.energy.quote.response.model.plan.CancellationFees;
import com.ctm.energy.quote.response.model.plan.EstimatedCost;
import com.ctm.energy.quote.response.model.plan.OfferType;
import com.ctm.energy.quote.response.model.plan.PlanName;
import com.ctm.interfaces.common.aggregator.response.Quote;
import com.ctm.interfaces.common.types.PartnerError;
import com.ctm.interfaces.common.types.ProductId;
import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModelProperty;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;
import static java.util.Collections.emptyList;

@JsonInclude(NON_EMPTY)
public class EnergyQuote implements Quote {

	private ServiceId service;

    private String uniqueCustomerId;

	private ProductId productId;
	private String planName;
	private String offerType;
	private String contractPeriod;
	private String cancellationFees;
	private BigDecimal estimatedCost;

	private Retailer retailer;

	private Discount discount;

	private EnergyResult gas;
	private EnergyResult electricity;

	private EnergyQuote(ServiceId serviceId,
						ProductId productId) {
		this.service = serviceId;
		this.productId = productId;
	}

	public EnergyQuote(ServiceId serviceId,
					   ProductId productId,
                       Retailer retailer,
                       PlanName planName,
                       OfferType offerType,
                       String contractPeriod,
                       EstimatedCost estimatedCost,
                       CancellationFees cancellationFees,
                       String uniqueCustomerId, Discount discount,
					   EnergyResult gas,
					   EnergyResult electricity) {
		this.service = serviceId;
		this.productId = productId;
		this.retailer = retailer;
        this.uniqueCustomerId = uniqueCustomerId;
        this.cancellationFees = cancellationFees.get();
		this.planName = planName.get();
		this.offerType = offerType.get();
		this.contractPeriod = contractPeriod;
		this.estimatedCost = estimatedCost.get();
		this.discount = discount;
		this.gas = gas;
		this.electricity = electricity;
	}

    @SuppressWarnings("unused")
	private EnergyQuote(){

	}

	@Override
	@JsonSerialize(using = ValueSerializer.class)
	public ServiceId getService() {
		return service;
	}

    @JsonSerialize(using = ValueSerializer.class)
    @ApiModelProperty(dataType = "java.lang.String")
	public ProductId getProductId() {
		return productId;
	}

	@Override
	public List<PartnerError> getErrorList() {
		return emptyList();
	}

	public String getPlanName() {
		return planName;
	}


	public String getOfferType() {
		return offerType;
	}


	public String getContractPeriod() {
		return contractPeriod;
	}


	public String getCancellationFees() {
		return cancellationFees;
	}


	public Discount getDiscount() {
		return discount;
	}




	public BigDecimal getEstimatedCost() {
		return estimatedCost;
	}

	public Retailer getRetailer() {
		return retailer;
	}

    public String getUniqueCustomerId() {
        return uniqueCustomerId;
    }

	public final static EnergyQuote unavailable(ServiceId serviceId, ProductId productId) {
		return new EnergyQuote(serviceId, productId);
	}

	public Optional<EnergyResult> getGas() {
		return Optional.ofNullable(gas);
	}

	public Optional<EnergyResult> getElectricity() {
		return Optional.ofNullable(electricity);
	}
}
