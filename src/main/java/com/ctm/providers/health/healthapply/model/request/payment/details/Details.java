package com.ctm.providers.health.healthapply.model.request.payment.details;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Details {

    @JsonProperty("start")
    private final StartDate startDate;

    @JsonProperty("type")
    private final PaymentType paymentType;

    private final Frequency frequency;

    private final Rebate rebate;

    private final Income income;

    public Details(final StartDate startDate, final PaymentType paymentType, final Frequency frequency,
                   final Rebate rebate, final Income income) {
        this.startDate = startDate;
        this.paymentType = paymentType;
        this.frequency = frequency;
        this.rebate = rebate;
        this.income = income;
    }
}
