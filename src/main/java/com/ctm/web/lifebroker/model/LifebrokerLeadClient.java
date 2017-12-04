package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;

/**
 * Created by msmerdon on 04/12/2017.
 */
@JsonAutoDetect(fieldVisibility= JsonAutoDetect.Visibility.ANY)
public class LifebrokerLeadClient {

    private String name;

    public LifebrokerLeadClient(String name) {
        this.name = name;
    }
}
