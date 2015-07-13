package com.ctm.model;

public class ResponseError {

    private final String service;

    private ErrorType errorType;

    private String message;

    private String code;

    private String data;

    public ResponseError(String service) {
        this.service = service;
    }

    public String getService() {
        return service;
    }

    public ErrorType getErrorType() {
        return errorType;
    }

    public void setErrorType(ErrorType errorType) {
        this.errorType = errorType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }
}
