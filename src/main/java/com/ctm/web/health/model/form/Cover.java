package com.ctm.web.health.model.form;

public class Cover {

//    private String sameProviders;

    // Xpath = "/health/application/{person}/cover/type"
    private String type;

    // Commented out because they aren't used anywhere yet and sonarcloud has an issue with that
//    public String getSameProviders() { return this.sameProviders; }
//
//    public void setSameProviders(String sameProviders) { this.sameProviders = sameProviders; }

    public String getType() { return this.type; }

    public void setType(String type) { this.type = type; }
}
