package com.ctm.model.travel.form;

import com.ctm.model.common.ProviderFilter;

import java.util.Collections;
import java.util.List;

import static java.util.Collections.singletonList;

public class Filter implements ProviderFilter {

    private String singleProvider;
    private String providerKey;

    @Override
    public String getProviderKey() {
        return providerKey == null ? "" : providerKey;
    }

    public void setProviderKey(String providerKey) {
        this.providerKey = providerKey;
    }

    public String getSingleProvider() {
        return singleProvider;
    }

    public void setSingleProvider(String singleProvider) {
        this.singleProvider = singleProvider;
    }

    @Override
    public List<String> getProviders() {
        return singleProvider == null ? Collections.<String>emptyList() : singletonList(singleProvider);
    }
}
