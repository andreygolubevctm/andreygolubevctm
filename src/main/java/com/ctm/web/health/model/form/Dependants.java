package com.ctm.web.health.model.form;

import java.util.ArrayList;
import java.util.List;

public class Dependants {

    private List<Dependant> dependant = new ArrayList<>();

    private Integer income;

    public Integer getIncome() {
        return income;
    }

    public void setIncome(Integer income) {
        this.income = income;
    }

    public List<Dependant> getDependant() {
        return dependant;
    }

    public Dependants setDependant(List<Dependant> dependant) {
        this.dependant = dependant;
        return this;
    }
}
