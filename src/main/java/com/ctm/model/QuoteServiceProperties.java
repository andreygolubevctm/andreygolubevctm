package com.ctm.model;

public class QuoteServiceProperties {

    private String serviceUrl;

    private String debugPath;

    private int timeout = 32000;

    public String getServiceUrl() {
        return serviceUrl;
    }

    public void setServiceUrl(String serviceUrl) {
        this.serviceUrl = serviceUrl;
    }

    public String getDebugPath() {
        return debugPath;
    }

    public void setDebugPath(String debugPath) {
        this.debugPath = debugPath;
    }

    public int getTimeout() {
        return timeout;
    }

    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }
}
