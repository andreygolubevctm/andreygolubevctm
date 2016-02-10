package com.ctm.web.simples.phone.inin.model;

import java.util.Objects;

public class SearchWithFilter {
    private String campaignName;
    private String filter;

    private SearchWithFilter() {
    }

    public SearchWithFilter(final String campaignName, final String filter) {
        this.campaignName = campaignName;
        this.filter = filter;
    }

    public String getCampaignName() {
        return campaignName;
    }

    public String getFilter() {
        return filter;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final SearchWithFilter that = (SearchWithFilter) o;
        return Objects.equals(campaignName, that.campaignName) &&
                Objects.equals(filter, that.filter);
    }

    @Override
    public int hashCode() {
        return Objects.hash(campaignName, filter);
    }

    @Override
    public String toString() {
        return "SearchWithFilter{" +
                "campaignName='" + campaignName + '\'' +
                ", filter='" + filter + '\'' +
                '}';
    }
}
