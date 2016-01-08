package com.ctm.web.energy.apply.model.response;

import com.ctm.web.energy.form.model.WhatToCompare;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlRootElement;

@JacksonXmlRootElement(localName = "confirmation")
public class EnergyConfirmationData {


    private final String firstName;

    private final WhatToCompare whatToCompare;

    private final String uniquePurchaseId;

    private final ProductConfirmationData product;


    public EnergyConfirmationData(String firstName, WhatToCompare whatToCompare, String uniquePurchaseId, ProductConfirmationData product) {
        this.firstName = firstName;
        this.whatToCompare = whatToCompare;
        this.uniquePurchaseId = uniquePurchaseId;
        this.product = product;
    }

    public String getFirstName() {
        return firstName;
    }

    public WhatToCompare getWhatToCompare() {
        return whatToCompare;
    }

    public String getUniquePurchaseId() {
        return uniquePurchaseId;
    }

    public ProductConfirmationData getProduct() {
        return product;
    }
}
