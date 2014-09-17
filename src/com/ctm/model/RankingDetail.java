package com.ctm.model;

import java.util.HashMap;
import java.util.Map;

public class RankingDetail {

	private long transactionId;
	private final Map<String,String> properties = new HashMap<String,String>();
	private int rankPosition;

	public long getTransactionId() {
		return transactionId;
	}

	public int getRankPosition() {
		return rankPosition;
	}

	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}


	public void setRankPosition(int rankPosition) {
		this.rankPosition = rankPosition;
	}

	public void addProperty(String key, String value) {
		properties.put(key, value);
	}

	public String getProperty(String key) {
		return properties.get(key);
	}

}
