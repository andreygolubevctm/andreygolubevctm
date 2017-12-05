package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonRootName;

@JsonRootName("results")
public class LifebrokerLeadResults {

    private LifebrokerLeadResultsClient client;

    private LifebrokerLeadResultsContact contact;

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

    public LifebrokerLeadResultsContact getContact() {
        return contact;
    }

    public void setContact(LifebrokerLeadResultsContact contact) {
        this.contact = contact;
    }

    public LifebrokerLeadResults withContact(LifebrokerLeadResultsContact contact) {
        this.contact = contact;
        return this;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        LifebrokerLeadResults that = (LifebrokerLeadResults) o;

        if (client != null ? !client.equals(that.client) : that.client != null) return false;
        return contact != null ? contact.equals(that.contact) : that.contact == null;
    }

    @Override
    public int hashCode() {
        int result = client != null ? client.hashCode() : 0;
        result = 31 * result + (contact != null ? contact.hashCode() : 0);
        return result;
    }
}
