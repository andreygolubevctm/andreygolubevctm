package com.ctm.web.health.model.results;

import java.io.Serializable;

public class Promo implements Serializable {

    private String promoText;

    private String hospitalPDF;

    private String extrasPDF;

    private String discountText;

    private String providerPhoneNumber;

    private String providerDirectPhoneNumber;

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

    public String getProviderPhoneNumber() {
        return providerPhoneNumber;
    }

    public void setProviderPhoneNumber(String providerPhoneNumber) {
        this.providerPhoneNumber = providerPhoneNumber;
    }

    public String getProviderDirectPhoneNumber() {
        return providerDirectPhoneNumber;
    }

    public void setProviderDirectPhoneNumber(String providerDirectPhoneNumber) {
        this.providerDirectPhoneNumber = providerDirectPhoneNumber;
    }
}
