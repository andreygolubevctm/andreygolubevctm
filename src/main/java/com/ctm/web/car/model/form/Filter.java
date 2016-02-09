package com.ctm.web.car.model.form;

import com.ctm.web.core.model.ProviderFilter;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Filter implements ProviderFilter {

    private String providerList;
    private List<String> providers;
    private String authToken;

    public String getProviderList() {
        return providerList;
    }

    public void setProviderList(String providerList) {
        if(StringUtils.isNotBlank(providerList)) {
            this.providers = new ArrayList<String>(Arrays.asList(StringUtils.split(providerList, ",")));
        }
        this.providerList = providerList;
    }

    @Override
    public List<String> getProviders() {
        return providers;
    }

    @Override
    public void setProviders(List<String> providers) {
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
