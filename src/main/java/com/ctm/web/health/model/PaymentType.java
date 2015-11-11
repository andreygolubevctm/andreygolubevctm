package com.ctm.web.health.model;

/**
 * Created by lbuchanan on 13/01/2015.
 */
public enum PaymentType {
    BANK ("ba"),
    CREDIT ("cc"),
    INV ("inv");

    private final String code;

    PaymentType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Find a membership type by its code.
     * @param code Code e.g. P
     */
    public static PaymentType findByCode(String code) {
        if(code != null){
            for (PaymentType t : PaymentType.values()) {
                if (code.equalsIgnoreCase(t.getCode())) {
                    return t;
                }
            }
        }
        return INV;
    }

}
