package com.ctm.providers.health.healthapply.model.request.fundData;

import com.ctm.healthapply.model.request.fundData.benefits.Benefits;
import com.ctm.healthapply.model.request.payment.details.StartDate;
import com.ctm.interfaces.common.types.ProductId;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.LocalDate;
import java.util.Optional;

public class FundData {

    private FundCode fundCode;

    private HospitalCoverName hospitalCoverName;

    private ExtrasCoverName extrasCoverName;

    private Provider provider;

    private ProductId product;

    private Declaration declaration;

    private StartDate startDate;

    private Benefits benefits;

    public Optional<ExtrasCoverName> getExtrasCoverName() {
        return Optional.ofNullable(extrasCoverName);
    }

    public Optional<FundCode> getFundCode() {
        return Optional.ofNullable(fundCode);
    }

    public Optional<HospitalCoverName> getHospitalCoverName() {
        return Optional.ofNullable(hospitalCoverName);
    }

    public Optional<Benefits> getBenefits() {
        return Optional.ofNullable(benefits);
    }

    public Optional<Declaration> getDeclaration() {
        return Optional.ofNullable(declaration);
    }

    public Optional<Provider> getProvider() {
        return Optional.ofNullable(provider);
    }

    public Optional<ProductId> getProduct() {
        return Optional.ofNullable(product);
    }

    public Optional<StartDate> getStartDate() {
        return Optional.ofNullable(startDate);
    }

    @JsonProperty("fundCode")
    private String fundCode() {
        return fundCode == null ? null : fundCode.get();
    }

    @JsonProperty("provider")
    private String provider() {
        return provider == null ? null : provider.get();
    }

    @JsonProperty("product")
    private String product() {
        return product == null ? null : product.get();
    }

    @JsonProperty("hospitalCoverName")
    private String hospitalCoverName() {
        return hospitalCoverName == null ? null : hospitalCoverName.get();
    }

    @JsonProperty("extrasCoverName")
    private String extrasCoverName() {
        return extrasCoverName == null ? null : extrasCoverName.get();
    }

    @JsonProperty("startDate")
    private LocalDate startDate() {
        return startDate == null ? null : startDate.get();
    }
}
