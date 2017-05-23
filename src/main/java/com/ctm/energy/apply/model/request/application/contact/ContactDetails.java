package com.ctm.energy.apply.model.request.application.contact;

import javax.validation.constraints.NotNull;

public class ContactDetails {

    private String mobileNumber;
    private String otherPhoneNumber;
    @NotNull
    private String email;

    private ContactDetails(){
    }

    private ContactDetails(Builder builder) {
        mobileNumber = builder.mobileNumber;
        otherPhoneNumber = builder.otherPhoneNumber;
        email = builder.email;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public String getOtherPhoneNumber() {
        return otherPhoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public static final class Builder {
        private String mobileNumber;
        private String otherPhoneNumber;
        private String email;

        private Builder() {
        }

        public Builder mobileNumber(String val) {
            mobileNumber = val;
            return this;
        }

        public Builder otherPhoneNumber(String val) {
            otherPhoneNumber = val;
            return this;
        }

        public Builder email(String val) {
            email = val;
            return this;
        }

        public ContactDetails build() {
            return new ContactDetails(this);
        }
    }
}
