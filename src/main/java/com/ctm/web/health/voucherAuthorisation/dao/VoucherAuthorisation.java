package com.ctm.web.health.voucherAuthorisation.dao;

/**
 * Created by msmerdon on 5/10/2016.
 */
public class VoucherAuthorisation {
    private String username;
    private String code;
    private java.util.Date effectiveEnd;
	private boolean isAuthorised;

    public VoucherAuthorisation() {
		this.isAuthorised = false;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public java.util.Date getEffectiveEnd() {
        return effectiveEnd;
    }

    public void setEffectiveEnd(java.util.Date effectiveEnd) {
        this.effectiveEnd = effectiveEnd;
    }

    public boolean getIsAuthorised() {
        return isAuthorised;
    }

    public void setIsAuthorised(boolean isAuthorised) {
        this.isAuthorised = isAuthorised;
    }

}
