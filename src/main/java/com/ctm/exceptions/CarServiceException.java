package com.ctm.exceptions;

public class CarServiceException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public CarServiceException(String message){
        super(message);
    }

    public CarServiceException(String message, Throwable t) {
        super(message, t);
    }
}
