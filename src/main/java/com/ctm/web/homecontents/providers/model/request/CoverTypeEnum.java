package com.ctm.web.homecontents.providers.model.request;

public enum CoverTypeEnum {

    HOME_CONTENTS("Home & Contents Cover"),
    CONTENTS("Contents Cover Only"),
    HOME("Home Cover Only");

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
