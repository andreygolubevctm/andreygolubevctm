package com.ctm.energy.apply.model.request.relocation;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDate;

public class RelocationDetails {
    private boolean movingIn;
    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd")
    private LocalDate movingDate;

    private RelocationDetails(Builder builder) {
        movingIn = builder.movingIn;
        movingDate = builder.movingDate;
    }

    private RelocationDetails(){
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public boolean getMovingIn() {
        return movingIn;
    }

    public LocalDate getMovingDate() {
        return movingDate;
    }


    public static final class Builder {
        private Boolean movingIn;
        private LocalDate movingDate;

        private Builder() {
        }

        public Builder movingIn(boolean val) {
            movingIn = val;
            return this;
        }

        public Builder movingDate(LocalDate val) {
            movingDate = val;
            return this;
        }

        public RelocationDetails build() {
            return new RelocationDetails(this);
        }
    }
}
