package com.ctm.web.simples.phone.inin.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Objects;

public class ConnectionReq {
    @JsonProperty("__type")
    private String type;

    private String applicationName;

    @JsonProperty("userID")
    private String userId;

    private String password;

    private ConnectionReq() {
    }

    public ConnectionReq(final String type, final String applicationName, final String userId, final String password) {
        this.type = type;
        this.applicationName = applicationName;
        this.userId = userId;
        this.password = password;
    }

    public String getType() {
        return type;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public String getUserId() {
        return userId;
    }

    public String getPassword() {
        return password;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final ConnectionReq that = (ConnectionReq) o;
        return Objects.equals(type, that.type) &&
                Objects.equals(applicationName, that.applicationName) &&
                Objects.equals(userId, that.userId) &&
                Objects.equals(password, that.password);
    }

    @Override
    public int hashCode() {
        return Objects.hash(type, applicationName, userId, password);
    }

    @Override
    public String toString() {
        return "ConnectionReq{" +
                "type='" + type + '\'' +
                ", applicationName='" + applicationName + '\'' +
                ", userId='" + userId + '\'' +
                ", password='" + password + '\'' +
                '}';
    }
}
