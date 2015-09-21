package com.ctm.providers.health.healthapply.model.request.application.applicant.previousFund;


import java.util.function.Supplier;

public class MemberId implements Supplier<String> {

    private final String memberId;

    public MemberId(final String memberId) {
        this.memberId = memberId;
    }

    @Override
    public String get() {
        return memberId;
    }
}