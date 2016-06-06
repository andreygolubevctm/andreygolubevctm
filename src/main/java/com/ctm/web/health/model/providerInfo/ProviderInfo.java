package com.ctm.web.health.model.providerInfo;


public class ProviderInfo {
    private ProviderPhoneNumber phoneNumber;
    private ProviderEmail email;
    private ProviderWebsite website;

    public ProviderInfo(ProviderEmail email, ProviderWebsite website, ProviderPhoneNumber phoneNumber) {
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.website = website;

    }

    public ProviderPhoneNumber getPhoneNumber() {
        return phoneNumber;
    }


    public ProviderEmail getEmail() {
        return email;
    }


    public ProviderWebsite getWebsite() {
        return website;
    }

}
