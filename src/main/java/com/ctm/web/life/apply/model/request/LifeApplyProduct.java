package com.ctm.web.life.apply.model.request;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;


public class LifeApplyProduct {

    @NotNull
    @Valid
    private String id;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
