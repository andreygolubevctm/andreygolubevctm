package com.ctm.providers.health.healthapply.model.request.fundData;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.ctm.providers.health.healthapply.model.request.fundData.benefits.Benefits;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class FundData {

    @JsonSerialize(using = TypeSerializer.class)
    private final Provider provider;

    @JsonSerialize(using = TypeSerializer.class)
    private final ProductId product;

    private final Declaration declaration;

    @JsonSerialize(using = LocalDateSerializer.class)
    private final LocalDate startDate;

    private final Benefits benefits;

    public FundData(final Provider provider, final ProductId product,
                    final Declaration declaration, final LocalDate startDate, final Benefits benefits) {
        this.provider = provider;
        this.product = product;
        this.declaration = declaration;
        this.startDate = startDate;
        this.benefits = benefits;
    }

    public Provider getProvider() {
        return provider;
    }

    public ProductId getProduct() {
        return product;
    }

    public Declaration getDeclaration() {
        return declaration;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public Benefits getBenefits() {
        return benefits;
    }
}
