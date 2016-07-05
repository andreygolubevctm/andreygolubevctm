package com.ctm.web.life.form.response.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class ResultPremiums {

    @JsonProperty("premium")
    private List<Premium> premiums;

    public List<Premium> getPremiums() {
        return premiums;
    }

    public void setPremiums(List<Premium> premiums) {
        this.premiums = premiums;
    }
}
