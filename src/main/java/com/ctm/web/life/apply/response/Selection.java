package com.ctm.web.life.apply.response;

public class Selection {
    private final SelectDetails partner;
    private final SelectDetails client;

    private Selection(Builder builder) {
        partner = builder.partner;
        client = builder.client;
    }

    public SelectDetails getPartner() {
        return partner;
    }

    public SelectDetails getClient() {
        return client;
    }


    public static final class Builder {
        private SelectDetails partner;
        private SelectDetails client;

        public Builder() {
        }

        public Builder partner(SelectDetails val) {
            partner = val;
            return this;
        }

        public Builder client(SelectDetails val) {
            client = val;
            return this;
        }

        public Selection build() {
            return new Selection(this);
        }
    }
}
