package com.ctm.web.simples.phone.inin.model;

import java.util.List;
import java.util.Objects;

public class ConnectionResp {
    private String csrfToken;
    private String sessionId;
    private List<String> alternateHostList;
    private String userID;
    private String userDisplayName;
    private String icServer;

    private ConnectionResp() {
    }

    public String getCsrfToken() {
        return csrfToken;
    }

    public String getSessionId() {
        return sessionId;
    }

    public List<String> getAlternateHostList() {
        return alternateHostList;
    }

    public String getUserID() {
        return userID;
    }

    public String getUserDisplayName() {
        return userDisplayName;
    }

    public String getIcServer() {
        return icServer;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final ConnectionResp that = (ConnectionResp) o;
        return Objects.equals(csrfToken, that.csrfToken) &&
                Objects.equals(sessionId, that.sessionId) &&
                Objects.equals(alternateHostList, that.alternateHostList) &&
                Objects.equals(userID, that.userID) &&
                Objects.equals(userDisplayName, that.userDisplayName) &&
                Objects.equals(icServer, that.icServer);
    }

    @Override
    public int hashCode() {
        return Objects.hash(csrfToken, sessionId, alternateHostList, userID, userDisplayName, icServer);
    }

    @Override
    public String toString() {
        return "ConnectionResp{" +
                "csrfToken='" + csrfToken + '\'' +
                ", sessionId='" + sessionId + '\'' +
                ", alternateHostList=" + alternateHostList +
                ", userID='" + userID + '\'' +
                ", userDisplayName='" + userDisplayName + '\'' +
                ", icServer='" + icServer + '\'' +
                '}';
    }
}
