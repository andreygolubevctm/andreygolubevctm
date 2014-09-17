package com.ctm.model.email;

import java.util.ArrayList;
import java.util.List;

import com.ctm.model.RankingDetail;

public class HealthQuoteEmailModel extends BestPriceEmailModel {

	private List<RankingDetail> rankings = new ArrayList<RankingDetail>();

	public List<RankingDetail> getRankings() {
		return rankings;
	}

	private String brand;
	private long quoteReference;
	private String CoverType1;
	private String applyUrl;

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

	public void setQuoteReference(long transactionId) {
		this.quoteReference = transactionId;
	}

	public String getCoverType1() {
		return CoverType1;
	}

	public void setCoverType1(String coverType1) {
		CoverType1 = coverType1;
	}

	public void setRankings(List<RankingDetail> rankings) {
		this.rankings = rankings;
	}

	public String getApplyUrl() {
		return applyUrl;
	}
}
