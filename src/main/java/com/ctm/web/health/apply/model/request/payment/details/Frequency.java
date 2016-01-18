package com.ctm.web.health.apply.model.request.payment.details;

public enum Frequency {
    W, //Weekly
    F, //Fortnightly
    M, //Monthly
    Q, //Quarterly
    H, //Half yearly
    A  //Annually
    ;

    public static Frequency fromCode(final String code) {
        switch (code) {
            case "weekly" : return W;
            case "fortnightly" : return F;
            case "monthly" : return M;
            case "quarterly" : return Q;
            case "halfyearly" : return H;
            case "annually" : return A;
            default: throw new IllegalArgumentException("Frequency code unknown " + code);
        }
    }
}
