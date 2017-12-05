package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

public class LifebrokerLeadResultsContact {

    @JacksonXmlProperty(isAttribute = true)
    private String error;

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }
}
