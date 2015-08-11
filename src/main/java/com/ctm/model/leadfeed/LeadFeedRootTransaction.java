package com.ctm.model.leadfeed;

import java.util.ArrayList;

public class LeadFeedRootTransaction {

	private Long rootId =					null;
	private ArrayList<Long> transactions =	null;
	private Boolean hasLeadFeed =			false;
	private String styleCode = null;
	private String ipAddress = null;

	public LeadFeedRootTransaction(Long rootId) {
		transactions = new ArrayList<Long>();
		this.rootId = rootId;
	}

	public LeadFeedRootTransaction(Long rootId, Long transactionId) {
		transactions = new ArrayList<Long>();
		this.rootId = rootId;
		addTransaction(transactionId);
	}

	public Long getId() {
		return this.rootId;
	}

	public void addTransaction(Long transactionId) {
		if(transactions.contains(transactionId) == false) {
			transactions.add(transactionId);
		}
	}

	public void setHasLeadFeed(Boolean hasLeadFeed) {
		this.hasLeadFeed = hasLeadFeed;
	}

	public Boolean getHasLeadFeed() {
		return hasLeadFeed;
	}

	public Long getMinTransactionId() {
		Long min = null;
		for (Long tranId : transactions) {
			if (min == null) {
				min = tranId;
			} else if(tranId < min) {
				min = tranId;
			}
		}
		return min;
	}

	public Long getMaxTransactionId() {
		Long max = null;
		for (Long tranId : transactions) {
			if (max == null) {
				max = tranId;
			} else if(tranId > max) {
				max = tranId;
			}
		}
		return max;
	}

	public String toString() {
		return transactions.toString().replace("[", "").replace("]", "").replace(", ", ",");
	}

	public String getStyleCode() {
		return styleCode;
	}

	public void setStyleCode(String styleCode) {
		this.styleCode = styleCode;
	}

	public String getIpAddress() {
		return ipAddress;
	}

	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
}
