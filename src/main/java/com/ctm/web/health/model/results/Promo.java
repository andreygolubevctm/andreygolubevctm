package com.ctm.web.health.model.results;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class Promo implements Serializable {

    private String promoText;

    private String hospitalPDF;

    private String extrasPDF;

    private String discountText;

    private String providerPhoneNumber;

    private String providerDirectPhoneNumber;

    private String promoDescription;

    private String promoTerms;
}
