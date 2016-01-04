package com.ctm.web.homecontents.providers.model.request;

import com.ctm.web.core.model.ProviderFilter;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by msmerdon on 25/08/2015.
 */
public class Filter implements ProviderFilter {

    private String providerList = null;
    private List<String> providers = null;
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

    @Override
    public List<String> getProviders() {
        return providers;
    }

    @Override
    public void setProviders(List<String> providers) {
        this.providers = providers;
        if(providers != null && !providers.isEmpty()) {
            String providerList = StringUtils.join(providers,",");
            setProviderList(providerList);
        }
    }

    public String getAuthToken() {
        return authToken;
    }

    public void setAuthToken(String authToken) {
        this.authToken = authToken;
    }
}
