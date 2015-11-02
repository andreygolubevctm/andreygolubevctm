package com.ctm.web.core.model;

import java.util.Date;

public class Confirmation {

	private long transactionId;
	private String key;
	private Date datetime;
	private String xmlData;

	public long getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}

	public Date getDatetime() {
		return datetime;
	}

	public void setDatetime(Date datetime) {
		this.datetime = datetime;
	}

	public String getXmlData() {
		return xmlData;
	}
	public void setXmlData(String xmlData) {
		this.xmlData = xmlData;
	}

}
