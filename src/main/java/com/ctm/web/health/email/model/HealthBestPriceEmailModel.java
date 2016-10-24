package com.ctm.web.health.email.model;

import com.ctm.web.core.email.model.BestPriceEmailModel;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class HealthBestPriceEmailModel extends BestPriceEmailModel {

	private List<HealthBestPriceRanking> rankings = new ArrayList<>();

	public List<HealthBestPriceRanking> getRankings() {
		return rankings;
	}

	private long quoteReference;
	private String CoverType1;
	private String applyUrl;
	private String healthMembership;
	private String coverLevel;
	private String healthSituation;
	private String benefitCodes;
	private String coverType;
	private String primaryCurrentPHI;

	public void setApplyUrl(String applyUrl) {
		this.applyUrl = applyUrl;
	}

	public long getQuoteReference() {
		return quoteReference;
	}

	public void setTransactionId(long transactionId) {
		this.quoteReference = transactionId;
	}

	public String getCoverType1() {
		return CoverType1;
	}

	public void setCoverType1(String coverType1) {
		CoverType1 = coverType1;
	}

	public void setRankings(List<HealthBestPriceRanking> rankings) {
		this.rankings = rankings;
	}

	public String getApplyUrl() {
		return applyUrl;
	}

	public Optional<String> getHealthMembership() {
		return Optional.ofNullable(healthMembership);
	}

	public void setHealthMembership(String healthMembership) {
		this.healthMembership = healthMembership;
	}

	public Optional<String> getCoverLevel() {
		return Optional.ofNullable(coverLevel);
	}

	public void setCoverLevel(String coverLevel) {
		this.coverLevel = coverLevel;
	}

	public Optional<String> getHealthSituation() {
		return Optional.ofNullable(healthSituation);
	}

	public void setHealthSituation(String healthSituation) {
		this.healthSituation = healthSituation;
	}

	public Optional<String> getBenefitCodes() {
		return Optional.ofNullable(benefitCodes);
	}

	public void setBenefitCodes(String benefitCodes) {
		this.benefitCodes = benefitCodes;
	}

	public Optional<String> getCoverType() {
		return Optional.ofNullable(coverType);
	}

	public void setCoverType(String coverType) {
		this.coverType = coverType;
	}

	public Optional<String> getPrimaryCurrentPHI() {
		return Optional.ofNullable(primaryCurrentPHI);
	}

	public void setPrimaryCurrentPHI(String primaryCurrentPHI) {
		this.primaryCurrentPHI = primaryCurrentPHI;
	}

	@Override
	public String toString() {
		return "HealthBestPriceEmailModel{" +
				"rankings=" + rankings +
				", quoteReference=" + quoteReference +
				", CoverType1='" + CoverType1 + '\'' +
				", applyUrl='" + applyUrl + '\'' +
				", policySituation='" + healthMembership + '\'' +
				", policyCoverType='" + coverLevel + '\'' +
				", healthSituation='" + healthSituation + '\'' +
				", benefitCodes='" + benefitCodes + '\'' +
				", primaryCurrentPHI='" + primaryCurrentPHI + '\'' +
				'}';
	}
}
