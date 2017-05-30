package com.ctm.life.occupation.model.response;

public class Occupation {

    private String code;

    private String description;

    private Integer groupId;

    private Occupation() {}

    private Occupation(Builder builder) {
        code = builder.code;
        description = builder.description;
        groupId = builder.groupId;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    public Integer getGroupId() {
        return groupId;
    }


    public static final class Builder {
        private String code;
        private String description;
        private Integer groupId;

        public Builder code(String val) {
            code = val;
            return this;
        }

        public Builder description(String val) {
            description = val;
            return this;
        }

        public Builder groupId(Integer val) {
            groupId = val;
            return this;
        }

        public Occupation build() {
            return new Occupation(this);
        }
    }
}
