package com.ctm.web.homecontents.model.form;

public class Property {

    private Address address;

    private String bodyCorp;

    private String propertyType;

    private String roofMaterial;

    private SecurityFeatures securityFeatures;

    private String wallMaterial;
    
    private String yearBuilt;

    private String bestDescribesHome;

    private String isHeritage;

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public String getBodyCorp() {
        return bodyCorp;
    }

    public void setBodyCorp(String bodyCorp) {
        this.bodyCorp = bodyCorp;
    }

    public String getPropertyType() {
        return propertyType;
    }

    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    public String getRoofMaterial() {
        return roofMaterial;
    }

    public void setRoofMaterial(String roofMaterial) {
        this.roofMaterial = roofMaterial;
    }

    public SecurityFeatures getSecurityFeatures() {
        return securityFeatures;
    }

    public void setSecurityFeatures(SecurityFeatures securityFeatures) {
        this.securityFeatures = securityFeatures;
    }

    public String getWallMaterial() {
        return wallMaterial;
    }

    public void setWallMaterial(String wallMaterial) {
        this.wallMaterial = wallMaterial;
    }

    public String getYearBuilt() {
        return yearBuilt;
    }

    public void setYearBuilt(String yearBuilt) {
        this.yearBuilt = yearBuilt;
    }

    public String getBestDescribesHome() {
        return bestDescribesHome;
    }

    public void setBestDescribesHome(String bestDescribesHome) {
        this.bestDescribesHome = bestDescribesHome;
    }

    public String getIsHeritage() {
        return isHeritage;
    }

    public void setIsHeritage(String isHeritage) {
        this.isHeritage = isHeritage;
    }
}
