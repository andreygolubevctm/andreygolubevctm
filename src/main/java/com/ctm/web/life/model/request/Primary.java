package com.ctm.web.life.model.request;


import com.ctm.life.model.request.State;

public class Primary extends LifePerson {

    private State state;
    private String postCode;
    private PrimaryInsurance insurance;

    private Primary() {
        super();
    }

    private Primary(Primary.Builder builder) {
        super(builder);
        state = builder.state;
        postCode = builder.postCode;
        insurance = builder.insurance;
    }

    public State getState() {
        return state;
    }

    public String getPostCode() {
        return postCode;
    }


    @Override
    public PrimaryInsurance getInsurance() {
        return insurance;
    }


    public static final class Builder extends LifePerson.Builder<Primary.Builder> {
        private PrimaryInsurance insurance;
        private State state;
        private String postCode;

        public Builder() {
        }

        public  Builder insurance(PrimaryInsurance val) {
            insurance = val;
            return this;
        }

        public Builder state(State val) {
            state = val;
            return this;
        }

        public Builder postCode(String val) {
            postCode = val;
            return this;
        }

        public Primary build() {
            return new Primary(this);
        }
    }
}
