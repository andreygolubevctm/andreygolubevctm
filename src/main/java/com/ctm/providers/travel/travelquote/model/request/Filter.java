package com.ctm.providers.travel.travelquote.model.request;

/**
 * Created by twilson on 30/07/2015.
 */
public class Filter {

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
