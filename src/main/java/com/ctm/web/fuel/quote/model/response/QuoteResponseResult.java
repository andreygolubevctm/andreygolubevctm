package com.ctm.web.fuel.quote.model.response;

import com.ctm.fuelquote.model.citysites.Site;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.List;

public class QuoteResponseResult {
    @JsonSerialize
    private QuoteResponseInfo info;

    @JsonSerialize
    private List<Site> sites;

    /* Jackson serialization */
    private QuoteResponseResult() {
    }

    private QuoteResponseResult(Builder builder) {
        info = builder.info;
        sites = builder.sites;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public QuoteResponseInfo getInfo() {
        return info;
    }

    public List<Site> getSites() {
        return sites;
    }

    public static final class Builder {
        private QuoteResponseInfo info;
        private List<Site> sites;

        private Builder() {
        }

        public Builder info(QuoteResponseInfo val) {
            info = val;
            return this;
        }

        public Builder sites(List<Site> val) {
            sites = val;
            return this;
        }

        public QuoteResponseResult build() {
            return new QuoteResponseResult(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        QuoteResponseResult that = (QuoteResponseResult) o;

        if (info != null ? !info.equals(that.info) : that.info != null) return false;
        return sites != null ? sites.equals(that.sites) : that.sites == null;

    }

    @Override
    public int hashCode() {
        int result = info != null ? info.hashCode() : 0;
        result = 31 * result + (sites != null ? sites.hashCode() : 0);
        return result;
    }

    @Override
    public String toString() {
        return "QuoteResponseResult{" +
                "info=" + info +
                ", sites=" + sites +
                '}';
    }
}
