package com.ctm.web.energy.quote.request.model;

/**
 * Created by lbuchanan on 17/11/2015.
 */
public enum Period {

    MONTHLY ("Monthly","M"),
    BIMONTHLY ("Bimonthly","B"),
    QUARTERLY ("Quarterly","Q"),
    YEARLY ("Yearly","Y");

    private final String label, code;

    Period(String label, String code) {
        this.label = label;
        this.code = code;
    }

    public String getLabel() {
        return label;
    }
    public String getCode() {
        return code;
    }

    public static Period findByCode(String code) {
        for (Period t : Period.values()) {
            if (code.equals(t.getCode())) {
                return t;
            }
        }
        return null;
    }
}
