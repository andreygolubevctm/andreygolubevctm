package com.ctm.web.email;

/**
 * Created by akhurana on 12/09/17.
 */
public class EmailResponse {
    String message;
    Boolean success;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Boolean getSuccess() {
        return success;
    }

    public void setSuccess(Boolean success) {
        this.success = success;
    }
}
