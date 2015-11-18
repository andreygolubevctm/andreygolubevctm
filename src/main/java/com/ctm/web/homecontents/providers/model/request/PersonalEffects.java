package com.ctm.web.homecontents.providers.model.request;

import java.math.BigDecimal;

public class PersonalEffects {

    private BigDecimal unspecifiedTotalCover;

    private SpecifiedPersonalEffect specifiedPersonalEffects;

    public BigDecimal getUnspecifiedTotalCover() {
        return unspecifiedTotalCover;
    }

    public void setUnspecifiedTotalCover(BigDecimal unspecifiedTotalCover) {
        this.unspecifiedTotalCover = unspecifiedTotalCover;
    }

    public SpecifiedPersonalEffect getSpecifiedPersonalEffects() {
        return specifiedPersonalEffects;
    }

    public void setSpecifiedPersonalEffects(SpecifiedPersonalEffect specifiedPersonalEffects) {
        this.specifiedPersonalEffects = specifiedPersonalEffects;
    }
}
