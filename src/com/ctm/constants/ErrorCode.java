package com.ctm.constants;

/**
 * Created by voba on 27/05/2015.
 */
public enum ErrorCode {
    MK_20004("MK-20004", "Exception in application");

    private final String errorCode;
    private final String description;

    ErrorCode(String errorCode, String description) {
        this.errorCode = errorCode;
        this.description = description;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public String getDescription() {
        return description;
    }
}
