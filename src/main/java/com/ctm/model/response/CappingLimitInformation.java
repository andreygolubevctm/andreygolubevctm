package com.ctm.model.response;


import com.ctm.web.health.model.request.CappingLimit;

/**
 * Extends the capping limit model that is used by CappingLimitsDao
 * with additional fields such as provider name current join count and is current
 */
public class CappingLimitInformation extends CappingLimit {
    private String providerName;
    private int currentJoinCount;
    private boolean isCurrent;

    /** used by the js **/
    public String getCappingLimitsKey() {
        return getProviderId()  + "#" + getSequenceNo() + "#" + getLimitType();
    }

    public String getProviderName() {
        return providerName;
    }

    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }

    public int getCurrentJoinCount() {
        return currentJoinCount;
    }

    public void setCurrentJoinCount(int currentJoinCount) {
        this.currentJoinCount = currentJoinCount;
    }

    public boolean isCurrent() {
        return isCurrent;
    }

    public void setIsCurrent(boolean isCurrent) {
        this.isCurrent = isCurrent;
    }
}
