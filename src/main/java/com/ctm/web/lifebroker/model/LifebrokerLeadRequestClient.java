package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

class LifebrokerLeadRequestClient {

    @JacksonXmlProperty(namespace = LifebrokerLeadRequest.LIFEBROKER_NAMESPACE)
    private final String name;

    LifebrokerLeadRequestClient(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
