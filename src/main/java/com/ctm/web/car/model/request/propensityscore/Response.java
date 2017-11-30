package com.ctm.web.car.model.request.propensityscore;

import org.springframework.http.HttpStatus;

import java.io.Serializable;

public class Response implements Serializable{

    private HttpStatus status;
    private String message;

    public Response(HttpStatus status, String message) {
        this.status = status;
        this.message = message;
    }

    public HttpStatus getStatus() {
        return status;
    }

    public void setStatus(HttpStatus status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
