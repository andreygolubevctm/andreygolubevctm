package com.ctm.web.homecontents.providers.model.request;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;
import java.util.List;

import static java.util.Collections.emptyList;

public class HomeQuoteRequest {

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

    private PolicyHolder oldestPolicyHolder;

    private Contact contact;

    private boolean previouslyCovered;

    private PreviousCover previousCover;

    private boolean hadClaims;

    public List<String> providerFilter = emptyList();

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

    public PolicyHolder getOldestPolicyHolder() {
        return oldestPolicyHolder;
    }

    public void setOldestPolicyHolder(PolicyHolder oldestPolicyHolder) {
        this.oldestPolicyHolder = oldestPolicyHolder;
    }

    public Contact getContact() {
        return contact;
    }

    public void setContact(Contact contact) {
        this.contact = contact;
    }

    public boolean isPreviouslyCovered() {
        return previouslyCovered;
    }

    public void setPreviouslyCovered(boolean previouslyCovered) {
        this.previouslyCovered = previouslyCovered;
    }

    public PreviousCover getPreviousCover() {
        return previousCover;
    }

    public void setPreviousCover(PreviousCover previousCover) {
        this.previousCover = previousCover;
    }

    public boolean isHadClaims() {
        return hadClaims;
    }

    public void setHadClaims(boolean hadClaims) {
        this.hadClaims = hadClaims;
    }

    public List<String> getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(List<String> providerFilter) {
        this.providerFilter = providerFilter;
    }
}
