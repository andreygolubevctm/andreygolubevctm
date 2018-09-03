package com.ctm.web.homecontents.model.form;

import org.apache.commons.lang3.StringUtils;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class HomeQuote {

    private String contentsExcess;

    private String homeExcess;

    private String baseContentsExcess;

    private String baseHomeExcess;

    private BusinessActivity businessActivity;

    private CoverAmounts coverAmounts;

    @NotNull
    @Size(min=1)
    private String coverType;

    private Disclosures disclosures;

    private String fsg;

    private String journey_stage;

    private String lastFieldTouch;

    private Occupancy occupancy;

    private String paymentType;

    @Valid
    private PolicyHolder policyHolder;

    private String privacyoptin;

    private Property property;

    private String renderingMode;

    private String startDate;

    private String startDateInputD;

    private String startDateInputM;

    private String startDateInputY;

    private String terms;

    private String termsAccepted;

    private Filter filter;

    private String underFinance;

    private LandlordDetails landlordDetails;

    public LandlordDetails getLandlordDetails() {
        return landlordDetails;
    }

    public void setLandlordDetails(LandlordDetails landlordDetails) {
        this.landlordDetails = landlordDetails;
    }

    public HomeQuote() {
        filter = new Filter();
    }

    public String getContentsExcess() {
        return contentsExcess;
    }

    public void setContentsExcess(String contentsExcess) {
        this.contentsExcess = contentsExcess;
    }

    public String getHomeExcess() {
        return homeExcess;
    }

    public void setHomeExcess(String homeExcess) {
        this.homeExcess = homeExcess;
    }

    public String getBaseContentsExcess() {
        return baseContentsExcess;
    }

    public void setBaseContentsExcess(String baseContentsExcess) {
        this.baseContentsExcess = baseContentsExcess;
    }

    public String getBaseHomeExcess() {
        return baseHomeExcess;
    }

    public void setBaseHomeExcess(String baseHomeExcess) {
        this.baseHomeExcess = baseHomeExcess;
    }

    public BusinessActivity getBusinessActivity() {
        return businessActivity;
    }

    public void setBusinessActivity(BusinessActivity businessActivity) {
        this.businessActivity = businessActivity;
    }

    public CoverAmounts getCoverAmounts() {
        return coverAmounts;
    }

    public void setCoverAmounts(CoverAmounts coverAmounts) {
        this.coverAmounts = coverAmounts;
    }

    public String getCoverType() {
        return coverType;
    }

    public void setCoverType(String coverType) {
        this.coverType = coverType;
    }

    public Disclosures getDisclosures() {
        return disclosures;
    }

    public void setDisclosures(Disclosures disclosures) {
        this.disclosures = disclosures;
    }

    public boolean hasDisclosures() {
        return this.disclosures != null && this.disclosures instanceof Disclosures;
    }

    public String getFsg() {
        return fsg;
    }

    public void setFsg(String fsg) {
        this.fsg = fsg;
    }

    public String getJourney_stage() {
        return journey_stage;
    }

    public void setJourney_stage(String journey_stage) {
        this.journey_stage = journey_stage;
    }

    public String getLastFieldTouch() {
        return lastFieldTouch;
    }

    public void setLastFieldTouch(String lastFieldTouch) {
        this.lastFieldTouch = lastFieldTouch;
    }

    public Occupancy getOccupancy() {
        return occupancy;
    }

    public void setOccupancy(Occupancy occupancy) {
        this.occupancy = occupancy;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public PolicyHolder getPolicyHolder() {
        return policyHolder;
    }

    public void setPolicyHolder(PolicyHolder policyHolder) {
        this.policyHolder = policyHolder;
    }

    public String getPrivacyoptin() {
        return privacyoptin;
    }

    public void setPrivacyoptin(String privacyoptin) {
        this.privacyoptin = privacyoptin;
    }

    public Property getProperty() {
        return property;
    }

    public void setProperty(Property property) {
        this.property = property;
    }

    public String getRenderingMode() {
        return renderingMode;
    }

    public void setRenderingMode(String renderingMode) {
        this.renderingMode = renderingMode;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getStartDateInputD() {
        return startDateInputD;
    }

    public void setStartDateInputD(String startDateInputD) {
        this.startDateInputD = startDateInputD;
    }

    public String getStartDateInputM() {
        return startDateInputM;
    }

    public void setStartDateInputM(String startDateInputM) {
        this.startDateInputM = startDateInputM;
    }

    public String getStartDateInputY() {
        return startDateInputY;
    }

    public void setStartDateInputY(String startDateInputY) {
        this.startDateInputY = startDateInputY;
    }

    public String getTerms() {
        return terms;
    }

    public void setTerms(String terms) {
        this.terms = terms;
    }

    public String getTermsAccepted() {
        return termsAccepted;
    }

    public void setTermsAccepted(String termsAccepted) {
        this.termsAccepted = termsAccepted;
    }

    public String createLeadFeedInfo() {
        String separator = "||";
        boolean okToCall = StringUtils.equals(policyHolder.getOktocall(), "Y");

        // Create leadFeedInfo
        StringBuilder sb = new StringBuilder();
        if (okToCall && policyHolder != null) {
            sb.append(fullName(policyHolder));
        }
        sb.append(separator);
        if (okToCall && policyHolder != null) {
            sb.append(StringUtils.trimToEmpty(policyHolder.getPhone()));
        }
        sb.append(separator);
        if (okToCall && property != null && property.getAddress() != null) {
            sb.append(StringUtils.trimToEmpty(property.getAddress().getDpId()));
        }
        sb.append(separator);
        if (okToCall && property != null && property.getAddress() != null) {
            sb.append(StringUtils.trimToEmpty(property.getAddress().getState()));
        }
        return sb.toString();
    }

    private String fullName(PolicyHolder policyHolder) {
        if (policyHolder == null) return null;
        return StringUtils.trimToEmpty(policyHolder.getFirstName() + " " + policyHolder.getLastName());
    }

    public Filter getFilter() {
        return filter;
    }

    public void setFilter(Filter filter) {
        this.filter = filter;
    }

    public String isUnderFinance() {
        return underFinance;
    }

    public void setUnderFinance(String underFinance) {
        this.underFinance = underFinance;
    }

}
