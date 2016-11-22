package com.ctm.web.car.quote.model.response;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder(value = "name, abn, acn, afslicenceNo, afslicencenoStr")
public class Underwriter {

    private String name;

    private String abn;

    private String acn;

    private String afsLicenceNo;

    private String afsLicenceNoStr;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getABN() {
        return abn;
    }

    public void setABN(String ABN) {
        this.abn = ABN;
    }

    public String getACN() {
        return acn;
    }

    public void setACN(String ACN) {
        this.acn = ACN;
    }

    public String getAFSLicenceNo() {
        return afsLicenceNo;
    }

    public void setAFSLicenceNo(String AFSLicenceNo) {
        this.afsLicenceNo = AFSLicenceNo;
    }

    public String getAFSLicenceNoStr() {
        return afsLicenceNoStr;
    }

    public void setAFSLicenceNoStr(String AFSLicenceNoStr) {
        this.afsLicenceNo = AFSLicenceNoStr;
    }
}
