package com.ctm.web.homecontents.model.results;

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

    public String getAbn() {
        return abn;
    }

    public void setAbn(String abn) {
        this.abn = abn;
    }

    public String getAcn() {
        return acn;
    }

    public void setAcn(String acn) {
        this.acn = acn;
    }

    public String getAfsLicenceNo() {
        return afsLicenceNo;
    }

    public void setAfsLicenceNo(String afsLicenceNo) {
        this.afsLicenceNo = afsLicenceNo;
        setAfsLicenceNoStr(afsLicenceNo);
    }

    public String getAfsLicenceNoStr() {
        return afsLicenceNoStr;
    }

    public void setAfsLicenceNoStr(String afsLicenceNo) {
        this.afsLicenceNoStr = "AFS Licence No: " + afsLicenceNo;
    }
}
