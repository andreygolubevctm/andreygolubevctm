package com.ctm.web.core.providers.model;

import java.util.List;

public class AggregateIncomingResponse<T> {

    private Payload<T> payload;

    public Payload<T> getPayload() {
        return payload;
    }

    public static class Payload<T> {

        private List<T> quotes;

        private Payload() {}

        public Payload(List<T> quotes) {
            this.quotes = quotes;
        }

        public List<T> getQuotes() {
            return quotes;
        }
    }
}
