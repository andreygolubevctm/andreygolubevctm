package com.ctm.model.car.form;

import com.ctm.model.common.ProviderFilter;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;

public class Filter implements ProviderFilter {

    private String providerList;

    private ArrayList<String> providers;

    private String authToken;

    public String getProviderList() {
        return providerList;
    }

    public void setProviderList(String providerList) {
        if(StringUtils.isNotBlank(providerList)) {
            this.providerList = providerList;
            this.providers = new ArrayList<String>(Arrays.asList(StringUtils.split(providerList, ",")));
        }
        this.providerList = providerList;
    }

    @Override
    public ArrayList<String> getProviders() {
        return providers;
    }

    public void setProviders(ArrayList<String> providers) {
        this.providers = providers;
    }

    @Override
    public String getAuthToken() {
        return authToken;
    }

    public void setAuthToken(String authToken) {
        this.authToken = authToken;
    }
}
