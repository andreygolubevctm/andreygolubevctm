package com.ctm.web.health.quote.model.request;

import java.util.List;

public class ProviderFilter {

    private List<Integer> providerIds;

    private boolean exclude;

    public List<Integer> getProviderIds() {
        return providerIds;
    }

    public void setProviderIds(List<Integer> providerIds) {
        this.providerIds = providerIds;
    }

    public boolean isExclude() {
        return exclude;
    }

    public void setExclude(boolean exclude) {
        this.exclude = exclude;
    }
}
