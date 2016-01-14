package com.ctm.web.core.model.request;

import com.ctm.web.core.model.formData.Request;

import static com.ctm.web.core.utils.PhoneNumberUtil.stripOffNonNumericChars;

public class ContactValidatorRequest implements Request {

    private String clientIpAddress;

    private String contact;

    private Long transactionId;

    private String environmentOverride;

    @Override
    public String getClientIpAddress() {
        return clientIpAddress;
    }

    @Override
    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = stripOffNonNumericChars(contact);
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    @Override
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    @Override
    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    @Override
    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }
}
