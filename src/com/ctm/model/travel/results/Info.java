package com.ctm.model.travel.results;

import java.util.ArrayList;

/**
 * Part of the Java model which will build the travel result sent to the front end.
 */
public class Info {

    ArrayList<Benefit> benefits;

    public Info(){

    }

    public ArrayList<Benefit> getBenefits() {
        return benefits;
    }

    public void setBenefits(ArrayList<Benefit> benefits) {
        this.benefits = benefits;
    }
}
