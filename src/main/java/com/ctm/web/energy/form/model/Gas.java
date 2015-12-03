package com.ctm.web.energy.form.model;

/**
 * Created by lbuchanan on 23/11/2015.
 */
public class Gas extends Energy{

    Rate peak;

    public Gas(){

    }

    public Rate getPeak() {
        return peak;
    }

    public void setPeak(Rate peak) {
        this.peak = peak;
    }


}
