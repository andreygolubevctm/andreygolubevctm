package com.ctm.web.core.model;

import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.NotNull;
import java.util.Date;

public class ProviderContent {

	private int providerContentId;

	@NotNull(message="Content type must be provided")
	private int providerContentTypeId;

	@NotEmpty(message="Content can not be empty")
	private String providerContentText;

	@NotNull(message="Effective Start date can not be empty")
	private Date effectiveStart;

	@NotNull(message="Effective End date  can not be empty")
	private Date effectiveEnd;

	@Range(min=0, message="Provider ID must be provided")
	private int providerId;

	@Range(min=1, message="Vertical ID must be positive Integer")
	private int verticalId;

	@Range(min=0, message="StyleCode ID must be a positive Integer")
	public int styleCodeId;

	public String styleCode;

	public ProviderContent(){	}

	public int getProviderContentId() {
		return providerContentId;
	}

	public void setProviderContentId(int providerContentId) {
		this.providerContentId = providerContentId;
	}

	public int getProviderContentTypeId() {
		return providerContentTypeId;
	}

	public void setProviderContentTypeId(int providerContentTypeId) {
		this.providerContentTypeId = providerContentTypeId;
	}

	public String getProviderContentText() {
		return providerContentText;
	}

	public void setProviderContentText(String providerContentText) {
		this.providerContentText = providerContentText;
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

	public int getProviderId() {
		return providerId;
	}

	public void setProviderId(int providerId) {
		this.providerId = providerId;
	}

	public int getVerticalId() {
		return verticalId;
	}

	public void setVerticalId(int verticalId) {
		this.verticalId = verticalId;
	}

	public int getStyleCodeId() {
		return styleCodeId;
	}

	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}

	public String getStyleCode() {
		return styleCode;
	}

	public void setStyleCode(String styleCode) {
		this.styleCode = styleCode;
	}

	@Override
	public String toString() {
		return "ProviderContent{" +
				"providerContentId=" + providerContentId +
				", providerContentTypeId=" + providerContentTypeId +
				", providerContentText='" + providerContentText + '\'' +
				", effectiveStart=" + effectiveStart +
				", effectiveEnd=" + effectiveEnd +
				", providerId=" + providerId +
				", verticalId=" + verticalId +
				'}';
	}
}
