package com.ctm.web.health.apply.model.request.fundData.membership.eligibility;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonValue;

public enum NhbEligibilityReasonID {

    Current("CS", "Currently Serving"),
    ExServing("ES", "Ex-Serving"),
    Contractor("CO", "Contractor"),
    Reservist("CR", "Current Reservist"),
    Former("FO", "Former"),
    Family("F", "Family of"),
    OTHER("O", "Other"),
    ContractorFamily("CF", "Contractor – Family of"),
    DeptofDefense("DOD", "Dept of Defense");


    @JsonIgnore
    private final String code;

    @JsonIgnore
    private final String description;

    NhbEligibilityReasonID(final String code, final String description) {
        this.code = code;
        this.description = description;
    }

    @JsonValue
    public String getName() {
        return name();
    }

    @JsonCreator
    public static NhbEligibilityReasonID findByCode(final String code) {
        if(code == null) {
            return OTHER;
        }
        for (final NhbEligibilityReasonID t : NhbEligibilityReasonID.values()) {
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

    public static NhbEligibilityReasonID fromValue(final String v) {
        return findByCode(v);
    }
}
