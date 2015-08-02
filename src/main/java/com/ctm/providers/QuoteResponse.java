package com.ctm.providers;

import java.util.List;

public class QuoteResponse<T> {

    public List<T> quotes;

    public List<T> getQuotes() {
        return quotes;
    }

    public void setQuotes(List<T> quotes) {
        this.quotes = quotes;
    }
}
