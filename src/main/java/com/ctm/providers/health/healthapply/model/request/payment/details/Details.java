package com.ctm.providers.health.healthapply.model.request.payment.details;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Optional;

public class Details {

    @JsonProperty("start")
    private StartDate startDate;

    @JsonProperty("type")
    private PaymentType paymentType;

    private Frequency frequency;

    private Rebate rebate;

    private Income income;

    public Optional<Frequency> getFrequency() {
        return Optional.ofNullable(frequency);
    }

    public Rebate getRebate() {
        return rebate == null ? Rebate.N : rebate;
    }

    public Optional<StartDate> getStartDate() {
        return Optional.ofNullable(startDate);
    }

    public Optional<PaymentType> getPaymentType() {
        return Optional.ofNullable(paymentType);
    }

    public Optional<Income> getIncome() {
        return Optional.ofNullable(income);
    }

    @JsonProperty("income")
    private Long income() {
        return income.get();
    }

    @JsonProperty("start")
    private String startDate() {
        return startDate.get().toString();
    }
}
