package com.ctm.web.travel.quote.model.request;

import com.ctm.web.core.model.ProviderFilter;

/**
 * Created by twilson on 30/07/2015.
 */
public class Filter implements ProviderFilter {

    private String singleProvider;
    private String providerKey = null;

    public Filter(){}

    public String getSingleProvider() {
        return singleProvider;
    }

    public void setSingleProvider(String singleProvider) {
        this.singleProvider = singleProvider;
    }

    public String getProviderKey() {
        return providerKey;
    }

    public void setProviderKey(String providerKey) {
        this.providerKey = providerKey;
    }
}
