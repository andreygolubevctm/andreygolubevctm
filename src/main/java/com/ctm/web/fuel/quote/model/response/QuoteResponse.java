package com.ctm.web.fuel.quote.model.response;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class QuoteResponse {
    @JsonSerialize
    private QuoteResponseResult results;

    private QuoteResponse() {
    }

    private QuoteResponse(Builder builder) {
        results = builder.results;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public QuoteResponseResult getResults() {
        return results;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        QuoteResponse that = (QuoteResponse) o;

        return results != null ? results.equals(that.results) : that.results == null;

    }

    @Override
    public int hashCode() {
        return results != null ? results.hashCode() : 0;
    }

    @Override
    public String toString() {
        return "QuoteResponse{" +
                "results=" + results +
                '}';
    }

    public static final class Builder {
        private QuoteResponseResult results;

        private Builder() {
        }

        public Builder results(QuoteResponseResult val) {
            results = val;
            return this;
        }

        public QuoteResponse build() {
            return new QuoteResponse(this);
        }
    }
}
