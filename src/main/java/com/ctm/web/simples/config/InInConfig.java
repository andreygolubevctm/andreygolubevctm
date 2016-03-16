package com.ctm.web.simples.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import javax.validation.constraints.NotNull;
import java.util.Objects;

@Component
@ConfigurationProperties(prefix="ctm.web.simples.inin")
public class InInConfig {
    @NotNull private String wsPrimaryUrl;
    @NotNull private String wsFailoverUrl;
    @NotNull private String cicPrimaryUrl;
    @NotNull private String cicFailoverUrl;
    @NotNull private String cicApplicationName;
    @NotNull private String cicUserId;
    @NotNull private String cicPassword;
    @NotNull private String campaignName;
    @NotNull private String expiry;
    @NotNull private String defaultT1;
    @NotNull private String defaultT2;

    public String getWsPrimaryUrl() {
        return wsPrimaryUrl;
    }

    public InInConfig setWsPrimaryUrl(final String wsPrimaryUrl) {
        this.wsPrimaryUrl = wsPrimaryUrl;
        return this;
    }

    public String getWsFailoverUrl() {
        return wsFailoverUrl;
    }

    public InInConfig setWsFailoverUrl(final String wsFailoverUrl) {
        this.wsFailoverUrl = wsFailoverUrl;
        return this;
    }

    public String getCicPrimaryUrl() {
        return cicPrimaryUrl;
    }

    public InInConfig setCicPrimaryUrl(final String cicPrimaryUrl) {
        this.cicPrimaryUrl = cicPrimaryUrl;
        return this;
    }

    public String getCicFailoverUrl() {
        return cicFailoverUrl;
    }

    public InInConfig setCicFailoverUrl(final String cicFailoverUrl) {
        this.cicFailoverUrl = cicFailoverUrl;
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
        return Objects.equals(wsPrimaryUrl, that.wsPrimaryUrl) &&
                Objects.equals(wsFailoverUrl, that.wsFailoverUrl) &&
                Objects.equals(cicPrimaryUrl, that.cicPrimaryUrl) &&
                Objects.equals(cicFailoverUrl, that.cicFailoverUrl) &&
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
        return Objects.hash(wsPrimaryUrl, wsFailoverUrl, cicPrimaryUrl, cicFailoverUrl, cicApplicationName, cicUserId, cicPassword, campaignName, expiry, defaultT1, defaultT2);
    }

    @Override
    public String toString() {
        return "InInConfig{" +
                "wsPrimaryUrl='" + wsPrimaryUrl + '\'' +
                ", wsFailoverUrl='" + wsFailoverUrl + '\'' +
                ", cicPrimaryUrl='" + cicPrimaryUrl + '\'' +
                ", cicFailoverUrl='" + cicFailoverUrl + '\'' +
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
