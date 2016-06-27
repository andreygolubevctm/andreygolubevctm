package com.ctm.web.homecontents.providers.model.request;

import org.apache.commons.lang3.StringUtils;

import static java.util.Arrays.asList;

public enum CoverTypeEnum {

    HOME_CONTENTS("Home & Contents Cover", "HC"),
    CONTENTS("Contents Cover Only", "C"),
    HOME("Home Cover Only", "H");

    private String description;
    private String code;

    CoverTypeEnum(String description , String code) {
        this.description = description;
        this.code = code;
    }

    public static CoverTypeEnum fromDescription(String description) {
        for (CoverTypeEnum e : values()) {
            if (e.description.equals(description)) {
                return e;
            }
        }
        return null;
    }

    public static CoverTypeEnum fromCode(String code) {
        return asList(values()).stream()
                .filter(v -> StringUtils.equals(v.getCode(), code))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Undefined CoverTypeEnum code " + code));
    }



    public String getCode() {
        return code;
    }
}
