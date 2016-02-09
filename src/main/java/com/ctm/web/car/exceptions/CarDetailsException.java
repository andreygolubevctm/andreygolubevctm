package com.ctm.web.car.exceptions;

public class CarDetailsException extends Exception {

    private static final long serialVersionUID = 1847984161649849411L;
    private String description;

    public CarDetailsException(String message , Exception e) {
        super(message, e);
    }

    public CarDetailsException(String message) {
        super(message);
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

}
