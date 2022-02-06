package com.ctm.web.simples.admin.model;

public enum UserEditableTextType {
    HELP_BOX("helpBox", "Help Box"),
    RATE_RISE_MESSAGE("rateRiseBanner", "Rate Rise Label"),
    RATE_RISE_MESSAGE_SIDE_BAR("rateRiseBannerSideBar", "Rate Rise Label for Side Bar");
  
    private String type;
    private String description;

    UserEditableTextType(String type, String description) {
        this.type = type;
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public String getDescription() {
        return description;
    }

    public static UserEditableTextType getEnum(String type) {
        UserEditableTextType[] enums = UserEditableTextType.values();
        if (enums != null && enums.length > 0) {
            for (int i = 0; i < enums.length; i++) {
                if (enums[i].getType().equalsIgnoreCase(type)) {
                    return enums[i];
                }
            }
        }
        return null;
    }

}
