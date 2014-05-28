package com.ctm.model.content;

import java.util.ArrayList;
import java.util.Date;


public class Content {

	private int id;
	private int styleCodeId;
	private String contentCode;
	private String contentKey;
	private Date effectiveStart;
	private Date effectiveEnd;
	private String contentValue;

	private ArrayList<ContentSupplement> supplementary;

	public Content(){

	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getStyleCodeId() {
		return styleCodeId;
	}

	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}

	public String getContentCode() {
		return contentCode;
	}

	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}

	public String getContentKey() {
		return contentKey;
	}

	public void setContentKey(String contentKey) {
		this.contentKey = contentKey;
	}

	public Date getEffectiveStart() {
		return effectiveStart;
	}

	public void setEffectiveStart(Date effectiveStart) {
		this.effectiveStart = effectiveStart;
	}

	public Date getEffectiveEnd() {
		return effectiveEnd;
	}

	public void setEffectiveEnd(Date effectiveEnd) {
		this.effectiveEnd = effectiveEnd;
	}

	public String getContentValue() {
		return contentValue;
	}

	public void setContentValue(String contentValue) {
		this.contentValue = contentValue;
	}

	public ArrayList<ContentSupplement> getSupplementary() {
		return supplementary;
	}

	public void setSupplementary(ArrayList<ContentSupplement> supplementary) {
		this.supplementary = supplementary;
	}


}
