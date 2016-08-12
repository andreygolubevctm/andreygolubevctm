package com.ctm.web.health.apply.v2.model.request.application.common;

import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;

public enum Relationship {
    Baby,
    Dtr,   //Daughter
    FDtr,  //Foster Daughter
    Fson,  // = Foster Son
    Membr, // = Member person is always Membr
    Other, // = Other (adult) dependant
    Ptnr,  // Partner
    Son,
    Sps,  // Spouse
    NONE;

    public static Relationship fromCode(String code) {
        return Arrays.stream(values()).filter(v -> StringUtils.equalsIgnoreCase(v.name(), code))
                .findFirst().orElse(NONE);

    }

}
