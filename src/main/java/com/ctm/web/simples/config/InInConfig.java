package com.ctm.web.simples.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import javax.validation.constraints.NotNull;

@Component
@ConfigurationProperties(prefix="ctm.web.simples.inin")
public class InInConfig {
    @NotNull private String wsUrl;
    @NotNull private String cicUrl;
    @NotNull private String cicApplicationName;
    @NotNull private String cicUserId;
    @NotNull private String cicPassword;
    @NotNull private String campaignName;
    @NotNull private String expiry;
    @NotNull private String defaultT1;
    @NotNull private String defaultT2;


    public String getWsUrl() {
        return wsUrl;
    }

    public InInConfig setWsUrl(final String wsUrl) {
        this.wsUrl = wsUrl;
        return this;
    }

    public String getCicUrl() {
        return cicUrl;
    }

    public InInConfig setCicUrl(final String cicUrl) {
        this.cicUrl = cicUrl;
        return this;
    }

    public String getCicApplicationName() {
        return cicApplicationName;
    }

    public InInConfig setCicApplicationName(final String cicApplicationName) {
        this.cicApplicationName = cicApplicationName;
        return this;
    }

    public String getCicUserId() {
        return cicUserId;
    }

    public InInConfig setCicUserId(final String cicUserId) {
        this.cicUserId = cicUserId;
        return this;
    }

    public String getCicPassword() {
        return cicPassword;
    }

    public InInConfig setCicPassword(final String cicPassword) {
        this.cicPassword = cicPassword;
        return this;
    }


    public String getCampaignName() {
        return campaignName;
    }

    public void setCampaignName(final String campaignName) {
        this.campaignName = campaignName;
    }

    public String getExpiry() {
        return expiry;
    }

    public void setExpiry(final String expiry) {
        this.expiry = expiry;
    }

    public String getDefaultT1() {
        return defaultT1;
    }

    public void setDefaultT1(final String defaultT1) {
        this.defaultT1 = defaultT1;
    }

    public String getDefaultT2() {
        return defaultT2;
    }

    public void setDefaultT2(final String defaultT2) {
        this.defaultT2 = defaultT2;
    }

    @Override
    public String toString() {
        return "InInConfig{" +
                "wsUrl='" + wsUrl + '\'' +
                ", cicUrl='" + cicUrl + '\'' +
                ", cicApplicationName='" + cicApplicationName + '\'' +
                ", cicUserId='" + cicUserId + '\'' +
                ", cicPassword='" + cicPassword + '\'' +
                ", campaignName='" + campaignName + '\'' +
                ", expiry='" + expiry + '\'' +
                ", defaultT1='" + defaultT1 + '\'' +
                ", defaultT2='" + defaultT2 + '\'' +
                '}';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (!(o instanceof InInConfig)) return false;

        final InInConfig that = (InInConfig) o;

        if (!wsUrl.equals(that.wsUrl)) return false;
        if (!cicUrl.equals(that.cicUrl)) return false;
        if (!cicApplicationName.equals(that.cicApplicationName)) return false;
        if (!cicUserId.equals(that.cicUserId)) return false;
        if (!cicPassword.equals(that.cicPassword)) return false;
        if (!campaignName.equals(that.campaignName)) return false;
        if (!expiry.equals(that.expiry)) return false;
        if (!defaultT1.equals(that.defaultT1)) return false;
        return defaultT2.equals(that.defaultT2);

    }

    @Override
    public int hashCode() {
        int result = wsUrl.hashCode();
        result = 31 * result + cicUrl.hashCode();
        result = 31 * result + cicApplicationName.hashCode();
        result = 31 * result + cicUserId.hashCode();
        result = 31 * result + cicPassword.hashCode();
        result = 31 * result + campaignName.hashCode();
        result = 31 * result + expiry.hashCode();
        result = 31 * result + defaultT1.hashCode();
        result = 31 * result + defaultT2.hashCode();
        return result;
    }
}
