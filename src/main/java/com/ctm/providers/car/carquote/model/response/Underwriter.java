package com.ctm.providers.car.carquote.model.response;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder(value = "name, abn, acn, afslicenceNo")
public class Underwriter {

    private String name;

    private String abn;

    private String acn;

    private String afsLicenceNo;

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
}
