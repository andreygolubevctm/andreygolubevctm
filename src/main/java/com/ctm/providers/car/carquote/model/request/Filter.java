package com.ctm.providers.car.carquote.model.request;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by msmerdon on 25/08/2015.
 */
public class Filter {

    private String providerList = null;
    private ArrayList<String> providers = null;
    private String authToken = null;

    public Filter(){}

    public String getProviderList() {
        return providerList;
    }

    public void setProviderList(String providerList) {
        if(StringUtils.isNotBlank(providerList)) {
            this.providerList = providerList;
            this.providers = new ArrayList<String>(Arrays.asList(StringUtils.split(providerList,",")));
        }
    }

    public ArrayList<String> getProviders() {
        return providers;
    }

    public void setProviders(ArrayList<String> providers) {
        this.providers = providers;
    }

    public String getAuthToken() {
        return authToken;
    }

    public void setAuthToken(String authToken) {
        this.authToken = authToken;
    }
}
