package com.ctm.web.samesite.model;

/** Bank Information read from the Westpac payment gateway POST */
public class BankInfo {
    private String action;
    private String cd_source;
    private String cd_community;
    private String cd_supplier_business;
    private String nm_card_holder;
    private String nm_account_alias;
    private String nm_account;
    private String dt_expiry;
    private String cd_prerego;
    private String nm_card_scheme;
    private String fl_success;
    private String cd_summary;
    private String tx_response;
    private String CP_userID;
    private String CP_brandID;
    private String CP_ahm_custom1;
    private String CP_ahm_custom2;
    private String CP_ahm_custom3;
    private String CP_ahm_custom4;
    private String CP_ahm_custom5;
    private String CP_no_reference;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getCd_source() {
        return cd_source;
    }

    public void setCd_source(String cd_source) {
        this.cd_source = cd_source;
    }

    public String getCd_community() {
        return cd_community;
    }

    public void setCd_community(String cd_community) {
        this.cd_community = cd_community;
    }

    public String getCd_supplier_business() {
        return cd_supplier_business;
    }

    public void setCd_supplier_business(String cd_supplier_business) {
        this.cd_supplier_business = cd_supplier_business;
    }

    public String getNm_card_holder() {
        return nm_card_holder;
    }

    public void setNm_card_holder(String nm_card_holder) {
        this.nm_card_holder = nm_card_holder;
    }

    public String getNm_account_alias() {
        return nm_account_alias;
    }

    public void setNm_account_alias(String nm_account_alias) {
        this.nm_account_alias = nm_account_alias;
    }

    public String getNm_account() {
        return nm_account;
    }

    public void setNm_account(String nm_account) {
        this.nm_account = nm_account;
    }

    public String getDt_expiry() {
        return dt_expiry;
    }

    public void setDt_expiry(String dt_expiry) {
        this.dt_expiry = dt_expiry;
    }

    public String getCd_prerego() {
        return cd_prerego;
    }

    public void setCd_prerego(String cd_prerego) {
        this.cd_prerego = cd_prerego;
    }

    public String getNm_card_scheme() {
        return nm_card_scheme;
    }

    public void setNm_card_scheme(String nm_card_scheme) {
        this.nm_card_scheme = nm_card_scheme;
    }

    public String getFl_success() {
        return fl_success;
    }

    public void setFl_success(String fl_success) {
        this.fl_success = fl_success;
    }

    public String getCd_summary() {
        return cd_summary;
    }

    public void setCd_summary(String cd_summary) {
        this.cd_summary = cd_summary;
    }

    public String getTx_response() {
        return tx_response;
    }

    public void setTx_response(String tx_response) {
        this.tx_response = tx_response;
    }

    public String getCP_userID() {
        return CP_userID;
    }

    public void setCP_userID(String CP_userID) {
        this.CP_userID = CP_userID;
    }

    public String getCP_brandID() {
        return CP_brandID;
    }

    public void setCP_brandID(String CP_brandID) {
        this.CP_brandID = CP_brandID;
    }

    public String getCP_ahm_custom1() {
        return CP_ahm_custom1;
    }

    public void setCP_ahm_custom1(String CP_ahm_custom1) {
        this.CP_ahm_custom1 = CP_ahm_custom1;
    }

    public String getCP_ahm_custom2() {
        return CP_ahm_custom2;
    }

    public void setCP_ahm_custom2(String CP_ahm_custom2) {
        this.CP_ahm_custom2 = CP_ahm_custom2;
    }

    public String getCP_ahm_custom3() {
        return CP_ahm_custom3;
    }

    public void setCP_ahm_custom3(String CP_ahm_custom3) {
        this.CP_ahm_custom3 = CP_ahm_custom3;
    }

    public String getCP_ahm_custom4() {
        return CP_ahm_custom4;
    }

    public void setCP_ahm_custom4(String CP_ahm_custom4) {
        this.CP_ahm_custom4 = CP_ahm_custom4;
    }

    public String getCP_ahm_custom5() {
        return CP_ahm_custom5;
    }

    public void setCP_ahm_custom5(String CP_ahm_custom5) {
        this.CP_ahm_custom5 = CP_ahm_custom5;
    }

    public String getCP_no_reference() {
        return CP_no_reference;
    }

    public void setCP_no_reference(String CP_no_reference) {
        this.CP_no_reference = CP_no_reference;
    }
}