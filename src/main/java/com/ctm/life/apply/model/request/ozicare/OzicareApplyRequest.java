package com.ctm.life.apply.model.request.ozicare;

import com.ctm.life.model.request.State;
import com.fasterxml.jackson.annotation.JsonInclude;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class OzicareApplyRequest {

    public static final String PATH = "/ozicare";

    private String firstName;
    private String lastName;
    private String phoneNumber;
    private State state;

    // leadNumber maps to ClientNumber in the ozicare webservice
    private String leadNumber;

    @SuppressWarnings("UnusedDeclaration")
    private OzicareApplyRequest() {
    }

    private OzicareApplyRequest(Builder builder) {
        firstName = builder.firstName;
        lastName = builder.lastName;
        phoneNumber = builder.phoneNumber;
        state = builder.state;
        leadNumber = builder.leadNumber;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public State getState() {
        return state;
    }

    public String getLeadNumber() {
        return leadNumber;
    }


    public static final class Builder {
        private String firstName;
        private String lastName;
        private String phoneNumber;
        private State state;
        private String leadNumber;

        public Builder() {
        }

        public Builder firstName(String val) {
            firstName = val;
            return this;
        }

        public Builder lastName(String val) {
            lastName = val;
            return this;
        }

        public Builder phoneNumber(String val) {
            phoneNumber = val;
            return this;
        }

        public Builder state(State val) {
            state = val;
            return this;
        }

        public Builder leadNumber(String val) {
            leadNumber = val;
            return this;
        }

        public OzicareApplyRequest build() {
            return new OzicareApplyRequest(this);
        }
    }
}
