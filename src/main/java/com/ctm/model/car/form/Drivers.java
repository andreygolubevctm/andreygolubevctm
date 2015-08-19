package com.ctm.model.car.form;

import javax.validation.Valid;

public class Drivers {

    @Valid
    private Regular regular;

    private Spouse spouse;

    private Young young;

    public Regular getRegular() {
        return regular;
    }

    public void setRegular(Regular regular) {
        this.regular = regular;
    }

    public Spouse getSpouse() {
        return spouse;
    }

    public void setSpouse(Spouse spouse) {
        this.spouse = spouse;
    }

    public Young getYoung() {
        return young;
    }

    public void setYoung(Young young) {
        this.young = young;
    }
}
