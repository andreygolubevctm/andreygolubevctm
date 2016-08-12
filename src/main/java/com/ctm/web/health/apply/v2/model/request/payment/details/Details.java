package com.ctm.web.health.apply.v2.model.request.payment.details;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Details {

    @JsonSerialize(using = LocalDateSerializer.class)
    @JsonFormat(pattern = "yyyy-MM-dd")
    private final LocalDate startDate;

    private final PaymentType paymentType;

    private final Frequency frequency;

    private final Rebate rebate;

    @JsonSerialize(using = TypeSerializer.class)
    private final RebatePercentage rebatePercentage;

    @JsonSerialize(using = TypeSerializer.class)
    private final Income income;

    @JsonSerialize(using = TypeSerializer.class)
    private final LifetimeHealthCoverLoading lifetimeHealthCoverLoading;

    public Details(final LocalDate startDate, final PaymentType paymentType, final Frequency frequency,
                   final Rebate rebate, final RebatePercentage rebatePercentage,
                   final Income income, final LifetimeHealthCoverLoading lifetimeHealthCoverLoading) {
        this.startDate = startDate;
        this.paymentType = paymentType;
        this.frequency = frequency;
        this.rebate = rebate;
        this.rebatePercentage = rebatePercentage;
        this.income = income;
        this.lifetimeHealthCoverLoading = lifetimeHealthCoverLoading;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public PaymentType getPaymentType() {
        return paymentType;
    }

    public Frequency getFrequency() {
        return frequency;
    }

    public Rebate getRebate() {
        return rebate;
    }

    public RebatePercentage getRebatePercentage() {
        return rebatePercentage;
    }

    public Income getIncome() {
        return income;
    }

    public LifetimeHealthCoverLoading getLifetimeHealthCoverLoading() {
        return lifetimeHealthCoverLoading;
    }
}
