package com.ctm.web.health.model.form;

public class Fund {

    private String fundName;

    private String memberID;

    private String authority;

    private String abdPolicyStart;

    private String abd;

    // Xpath = "/health/previousFund/{person}/fundCancellationType"
    private String fundCancellationType;

    public String getFundName() {
        return fundName;
    }

    public void setFundName(String fundName) {
        this.fundName = fundName;
    }

    public String getMemberID() {
        return memberID;
    }

    public void setMemberID(String memberID) {
        this.memberID = memberID;
    }

    public String getAuthority() {
        return authority;
    }

    public void setAuthority(String authority) {
        this.authority = authority;
    }

    public String getAbdPolicyStart() {
        return abdPolicyStart;
    }

    public void setAbdPolicyStart(String abdPolicyStart) {
        this.abdPolicyStart = abdPolicyStart;
    }

    public String getAbd() {
        return abd;
    }

    public void setAbd(String abd) {
        this.abd = abd;
    }

    public String getFundCancellationType() { return fundCancellationType; }

    public void setFundCancellationType(String fundCancellationType) { this.fundCancellationType = fundCancellationType; }
}
