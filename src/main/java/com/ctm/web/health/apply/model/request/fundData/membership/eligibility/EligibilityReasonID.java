package com.ctm.web.health.apply.model.request.fundData.membership.eligibility;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonValue;

public enum EligibilityReasonID {

    Current("CS", "Currently Serving"),
    ExServing("ES", "Ex-Serving"),
    Contractor("003", "Contractor"),
    Reservist("CR", "Current Reservist"),
    Former("FO", "Former"),
    Family("F", "Family of"),
    OTHER("007", "Other"),
    ContractorFamily("CO", "Contractor – Family of"),
    DeptofDefense("009", "Dept of Defense");


    @JsonIgnore
    private final String code;

    @JsonIgnore
    private final String description;

    EligibilityReasonID(final String code, final String description) {
        this.code = code;
        this.description = description;
    }

    @JsonValue
    public String getName() {
        return name();
    }

    @JsonCreator
    public static EligibilityReasonID findByCode(final String code) {
        if(code == null) {
            return OTHER;
        }
        for (final EligibilityReasonID t : EligibilityReasonID.values()) {
            if (code.equalsIgnoreCase(t.getCode())) {
                return t;
            }
        }
        return OTHER;
    }

    @JsonIgnore
    public String getCode() {
        return code;
    }

    @JsonIgnore
    public String getDescription() {
        return description;
    }

    public static EligibilityReasonID fromValue(final String v) {
        return findByCode(v);
    }
}
