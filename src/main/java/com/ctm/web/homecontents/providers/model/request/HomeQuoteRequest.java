package com.ctm.web.homecontents.providers.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

public class HomeQuoteRequest {

    private String clientIp;
    private boolean homeCover;
    private boolean contentsCover;
    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate startDate;
    private Integer homeExcess;
    private Integer homeBaseExcess;
    private Integer contentsExcess;
    private Integer contentsBaseExcess;
    private Occupancy occupancy;
    private BusinessActivity businessActivity;
    private Property property;
    private HomeCoverAmounts homeCoverAmounts;
    private ContentsCoverAmounts contentsCoverAmounts;
    private PolicyHolder mainPolicyHolder;
    private PolicyHolder jointPolicyHolder;
    private Contact contact;
    private boolean hadClaims;
    private Boolean underFinance;
    private Boolean retiredResident;
    private LandlordDetails landlordDetails;

    public String getClientIp() {
        return clientIp;
    }

    public LandlordDetails getLandlordDetails() {
        return landlordDetails;
    }

    public void setLandlordDetails(LandlordDetails landlordDetails) {
        this.landlordDetails = landlordDetails;
    }

    public HomeQuoteRequest setClientIp(String clientIp) {
        this.clientIp = clientIp;
        return this;
    }

    public boolean isHomeCover() {
        return homeCover;
    }

    public void setHomeCover(boolean homeCover) {
        this.homeCover = homeCover;
    }

    public boolean isContentsCover() {
        return contentsCover;
    }

    public void setContentsCover(boolean contentsCover) {
        this.contentsCover = contentsCover;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public Integer getHomeExcess() {
        return homeExcess;
    }

    public void setHomeExcess(Integer homeExcess) {
        this.homeExcess = homeExcess;
    }

    public Integer getHomeBaseExcess() {
        return homeBaseExcess;
    }

    public void setHomeBaseExcess(Integer homeBaseExcess) {
        this.homeBaseExcess = homeBaseExcess;
    }

    public Integer getContentsExcess() {
        return contentsExcess;
    }

    public void setContentsExcess(Integer contentsExcess) {
        this.contentsExcess = contentsExcess;
    }

    public Integer getContentsBaseExcess() {
        return contentsBaseExcess;
    }

    public void setContentsBaseExcess(Integer contentsBaseExcess) {
        this.contentsBaseExcess = contentsBaseExcess;
    }

    public Occupancy getOccupancy() {
        return occupancy;
    }

    public void setOccupancy(Occupancy occupancy) {
        this.occupancy = occupancy;
    }

    public BusinessActivity getBusinessActivity() {
        return businessActivity;
    }

    public void setBusinessActivity(BusinessActivity businessActivity) {
        this.businessActivity = businessActivity;
    }

    public Property getProperty() {
        return property;
    }

    public void setProperty(Property property) {
        this.property = property;
    }

    public HomeCoverAmounts getHomeCoverAmounts() {
        return homeCoverAmounts;
    }

    public void setHomeCoverAmounts(HomeCoverAmounts homeCoverAmounts) {
        this.homeCoverAmounts = homeCoverAmounts;
    }

    public ContentsCoverAmounts getContentsCoverAmounts() {
        return contentsCoverAmounts;
    }

    public void setContentsCoverAmounts(ContentsCoverAmounts contentsCoverAmounts) {
        this.contentsCoverAmounts = contentsCoverAmounts;
    }

    public PolicyHolder getMainPolicyHolder() {
        return mainPolicyHolder;
    }

    public void setMainPolicyHolder(PolicyHolder mainPolicyHolder) {
        this.mainPolicyHolder = mainPolicyHolder;
    }

    public PolicyHolder getJointPolicyHolder() {
        return jointPolicyHolder;
    }

    public void setJointPolicyHolder(PolicyHolder jointPolicyHolder) {
        this.jointPolicyHolder = jointPolicyHolder;
    }

    public Contact getContact() {
        return contact;
    }

    public void setContact(Contact contact) {
        this.contact = contact;
    }

    public boolean isHadClaims() {
        return hadClaims;
    }

    public void setHadClaims(boolean hadClaims) {
        this.hadClaims = hadClaims;
    }

    public Boolean isUnderFinance() {
        return underFinance;
    }

    public void setUnderFinance(Boolean underFinance) {
        this.underFinance = underFinance;
    }

    public Boolean getRetiredResident() {
        return retiredResident;
    }

    public void setRetiredResident(final Boolean retiredResident) {
        this.retiredResident = retiredResident;
    }

}
