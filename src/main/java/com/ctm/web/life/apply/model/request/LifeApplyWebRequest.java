package com.ctm.web.life.apply.model.request;

import com.ctm.web.core.model.formData.RequestImpl;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;

@JsonIgnoreProperties(ignoreUnknown = true)
public class LifeApplyWebRequest extends RequestImpl {

    @NotNull
    private Long transactionId;
    private LifeApplyRequest request;

    @NotNull
    @Valid
    private Client client;
    private LifeApplyPartner partner;
    private String vertical;

    @NotNull
    private String company;
    private String partnerBrand;
    private Lead lead;

    public LifeApplyWebRequest() {}

    public void setRequest(LifeApplyRequest request) {
        this.request = request;
    }

    public void setClient(Client client) {
        this.client = client;
    }

    public void setPartner(LifeApplyPartner partner) {
        this.partner = partner;
    }


    public void setVertical(String vertical) {
        this.vertical = vertical;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public void setPartnerBrand(String partnerBrand) {
        this.partnerBrand = partnerBrand;
    }

    public void setLead(Lead lead) {
        this.lead = lead;
    }

    public Lead getLead() {
        return lead;
    }

    public String getCompany() {
        return company;
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    @Override
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public LifeApplyRequest getRequest() {
        return request;
    }

    public Client getClient() {
        return client;
    }

    public LifeApplyPartner getPartner() {
        return partner;
    }

    public String getVertical() {
        return vertical;
    }

    public String getPartnerBrand() {
        return partnerBrand;
    }

    public String getRequestType() {
        return getRequest() != null ? getRequest().getType() : null;
    }

    public String getLeadNumber() {
        return getLead() != null ? getLead().getNumber() : null;
    }
}
