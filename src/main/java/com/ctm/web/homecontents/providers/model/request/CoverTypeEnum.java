package com.ctm.web.homecontents.providers.model.request;

public enum CoverTypeEnum {

    HOME_CONTENTS("Home & Contents Cover"),
    CONTENTS("Contents Cover Only"),
    HOME("Home Cover Only");

    private String code;

    CoverTypeEnum(String code) {
        this.code = code;
    }

    public static CoverTypeEnum fromCode(String code) {
        for (CoverTypeEnum e : values()) {
            if (e.code.equals(code)) {
                return e;
            }
        }
        return null;
    }

    public String getCode() {
        return code;
    }
}
