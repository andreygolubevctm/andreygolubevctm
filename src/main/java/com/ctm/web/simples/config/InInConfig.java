package com.ctm.web.simples.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import javax.validation.constraints.NotNull;
import java.util.Objects;

@Component
@ConfigurationProperties(prefix="ctm.web.simples.inin")
public class InInConfig {
    @NotNull private String wsUrl;
    @NotNull private String cicUrl;
    @NotNull private String cicApplicationName;
    @NotNull private String cicUserId;
    @NotNull private String cicPassword;

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

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final InInConfig that = (InInConfig) o;
        return Objects.equals(wsUrl, that.wsUrl) &&
                Objects.equals(cicUrl, that.cicUrl) &&
                Objects.equals(cicApplicationName, that.cicApplicationName) &&
                Objects.equals(cicUserId, that.cicUserId) &&
                Objects.equals(cicPassword, that.cicPassword);
    }

    @Override
    public int hashCode() {
        return Objects.hash(wsUrl, cicUrl, cicApplicationName, cicUserId, cicPassword);
    }

    @Override
    public String toString() {
        return "InInConfig{" +
                "wsUrl='" + wsUrl + '\'' +
                ", cicUrl='" + cicUrl + '\'' +
                ", cicApplicationName='" + cicApplicationName + '\'' +
                ", cicUserId='" + cicUserId + '\'' +
                ", cicPassword='" + cicPassword + '\'' +
                '}';
    }
}
