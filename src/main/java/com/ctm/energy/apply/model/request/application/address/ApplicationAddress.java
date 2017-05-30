package com.ctm.energy.apply.model.request.application.address;

import java.util.Optional;

public class ApplicationAddress {

    private AddressDetails supplyAddressDetails;

    private AddressDetails postalAddressDetails;
    private Boolean postalMatch;

    @SuppressWarnings("unused")
    // used by jackson
    private ApplicationAddress(){
    }

    private ApplicationAddress(Builder builder) {
        supplyAddressDetails = builder.supplyAddressDetails;
        postalAddressDetails = builder.postalAddressDetails;
        postalMatch = builder.postalMatch;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public AddressDetails getSupplyAddressDetails() {
        return supplyAddressDetails;
    }

    public Optional<AddressDetails> getPostalAddressDetails() {
        return Optional.ofNullable(postalAddressDetails);
    }

    public Boolean getPostalMatch() {
        return postalMatch;
    }


    public static final class Builder {
        private AddressDetails supplyAddressDetails;
        private AddressDetails postalAddressDetails;
        private Boolean postalMatch;

        private Builder() {
        }

        public Builder supplyAddressDetails(AddressDetails val) {
            supplyAddressDetails = val;
            return this;
        }

        public Builder postalAddressDetails(Optional<AddressDetails> val) {
            postalAddressDetails = val.orElse(null);
            return this;
        }

        public Builder postalMatch(Boolean val) {
            postalMatch = val;
            return this;
        }

        public ApplicationAddress build() {
            return new ApplicationAddress(this);
        }
    }
}



