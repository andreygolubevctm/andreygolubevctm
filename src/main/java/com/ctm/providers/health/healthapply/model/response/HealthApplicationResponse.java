package com.ctm.providers.health.healthapply.model.response;

import com.ctm.interfaces.common.aggregator.response.Quote;
import com.ctm.interfaces.common.config.types.ErrorProductCode;
import com.ctm.interfaces.common.types.ProductId;
import com.ctm.interfaces.common.types.ServiceId;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.Collections;
import java.util.List;

public class HealthApplicationResponse implements Quote{

    @NotNull
    @Size(min=1)
    public final String fundId;

    @JsonProperty("productId")
    @NotNull
    @Size(min=1)
    public final String productId;

    @NotNull
    public final Status success;

    public final List<PartnerError> errorList;


    // empty constructor needed by jackson
    @SuppressWarnings("UnusedDeclaration")
    private HealthApplicationResponse() {
        this(ProductId.instanceOf(""), ServiceId.instanceOf(""), Status.Success, Collections.emptyList());
    }

    private HealthApplicationResponse(final ProductId productId, final ServiceId fundId, final Status success,
                                     final List<PartnerError> errorList) {
        this.productId = productId.get();
        this.fundId = fundId.get();
        this.success = success;
        this.errorList = Collections.unmodifiableList(errorList);
    }

    public static HealthApplicationResponse success (final ProductId productId,
                                                     final ServiceId fundId,
                                                     final Status success,
                                                     final List<PartnerError> errorList) {
        return new HealthApplicationResponse(productId, fundId, success, errorList);
    }

    public static HealthApplicationResponse fail (final ProductId productId,
                                                     final ServiceId fundId,
                                                     final Status success,
                                                     final List<PartnerError> errorList) {
        return new HealthApplicationResponse(productId, fundId, success, errorList);
    }

    public static HealthApplicationResponse unavailable (final ErrorProductCode errorProductCode,
                                                        final ServiceId fundId) {
        return new HealthApplicationResponse(errorProductCode.asProductId(), fundId, Status.Fail, Collections.emptyList());
    }

    @JsonIgnore
    @Override
    public ServiceId getService() {
        return ServiceId.instanceOf(fundId);
    }

    @JsonIgnore
    @Override
    public ProductId getProductId() {
        return ProductId.instanceOf(productId);
    }

}
