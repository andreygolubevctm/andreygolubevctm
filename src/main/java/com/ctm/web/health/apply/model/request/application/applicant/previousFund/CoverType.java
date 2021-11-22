package com.ctm.web.health.apply.model.request.application.applicant.previousFund;

import com.ctm.web.health.model.form.Cover;
import com.fasterxml.jackson.annotation.JsonValue;

public enum CoverType {
    COMBINED("C"),  // Hospital + Extras
    HOSPITAL("H"),  // Hospital Only
    EXTRAS("E");    // Extras Only


    private final String code;

    CoverType(final String code) { this.code = code; }

    @Override
    public String toString() {
        return this.name();
    }



    /**
     * Get a CoverType enum value from a given code in string format
     * @param code The code of the value, i.e "C" or "H"
     * @return The matching enum value, or null if no matching name is found
     */
    public static CoverType fromCode(final String code) {
        // Loop through each value
        for(final CoverType opt : CoverType.values()) {
            if(code.equals(opt.code)) {   // If the given code matches the option code
                return opt; // return the option enum
            }
        }

        // If no match is found, return null
        return null;
    }


    /**
     * Get a CoverType enum value derived from the given healthEverHeld string (Y/N)
     * @param healthEverHeld Whether the person has held hospital cover, from the xpath `health/healthCover/{person}/healthEverHeld`
     * @return The 'H' enum value if `healthEverHeld` is 'Y', null if 'N'
     */
    public static CoverType fromHealthEverHeld(final String healthEverHeld) {
        // If the user answered yes to "Have you ever held Hospital Cover?"
        if(healthEverHeld.equals("Y")) {
            return CoverType.HOSPITAL;  // Return the HOSPITAL/"H" enum
        }

        // If the user answered No then return null
        return null;
    }
}
