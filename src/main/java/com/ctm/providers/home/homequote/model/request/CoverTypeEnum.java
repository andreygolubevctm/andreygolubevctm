package com.ctm.providers.home.homequote.model.request;

public enum CoverTypeEnum {

    HOME_CONTENTS("HC"),
    CONTENTS("C"),
    HOME("H");

    private String code;

    private CoverTypeEnum(String code) {
        this.code = code;
    }

    public static CoverTypeEnum fromCode(String code) {
        for (CoverTypeEnum e : values()) {
            if (code.equals(e.code)) {
                return e;
            }
        }
        return null;
    }

    public String getCode() {
        return code;
    }
}
