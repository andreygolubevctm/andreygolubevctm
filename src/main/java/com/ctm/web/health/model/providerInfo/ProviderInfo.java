package com.ctm.web.health.model.providerInfo;


public class ProviderInfo {
    private String phoneNumber;
    private String email;
    private String website;

    private ProviderInfo(Builder builder) {
        this.phoneNumber = builder.phoneNumber;
        this.email = builder.email;
        this.website = builder.website;
    }

    public static Builder newProviderInfo() {
        return new Builder();
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }


    public String getEmail() {
        return email;
    }


    public String getWebsite() {
        return website;
    }


    public static final class Builder {
        private String phoneNumber;
        private String email;
        private String website;

        private Builder() {
        }

        public ProviderInfo build() {
            return new ProviderInfo(this);
        }

        public Builder phoneNumber(String phoneNumber) {
            this.phoneNumber = phoneNumber;
            return this;
        }

        public Builder email(String email) {
            this.email = email;
            return this;
        }

        public Builder website(String website) {
            this.website = website;
            return this;
        }
    }
}
