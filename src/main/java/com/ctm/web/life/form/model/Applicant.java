package com.ctm.web.life.form.model;

import com.ctm.life.model.request.State;
import com.ctm.web.core.validation.FortyCharHash;

public class Applicant extends Person {

    private String postCode;

    private State state;

    @FortyCharHash
    private String occupation;

    private String occupationTitle;

    private Insurance insurance;

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }

    public State getState() {
        return state;
    }

    public void setState(State state) {
        this.state = state;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getOccupationTitle() {
        return occupationTitle;
    }

    public void setOccupationTitle(String occupationTitle) {
        this.occupationTitle = occupationTitle;
    }

    public Insurance getInsurance() {
        return insurance;
    }

    public void setInsurance(Insurance insurance) {
        this.insurance = insurance;
    }
}
