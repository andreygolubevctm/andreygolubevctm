package com.ctm.model.email;

import java.util.ArrayList;
import java.util.List;

public class HealthBestPriceEmailModel extends BestPriceEmailModel {

	private List<BestPriceRanking> rankings = new ArrayList<BestPriceRanking>();

	public List<BestPriceRanking> getRankings() {
		return rankings;
	}

	private long quoteReference;
	private String CoverType1;
	private String applyUrl;

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

	public void setRankings(List<BestPriceRanking> rankings) {
		this.rankings = rankings;
	}

	public String getApplyUrl() {
		return applyUrl;
	}

	@Override
	public String toString() {
		return "HealthBestPriceEmailModel{" +
				"rankings=" + rankings +
				", quoteReference=" + quoteReference +
				", CoverType1='" + CoverType1 + '\'' +
				", applyUrl='" + applyUrl + '\'' +
				'}';
	}
}
