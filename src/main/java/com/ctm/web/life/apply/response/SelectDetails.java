package com.ctm.web.life.apply.response;

public class SelectDetails {
    String pds;
    String info_url;

    private SelectDetails(Builder builder) {
        pds = builder.pds;
        info_url = builder.info_url;
    }

    public String getPds() {
        return pds;
    }

    public String getInfo_url() {
        return info_url;
    }


    public static final class Builder {
        private String pds;
        private String info_url;

        public Builder() {
        }

        public Builder pds(String val) {
            pds = val;
            return this;
        }

        public Builder info_url(String val) {
            info_url = val;
            return this;
        }

        public SelectDetails build() {
            return new SelectDetails(this);
        }
    }
}
