package com.ctm.web.core.leadfeed.config;

import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Configuration("leads")
public class LeadsConfig {

    private Long expiry = 0L;
    private Map<String, Long> delays;
    private List<String> types;
    private List<String> ctmPartners;

    public List<String> getCtmPartners(){
        return ctmPartners;
    }

    public Long getLeadExpiryTime() {
        return expiry;
    }

    public List<String> getLeadTypes() {
        return types;
    }

    public Map<String, Long> getLeadTypeDelays() {
        return delays;
    }

    public void setCtmPartners(List<String> ctmPartners){
        this.ctmPartners = ctmPartners;
    }

    public void setExpiry(Long expiry) {
        this.expiry = expiry;
    }

    public void setDelays(Map<String, Long> delays) {
        this.delays = delays;
        ArrayList<String> types = new ArrayList<>();
        for(Map.Entry<String, Long> delay: delays.entrySet()){
            types.add(delay.getKey());
        }
    }

}
