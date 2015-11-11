package com.ctm.web.travel.email.model;

import com.ctm.web.core.email.model.BestPriceEmailModel;

import java.util.List;

public class TravelBestPriceEmailModel extends BestPriceEmailModel {

	private String brand;
	private long quoteReference;
	private String coverType;
	private String applyUrl;
	private String productLabel;
	private String destinations;
	private String startDate;
	private String endDate;
	private String adults;
	private String children;
	private String adult1_dob;
	private String adult2_dob;
	private String OME;
	private String LPE;
	private String excess;
	private String policyType;
	private String duration;
	private String pricePresentationUrl;
	private String coverLevelTabsType;
	private String coverLevelTabsDesc;
	private List<TravelBestPriceRanking> rankings;

	public List<TravelBestPriceRanking> getRankings() {
		return rankings;
	}

	public void setApplyUrl(String applyUrl) {
		this.applyUrl = applyUrl;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public long getQuoteReference() {
		return quoteReference;
	}

	public void setTransactionId(long transactionId) {
		this.quoteReference = transactionId;
	}

	public String getCoverType() {
		return coverType;
	}

	public void setCoverType(String coverType) {
		this.coverType = coverType;
	}

	public void setRankings(List<TravelBestPriceRanking> rankings) {
		this.rankings = rankings;
	}

	public String getApplyUrl() {
		return applyUrl;
	}

	public String getProductLabel() {
		return productLabel;
	}

	public void setProductLabel(String productLabel) {
		this.productLabel = productLabel;
	}

	public String getDestinations() {
		return destinations;
	}

	public void setDestinations(String destinations) {
		this.destinations = destinations;
	}

	public String getStartDate() {
		return this.startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return this.endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getAdults() {
		return adults;
	}

	public void setAdults(String adults) {
		this.adults = adults;
	}

	public String getChildren() {
		return children;
	}

	public void setChildren(String children) {
		this.children = children;
	}

	public String getAdult1DOB() {
		return adult1_dob;
	}

	public void setAdult1DOB(String adult1_dob) {
		this.adult1_dob = adult1_dob;
	}

	public String getAdult2DOB() {
		return adult2_dob;
	}

	public void setAdult2DOB(String adult2_dob) {
		this.adult2_dob = adult2_dob;
	}

	public String getOME() {
		return OME;
	}

	public void setOME(String OME) {
		this.OME = OME;
	}

	public String getCFC() {
		return OME;
	}

	public String getLPE() {
		return LPE;
	}

	public void setLPE(String LPE) {
		this.LPE = LPE;
	}

	public String getExcess() {
		return excess;
	}

	public void setExcess(String excess) {
		this.excess = excess;
	}

	public String getPolicyType() {
		return policyType;
	}

	public void setPolicyType(String policyType) {
		this.policyType = policyType;
	}

	public String getDuration() {
		return duration;
	}

	public void setDuration(String duration) {
		this.duration = duration;
	}

	public String getCompareResultsURL() {
		return pricePresentationUrl;
	}

	public void setCompareResultsURL(String url) {
		this.pricePresentationUrl = url;
	}

	public String getCoverLevelTabsType() {
		return coverLevelTabsType;
	}

	public void setCoverLevelTabsType(String coverLevelTabsType) {
		this.coverLevelTabsType = coverLevelTabsType;
	}

	public String getCoverLevelTabsDescription() {
		return coverLevelTabsDesc;
	}

	public void setCoverLevelTabsDescription(String coverLevelTabsDesc) {
		this.coverLevelTabsDesc = coverLevelTabsDesc;
	}

	@Override
	public String toString() {
		return "TravelBestPriceEmailModel{" +
				"brand='" + brand + '\'' +
				", quoteReference=" + quoteReference +
				", coverType='" + coverType + '\'' +
				", applyUrl='" + applyUrl + '\'' +
				", productLabel='" + productLabel + '\'' +
				", destinations='" + destinations + '\'' +
				", startDate='" + startDate + '\'' +
				", endDate='" + endDate + '\'' +
				", adults='" + adults + '\'' +
				", children='" + children + '\'' +
				", adult1_dob='" + adult1_dob + '\'' +
				", adult2_dob='" + adult2_dob + '\'' +
				", OME='" + OME + '\'' +
				", LPE='" + LPE + '\'' +
				", excess='" + excess + '\'' +
				", policyType='" + policyType + '\'' +
				", duration='" + duration + '\'' +
				", pricePresentationUrl='" + pricePresentationUrl + '\'' +
				", coverLevelTabsType='" + coverLevelTabsType + '\'' +
				", coverLevelTabsDesc='" + coverLevelTabsDesc + '\'' +
				", rankings=" + rankings +
				'}';
	}
}
