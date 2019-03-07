package com.ctm.web.car.quote.model.request;

import java.io.Serializable;
import java.math.BigDecimal;

public class NonStandardAccessory implements Serializable {

    private String code;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

}
