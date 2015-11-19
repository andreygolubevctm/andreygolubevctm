package com.ctm.web.core.content.model;

public class ContentSupplement implements java.io.Serializable {

	private int contentControlId;
	private String supplementaryKey;
	private String supplementaryValue;

	public ContentSupplement(){

	}

	public int getContentControlId() {
		return contentControlId;
	}

	public void setContentControlId(int contentControlId) {
		this.contentControlId = contentControlId;
	}

	public String getSupplementaryKey() {
		return supplementaryKey;
	}

	public void setSupplementaryKey(String supplementaryKey) {
		this.supplementaryKey = supplementaryKey;
	}

	public String getSupplementaryValue() {
		return supplementaryValue;
	}

	public void setSupplementaryValue(String supplementaryValue) {
		this.supplementaryValue = supplementaryValue;
	}



}
