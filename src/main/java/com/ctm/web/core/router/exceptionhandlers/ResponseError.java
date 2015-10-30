package com.ctm.router.exceptionhandlers;

import java.util.ArrayList;
import java.util.List;

public class ResponseError {

    private List<Message> errors = new ArrayList<>();

    public void addError(String error) {
        Message message = new Message();
        message.setMessage(error);
        errors.add(message);
    }

    public List<Message> getErrors() {
        return errors;
    }
}
