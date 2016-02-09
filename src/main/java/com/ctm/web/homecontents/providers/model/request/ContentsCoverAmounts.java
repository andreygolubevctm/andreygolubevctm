package com.ctm.web.homecontents.providers.model.request;

import java.math.BigDecimal;

public class ContentsCoverAmounts {

    private BigDecimal replaceContentsCost;

    private boolean contentsAbovePolicyLimits;

    private PersonalEffects personalEffects;

    public BigDecimal getReplaceContentsCost() {
        return replaceContentsCost;
    }

    public void setReplaceContentsCost(BigDecimal replaceContentsCost) {
        this.replaceContentsCost = replaceContentsCost;
    }

    public boolean isContentsAbovePolicyLimits() {
        return contentsAbovePolicyLimits;
    }

    public void setContentsAbovePolicyLimits(boolean contentsAbovePolicyLimits) {
        this.contentsAbovePolicyLimits = contentsAbovePolicyLimits;
    }

    public PersonalEffects getPersonalEffects() {
        return personalEffects;
    }

    public void setPersonalEffects(PersonalEffects personalEffects) {
        this.personalEffects = personalEffects;
    }
}
