package com.ctm.web.simples.phone.inin.model;

import com.ctm.web.core.model.Error;

public class PauseResumeResponse {

	private boolean success;
	private Error errors;
	private String interactionId;

	private PauseResumeResponse() {
	}

	private PauseResumeResponse(boolean success, String errorMessage, String interactionId) {
		this.success = success;
		this.errors = new Error(errorMessage);
		this.interactionId = interactionId;
	}

	public static PauseResumeResponse of(boolean success) {
		return new PauseResumeResponse(success, null, null);
	}

	public static PauseResumeResponse fail(String errorMessage) {
		return new PauseResumeResponse(false, errorMessage, null);
	}

	public static PauseResumeResponse success() {
		return new PauseResumeResponse(true, null, null );
	}

	public static PauseResumeResponse success(String interactionId) {
		return new PauseResumeResponse(true, null, interactionId);
	}

	public boolean isSuccess() {
		return success;
	}
	public Error getErrors() {
		return errors;
	}
	public String getInteractionId() { return interactionId; }
}
