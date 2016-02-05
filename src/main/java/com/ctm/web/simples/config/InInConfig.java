package com.ctm.web.simples.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import javax.validation.constraints.NotNull;
import java.util.Objects;

@Component
@ConfigurationProperties(prefix="ctm.web.simples.inin")
public class InInConfig {
    @NotNull private String wsUrl;
    @NotNull private String cicPrimaryUrl;
    @NotNull private String cicFalloverUrl;
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

    public String getCicPrimaryUrl() {
        return cicPrimaryUrl;
    }

    public InInConfig setCicPrimaryUrl(final String cicPrimaryUrl) {
        this.cicPrimaryUrl = cicPrimaryUrl;
        return this;
    }

    public String getCicFalloverUrl() {
        return cicFalloverUrl;
    }

    public InInConfig setCicFalloverUrl(final String cicFalloverUrl) {
        this.cicFalloverUrl = cicFalloverUrl;
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

    public InInConfig setCampaignName(final String campaignName) {
        this.campaignName = campaignName;
        return this;
    }

    public String getExpiry() {
        return expiry;
    }

    public InInConfig setExpiry(final String expiry) {
        this.expiry = expiry;
        return this;
    }

    public String getDefaultT1() {
        return defaultT1;
    }

    public InInConfig setDefaultT1(final String defaultT1) {
        this.defaultT1 = defaultT1;
        return this;
    }

    public String getDefaultT2() {
        return defaultT2;
    }

    public InInConfig setDefaultT2(final String defaultT2) {
        this.defaultT2 = defaultT2;
        return this;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final InInConfig that = (InInConfig) o;
        return Objects.equals(wsUrl, that.wsUrl) &&
                Objects.equals(cicPrimaryUrl, that.cicPrimaryUrl) &&
                Objects.equals(cicFalloverUrl, that.cicFalloverUrl) &&
                Objects.equals(cicApplicationName, that.cicApplicationName) &&
                Objects.equals(cicUserId, that.cicUserId) &&
                Objects.equals(cicPassword, that.cicPassword) &&
                Objects.equals(campaignName, that.campaignName) &&
                Objects.equals(expiry, that.expiry) &&
                Objects.equals(defaultT1, that.defaultT1) &&
                Objects.equals(defaultT2, that.defaultT2);
    }

    @Override
    public int hashCode() {
        return Objects.hash(wsUrl, cicPrimaryUrl, cicFalloverUrl, cicApplicationName, cicUserId, cicPassword, campaignName, expiry, defaultT1, defaultT2);
    }

    @Override
    public String toString() {
        return "InInConfig{" +
                "wsUrl='" + wsUrl + '\'' +
                ", cicPrimaryUrl='" + cicPrimaryUrl + '\'' +
                ", cicFalloverUrl='" + cicFalloverUrl + '\'' +
                ", cicApplicationName='" + cicApplicationName + '\'' +
                ", cicUserId='" + cicUserId + '\'' +
                ", cicPassword='" + cicPassword + '\'' +
                ", campaignName='" + campaignName + '\'' +
                ", expiry='" + expiry + '\'' +
                ", defaultT1='" + defaultT1 + '\'' +
                ", defaultT2='" + defaultT2 + '\'' +
                '}';
    }
}
