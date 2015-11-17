package com.ctm.web.homecontents.providers.model.request;

public class Property {

    private Address address;

    private String propertyType;

    private String otherPropertyTypeDescription;

    private String wallMaterial;

    private String roofMaterial;

    private String yearBuilt;

    private Boolean heritageListed;

    private boolean bodyCorporate;

    private SecurityFeatures securityFeatures;

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public String getPropertyType() {
        return propertyType;
    }

    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    public String getOtherPropertyTypeDescription() {
        return otherPropertyTypeDescription;
    }

    public void setOtherPropertyTypeDescription(String otherPropertyTypeDescription) {
        this.otherPropertyTypeDescription = otherPropertyTypeDescription;
    }

    public String getWallMaterial() {
        return wallMaterial;
    }

    public void setWallMaterial(String wallMaterial) {
        this.wallMaterial = wallMaterial;
    }

    public String getRoofMaterial() {
        return roofMaterial;
    }

    public void setRoofMaterial(String roofMaterial) {
        this.roofMaterial = roofMaterial;
    }

    public String getYearBuilt() {
        return yearBuilt;
    }

    public void setYearBuilt(String yearBuilt) {
        this.yearBuilt = yearBuilt;
    }

    public Boolean isHeritageListed() {
        return heritageListed;
    }

    public void setHeritageListed(Boolean heritageListed) {
        this.heritageListed = heritageListed;
    }

    public boolean isBodyCorporate() {
        return bodyCorporate;
    }

    public void setBodyCorporate(boolean bodyCorporate) {
        this.bodyCorporate = bodyCorporate;
    }

    public SecurityFeatures getSecurityFeatures() {
        return securityFeatures;
    }

    public void setSecurityFeatures(SecurityFeatures securityFeatures) {
        this.securityFeatures = securityFeatures;
    }
}
