package com.ctm.web.homecontents.model;

import javax.validation.Valid;

/**
 * Created by voba on 18/06/2015.
 */
public class HomeRequest {
    @Valid
    private PolicyHolder policyHolder;

    public PolicyHolder getPolicyHolder() {
        return policyHolder;
    }

    public void setPolicyHolder(PolicyHolder policyHolder) {
        this.policyHolder = policyHolder;
    }
}
