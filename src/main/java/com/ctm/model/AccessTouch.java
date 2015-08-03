package com.ctm.model;

import java.util.Date;

public class AccessTouch {

	private final Touch touch;
	private Date lockDateTime;
	private String operator;

	public AccessTouch(Touch touch) {
		this.touch = touch;
	}

	public void setLockDateTime(Date lockDateTime) {
		this.lockDateTime = lockDateTime;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}


	@SuppressWarnings("unused")
	// This is used in the jsp load_quote.tag
	public Date getLockDateTime() {
		return lockDateTime;
	}

	@SuppressWarnings("unused")
	// This is used in the jsp load_quote.tag
	public String  getOperator(){
		return operator;
	}

	public Touch getLastTouch(){
		return touch;
	}

}
