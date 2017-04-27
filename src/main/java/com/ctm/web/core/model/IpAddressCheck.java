package com.ctm.web.core.model;

import org.json.JSONException;
import org.json.JSONObject;

public class IpAddressCheck extends AbstractJsonModel {

    private String ip;
    private Boolean success;
    private Boolean isLocal;
    private String error;

    public IpAddressCheck() {
        this.ip = null;
        this.success = null;
        this.isLocal = null;
        this.error = null;
    }

    public void setIP(String ip) {
        this.ip = ip;
    }

    public String getIP() {
        return ip;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Boolean getSuccess() {
        return success;
    }

    public void setIsLocal(boolean isLocal) {
        this.isLocal = isLocal;
    }

    public Boolean getIsLocal() {
        return isLocal;
    }

    public void setError(String error) {
        this.error = error;
    }

    public String getError() {
        return error;
    }

    @Override
    public JSONObject getJsonObject() throws JSONException {
        JSONObject json = new JSONObject();
        json.put("ip", getIP());
        json.put("success", getSuccess());
        json.put("isLocal", getIsLocal());
        json.put("error", getError());
        return json;
    }
}
