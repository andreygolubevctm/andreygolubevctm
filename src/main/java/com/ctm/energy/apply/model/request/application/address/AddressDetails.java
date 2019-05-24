package com.ctm.energy.apply.model.request.application.address;

public class AddressDetails {

    private String streetNumber;

    private String addressType;

    private String lastSearch;

    private String fullAddress;

    private String dpId;

    private String unitType;

    private String unitNumber;

    private String streetName;

    private String suburbName;

    private String postcode;

    private State state;

    private AddressDetails(){
    }

    private AddressDetails(Builder builder) {
        streetNumber = builder.streetNumber;
        addressType = builder.addressType;
        lastSearch = builder.lastSearch;
        fullAddress = builder.fullAddress;
        dpId = builder.dpId;
        unitType = builder.unitType;
        unitNumber = builder.unitNumber;
        streetName = builder.streetName;
        suburbName = builder.suburbName;
        postcode = builder.postcode;
        state = builder.state;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public String getStreetNumber() {
        return streetNumber;
    }

    public String getAddressType() {
        return addressType;
    }


    public String getLastSearch() {
        return lastSearch;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public String getDpId() {
        return dpId;
    }

    public String getUnitType() {
        return unitType;
    }

    public String getUnitNumber() {
        return unitNumber;
    }

    public String getStreetName() {
        return streetName;
    }

    public String getSuburbName() {
        return suburbName;
    }

    public String getPostcode() {
        return postcode;
    }

    public State getState() {
        return state;
    }

    public static final class Builder {
        private String streetNumber;
        private String addressType;
        private String lastSearch;
        private String fullAddress;
        private String dpId;
        private String unitType;
        private String unitNumber;
        private String streetName;
        private String suburbName;
        private String postcode;
        private State state;

        private Builder() {
        }

        public Builder streetNumber(String val) {
            streetNumber = val;
            return this;
        }

        public Builder addressType(String val) {
            addressType = val;
            return this;
        }

        public Builder lastSearch(String val) {
            lastSearch = val;
            return this;
        }

        public Builder fullAddress(String val) {
            fullAddress = val;
            return this;
        }

        public Builder dpId(String val) {
            dpId = val;
            return this;
        }

        public Builder unitType(String val) {
            unitType = val;
            return this;
        }

        public Builder unitNumber(String val) {
            unitNumber = val;
            return this;
        }

        public Builder streetName(String val) {
            streetName = val;
            return this;
        }

        public Builder suburbName(String val) {
            suburbName = val;
            return this;
        }

        public Builder postcode(String val) {
            postcode = val;
            return this;
        }

        public Builder state(State val) {
            state = val;
            return this;
        }

        public AddressDetails build() {
            return new AddressDetails(this);
        }
    }
}



