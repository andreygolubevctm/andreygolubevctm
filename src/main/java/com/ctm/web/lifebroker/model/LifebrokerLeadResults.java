package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonRootName;

@JsonRootName("results")
public class LifebrokerLeadResults {

    private LifebrokerLeadResultsClient client;

    public void setClient(LifebrokerLeadResultsClient client) {
        this.client = client;
    }

    public LifebrokerLeadResults withClient(LifebrokerLeadResultsClient client) {
        this.client = client;
        return this;
    }

    public LifebrokerLeadResultsClient getClient() {
        return client;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LifebrokerLeadResults that = (LifebrokerLeadResults) o;
        return client != null ? client.equals(that.client) : that.client == null;
    }

    @Override
    public int hashCode() {
        return client != null ? client.hashCode() : 0;
    }
}
