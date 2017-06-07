package com.ctm.energy.product.response.model;

import com.ctm.energy.product.response.model.types.*;
import com.ctm.interfaces.common.aggregator.response.Quote;
import com.ctm.interfaces.common.config.types.ErrorProductCode;
import com.ctm.interfaces.common.types.PartnerError;
import com.ctm.interfaces.common.types.ProductId;
import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.interfaces.common.types.ValueSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.List;

import static java.util.Collections.emptyList;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class EnergyProduct implements Quote {

    @JsonSerialize(using = ValueSerializer.class)
    private ServiceId service;

    @JsonSerialize(using = ValueSerializer.class)
    private ProductId productId;

    @JsonSerialize(using = ValueSerializer.class)
    private RetailerName retailerName;

    @JsonSerialize(using = ValueSerializer.class)
    private PlanName planName;

    @JsonSerialize(using = ValueSerializer.class)
    private PlanDetails planDetails;

    @JsonSerialize(using = ValueSerializer.class)
    private ContractDetails contractDetails;

    @JsonSerialize(using = ValueSerializer.class)
    private BillingOptions billingOptions;

    @JsonSerialize(using = ValueSerializer.class)
    private PricingInformation pricingInformation;

    @JsonSerialize(using = ValueSerializer.class)
    private PaymentDetails paymentDetails;

    @JsonSerialize(using = ValueSerializer.class)
    private TermsUrl termsUrl;

    @JsonSerialize(using = ValueSerializer.class)
    private PrivacyPolicyUrl privacyPolicyUrl;

    private EnergyProduct() {
    }

    private EnergyProduct(ServiceId service,
                         ProductId productId,
                         RetailerName retailerName,
                         PlanName planName,
                         PlanDetails planDetails,
                         ContractDetails contractDetails,
                         BillingOptions billingOptions,
                         PricingInformation pricingInformation,
                         PaymentDetails paymentDetails,
                         TermsUrl termsUrl,
                         PrivacyPolicyUrl privacyPolicyUrl) {
        this.service = service;
        this.productId = productId;
        this.retailerName = retailerName;
        this.planName = planName;
        this.planDetails = planDetails;
        this.contractDetails = contractDetails;
        this.billingOptions = billingOptions;
        this.pricingInformation = pricingInformation;
        this.paymentDetails = paymentDetails;
        this.termsUrl = termsUrl;
        this.privacyPolicyUrl = privacyPolicyUrl;
    }

    public static EnergyProduct successful(ServiceId service,
                                           ProductId productId,
                                           RetailerName retailerName,
                                           PlanName planName,
                                           PlanDetails planDetails,
                                           ContractDetails contractDetails,
                                           BillingOptions billingOptions,
                                           PricingInformation pricingInformation,
                                           PaymentDetails paymentDetails,
                                           TermsUrl termsUrl,
                                           PrivacyPolicyUrl privacyPolicyUrl) {
        return new EnergyProduct(service, productId, retailerName, planName, planDetails,
                contractDetails, billingOptions, pricingInformation, paymentDetails, termsUrl, privacyPolicyUrl);
    }

    public static EnergyProduct fail(ServiceId serviceId, ErrorProductCode errorProductCode) {
        return new EnergyProduct(serviceId, errorProductCode.asProductId(),
                RetailerName.empty(), PlanName.empty(), PlanDetails.empty(), ContractDetails.empty(),
                BillingOptions.empty(), PricingInformation.empty(), PaymentDetails.empty(), TermsUrl.empty(), PrivacyPolicyUrl.empty());
    }

    @Override
    public ServiceId getService() {
        return service;
    }

    @Override
    public ProductId getProductId() {
        return productId;
    }

    @Override
    public List<PartnerError> getErrorList() {
        return emptyList();
    }

    public RetailerName getRetailerName() {
        return retailerName == null ? RetailerName.empty() : retailerName;
    }

    public PlanName getPlanName() {
        return planName == null ? PlanName.empty() : planName;
    }

    public PlanDetails getPlanDetails() {
        return planDetails == null ? PlanDetails.empty() : planDetails;
    }

    public ContractDetails getContractDetails() {
        return contractDetails == null ? ContractDetails.empty() : contractDetails;
    }

    public BillingOptions getBillingOptions() {
        return billingOptions == null ? BillingOptions.empty() : billingOptions;
    }

    public PricingInformation getPricingInformation() {
        return pricingInformation == null ? PricingInformation.empty() : pricingInformation;
    }

    public PaymentDetails getPaymentDetails() {
        return paymentDetails == null ? PaymentDetails.empty() : paymentDetails;
    }

    public TermsUrl getTermsUrl() {
        return termsUrl == null ? TermsUrl.empty() : termsUrl;
    }

    public PrivacyPolicyUrl getPrivacyPolicyUrl() {
        return privacyPolicyUrl == null ? PrivacyPolicyUrl.empty() : privacyPolicyUrl;
    }
}
