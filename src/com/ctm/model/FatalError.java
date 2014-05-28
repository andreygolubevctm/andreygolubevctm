package com.ctm.model;

public class FatalError {

	private int styleCodeId = 0;
	private String message = "";
	private String fatal = "";
	private String transactionId = "";
	private String sessionId = "";
	private String data = "";
	private String description = "";
	private String page = "";
	private String property = "";

	public void setFatal(String fatal) {
		this.fatal = fatal;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	public void setData(String data) {
		this.data = data;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setmessage(String message) {
		this.message = message;
	}

	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId= styleCodeId;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	public void setPage(String page) {
		this.page = page;
	}

	public int getStyleCodeId() {
		return styleCodeId;
	}

	public String getProperty() {
		return property;
	}

	public String getpage() {
		return page;
	}

	public String getmessage() {
		return message;
	}

	public String getDescription() {
		return description;
	}

	public String getData() {
		return data;
	}

	public String getSessionId() {
		return sessionId;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public String getFatal() {
		return fatal;
	}

}
