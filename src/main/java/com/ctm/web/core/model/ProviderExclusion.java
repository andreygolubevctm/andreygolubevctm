package com.ctm.web.core.model;

import java.util.Date;

public class ProviderExclusion {

	private int styleCodeId;
	private int verticalId;
	private int providerId;
	private Date excludeDateFrom;
	private Date excludeDateTo;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	private String code;

	public ProviderExclusion(){

	}

	public int getStyleCodeId() {
		return styleCodeId;
	}

	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}

	public int getVerticalId() {
		return verticalId;
	}

	public void setVerticalId(int verticalId) {
		this.verticalId = verticalId;
	}

	public int getProviderId() {
		return providerId;
	}

	public void setProviderId(int providerId) {
		this.providerId = providerId;
	}

	public Date getExcludeDateFrom() {
		return excludeDateFrom;
	}

	public void setExcludeDateFrom(Date excludeDateFrom) {
		this.excludeDateFrom = excludeDateFrom;
	}

	public Date getExcludeDateTo() {
		return excludeDateTo;
	}

	public void setExcludeDateTo(Date excludeDateTo) {
		this.excludeDateTo = excludeDateTo;
	}

}
