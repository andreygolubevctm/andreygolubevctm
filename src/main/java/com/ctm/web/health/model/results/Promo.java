package com.ctm.web.health.model.results;

import java.io.Serializable;

public class Promo implements Serializable {

    private String promoText;

    private String hospitalPDF;

    private String providerPhoneNumber;

    private String extrasPDF;

    private String discountText;

    public String getPromoText() {
        return promoText;
    }

    public void setPromoText(String promoText) {
        this.promoText = promoText;
    }

    public String getHospitalPDF() {
        return hospitalPDF;
    }

    public void setHospitalPDF(String hospitalPDF) {
        this.hospitalPDF = hospitalPDF;
    }

    public String getProviderPhoneNumber() {
        return providerPhoneNumber;
    }

    public void setProviderPhoneNumber(String providerPhoneNumber) {
        this.providerPhoneNumber = providerPhoneNumber;
    }

    public String getExtrasPDF() {
        return extrasPDF;
    }

    public void setExtrasPDF(String extrasPDF) {
        this.extrasPDF = extrasPDF;
    }

    public String getDiscountText() {
        return discountText;
    }

    public void setDiscountText(String discountText) {
        this.discountText = discountText;
    }
}
