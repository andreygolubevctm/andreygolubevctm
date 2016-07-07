package com.ctm.web.life.apply.response;

public class SelectDetails {
    final String pds;
    final String info_url; //NOPMD

    private SelectDetails(Builder builder) {
        pds = builder.pds;
        info_url = builder.infoUrl;
    }

    public String getPds() {
        return pds;
    }

    @SuppressWarnings("PMD.MethodNamingConventions") // maps to front end
    public String getInfo_url() {
        return info_url;
    }


    public static final class Builder {
        private String pds;
        private String infoUrl;

        public Builder() {
        }

        public Builder pds(String val) {
            pds = val;
            return this;
        }

        public Builder infoUrl(String val) {
            infoUrl = val;
            return this;
        }

        public SelectDetails build() {
            return new SelectDetails(this);
        }
    }
}
