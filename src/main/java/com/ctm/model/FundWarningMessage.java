package com.ctm.model;

import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.NotNull;
import java.util.Date;

public class FundWarningMessage {

	private int messageId;

	@NotEmpty(message="Description can not be empty")
	private String messageContent;

	@NotNull(message="Effective Start date can not be empty")
	private Date effectiveStart;

	@NotNull(message="Effective End date  can not be empty")
	private Date effectiveEnd;

	@Range(min=0, message="Provider ID must be provided")
	private int providerId;

	@Range(min=1, message="Vertical ID must be positive Integer")
	private int verticalId;

	public FundWarningMessage(){	}

	public int getMessageId() {
		return messageId;
	}

	public void setMessageId(int messageId) {
		this.messageId = messageId;
	}

	public String getMessageContent() {
		return messageContent;
	}

	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
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

	@Override
	public String toString() {
		return "FundWarningMessage{" +
				"messageId=" + messageId +
				", messageContent='" + messageContent + '\'' +
				", effectiveStart=" + effectiveStart +
				", effectiveEnd=" + effectiveEnd +
				", providerId=" + providerId +
				", verticalId=" + verticalId +
				'}';
	}
}
