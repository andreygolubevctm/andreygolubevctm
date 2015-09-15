package com.ctm.connectivity.exception;

public class ConnectionException extends RuntimeException {
    public ConnectionException(String s, Exception e) {
        super( s,  e);
    }
}
