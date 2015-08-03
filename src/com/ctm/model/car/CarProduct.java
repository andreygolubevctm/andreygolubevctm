package com.ctm.model.car;

import com.fasterxml.jackson.annotation.JsonView;

public class CarProduct {

    @JsonView(Views.MoreInfoView.class) private String inclusions;

    @JsonView(Views.MoreInfoView.class) private String benefits;

    @JsonView(Views.MoreInfoView.class) private String optionalExtras;

    public String getInclusions() {
        return inclusions;
    }

    public void setInclusions(String inclusions) {
        this.inclusions = inclusions;
    }

    public String getBenefits() {
        return benefits;
    }

    public void setBenefits(String benefits) {
        this.benefits = benefits;
    }

    public String getOptionalExtras() {
        return optionalExtras;
    }

    public void setOptionalExtras(String optionalExtras) {
        this.optionalExtras = optionalExtras;
    }
}
