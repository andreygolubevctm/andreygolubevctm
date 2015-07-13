package com.ctm.model;

import java.util.List;

public class Response<T> {

    private final List<ResponseError> errors;

    private final T payload;

    private long responseTime;

    public Response(List<ResponseError> errors, T payload) {
        this.errors = errors;
        this.payload = payload;
    }

    public Response(T payload) {
        this.errors = null;
        this.payload = payload;
    }

    public List<ResponseError> getErrors() {
        return errors;
    }

    public T getPayload() {
        return payload;
    }

    public long getResponseTime() {
        return responseTime;
    }

    public void setResponseTime(long responseTime) {
        this.responseTime = responseTime;
    }
}
