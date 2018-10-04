package com.ctm.web.core.leadService.model;

public enum  LeadType {

    CROSS_SELL("CrossSell"),
    CALL_DIRECT("CallDirect"),
    CALL_ME_NOW("CallMeNow"),
    CALL_ME_BACK("CallMeBack"),
    GET_CALLBACK("GetaCall"),
    NOSALE_CALL("NoSaleCall"),
    ONLINE_HANDOVER("onlineHandover"),
    MORE_INFO("moreInfo"),
    BEST_PRICE("bestPrice");

    private String leadType;

    LeadType(String leadType) {
        this.leadType = leadType;
    }

    public String getLeadType() {
        return leadType;
    }

    public Boolean equals(String calltype) {
        return this.leadType.equals(calltype);
    }
}
