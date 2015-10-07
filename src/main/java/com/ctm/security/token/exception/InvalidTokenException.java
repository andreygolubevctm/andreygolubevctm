package com.ctm.security.token.exception;


public class InvalidTokenException extends Exception {
    public InvalidTokenException(Exception e) {
        super(e);
    }

    public InvalidTokenException(String message) {
        super(message);
    }
}
