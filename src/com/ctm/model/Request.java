package com.ctm.model;

public interface Request<QUOTE> {

    String getTransactionId();

    QUOTE getQuote();
}
