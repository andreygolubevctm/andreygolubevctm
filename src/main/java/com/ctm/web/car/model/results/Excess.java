package com.ctm.web.car.model.results;

import java.util.List;

public class Excess {
    private String basicExcess;
    private String glassExcess;

    public Excess() { }

    public Excess(String basicExcess, String glassExcess) {
        this.basicExcess = basicExcess;
        this.glassExcess = glassExcess;
    }

    public String getBasicExcess() {
        return basicExcess;
    }

    public void setBasicExcess(String basicExcess) {
        this.basicExcess = basicExcess;
    }

    public String getGlassExcess() {
        return this.glassExcess;
    }

    public void setGlassExcess(String glassExcess) {
        this.glassExcess = glassExcess;
    }
}
