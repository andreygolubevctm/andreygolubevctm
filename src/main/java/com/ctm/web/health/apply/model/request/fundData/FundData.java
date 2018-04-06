package com.ctm.web.health.apply.model.request.fundData;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.ctm.web.health.apply.model.request.fundData.benefits.Benefits;
import com.ctm.web.health.apply.model.request.fundData.membership.Membership;
import com.fasterxml.jackson.annotation.JsonFormat;
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
    @JsonFormat(pattern = "yyyy-MM-dd")
    private final LocalDate startDate;

    private final Benefits benefits;

    private final Membership membership;

    private final Referrer referrer;

    public FundData(final Provider provider, final ProductId product, final Declaration declaration,
                    final LocalDate startDate, final Benefits benefits, final Membership membership,
                    final Referrer referrer) {
        this.provider = provider;
        this.product = product;
        this.declaration = declaration;
        this.startDate = startDate;
        this.benefits = benefits;
        this.membership = membership;
        this.referrer = referrer;
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

    public Membership getMembership() {
        return membership;
    }

    public Referrer getReferrer() {
        return referrer;
    }
}
