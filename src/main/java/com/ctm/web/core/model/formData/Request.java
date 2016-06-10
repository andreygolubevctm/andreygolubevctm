package com.ctm.web.core.model.formData;

import java.time.LocalDateTime;

public interface Request {

    Long getTransactionId();

    void setTransactionId(Long transactionId);

    void setClientIpAddress(String clientIpAddress);

    String getClientIpAddress();

    void setEnvironmentOverride(String environmentOverride);

    String getEnvironmentOverride();

    void setRequestAt(LocalDateTime requestAt);

    LocalDateTime getRequestAt();

    void setStaticOverride(String staticOverride);

    String getStaticOverride();
}
