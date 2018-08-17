package com.ctm.web.health.quote.model.response;

public class Promotion {

    private SpecialOffer specialOffer;

    private SpecialOffer awardScheme;

    private String providerPhoneNumber;

    private String hospitalPDF;

    private String extrasPDF;

    private String discountDescription;

    public SpecialOffer getSpecialOffer() {
        return specialOffer;
    }

    public void setSpecialOffer(SpecialOffer specialOffer) {
        this.specialOffer = specialOffer;
    }

    public String getProviderPhoneNumber() {
        return providerPhoneNumber;
    }

    public void setProviderPhoneNumber(String providerPhoneNumber) {
        this.providerPhoneNumber = providerPhoneNumber;
    }

    public String getHospitalPDF() {
        return hospitalPDF;
    }

    public void setHospitalPDF(String hospitalPDF) {
        this.hospitalPDF = hospitalPDF;
    }

    public String getExtrasPDF() {
        return extrasPDF;
    }

    public void setExtrasPDF(String extrasPDF) {
        this.extrasPDF = extrasPDF;
    }

    public String getDiscountDescription() {
        return discountDescription;
    }

    public void setDiscountDescription(String discountDescription) {
        this.discountDescription = discountDescription;
    }

    public SpecialOffer getAwardScheme() {
        return awardScheme;
    }

    public void setAwardScheme(SpecialOffer awardScheme) {
        this.awardScheme = awardScheme;
    }
}
