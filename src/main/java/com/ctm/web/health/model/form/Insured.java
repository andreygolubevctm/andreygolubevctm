package com.ctm.web.health.model.form;

import java.time.format.DateTimeFormatter;

public class Insured {

    public static final DateTimeFormatter DOB_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private String dob;

    private String cover;

    private String healthCoverLoading;

    private String everHadCover;

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover;
    }

    public String getHealthCoverLoading() {
        return healthCoverLoading;
    }

    public void setHealthCoverLoading(String healthCoverLoading) {
        this.healthCoverLoading = healthCoverLoading;
    }

    public String getEverHadCover() {
        return everHadCover;
    }

    public void setEverHadCover(String everHadCover) { this.everHadCover = everHadCover; }
}
