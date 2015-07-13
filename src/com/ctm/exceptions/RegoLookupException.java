package com.ctm.exceptions;

import com.ctm.services.car.RegoLookupService;

public class RegoLookupException extends Exception {

    private static final long serialVersionUID = 21651611688654561L;
    private RegoLookupService.RegoLookupStatus status;

    public RegoLookupException(String message , Exception e) {super(message, e);}
    public RegoLookupException(RegoLookupService.RegoLookupStatus status, Exception e){
        super(status.getLabel(), e);
        this.status = status;
    }

    public RegoLookupException(String message) {super(message);}
    public RegoLookupException(RegoLookupService.RegoLookupStatus status) {
        super(status.getLabel());
        this.status = status;
    }

    public void setStatus(RegoLookupService.RegoLookupStatus status) {
        this.status = status;
    }

    public RegoLookupService.RegoLookupStatus getStatus() {
        return status;
    }

}
