package com.ctm.web.travel.exceptions;

public class TravelServiceException extends Exception {

    private static final long serialVersionUID = 1L;

    public TravelServiceException(String message){
        super(message);
    }

    public TravelServiceException(String message, Throwable t) {
        super(message, t);
    }
}
