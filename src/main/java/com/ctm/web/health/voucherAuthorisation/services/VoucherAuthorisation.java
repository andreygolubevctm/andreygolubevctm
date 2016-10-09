package com.ctm.web.health.voucherAuthorisation.services;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

/**
 * Created by msmerdon on 5/10/2016.
 */
@JsonAutoDetect(fieldVisibility= JsonAutoDetect.Visibility.ANY)
public class VoucherAuthorisation {

    private String username;
    private String code;
    private java.util.Date effectiveEnd;
    private boolean isAuthorised;

    public VoucherAuthorisation(String username, String code, java.util.Date effectiveEnd, boolean isAuthorised) {
        this.username = username;
        this.code = code;
        this.effectiveEnd = effectiveEnd;
        this.isAuthorised = isAuthorised;
    }
}
