package com.ctm.web.simples.phone.inin.model;

import com.ctm.web.core.model.Error;

public class PauseResumeResponse {

	private boolean success;
	private Error errors;

	private PauseResumeResponse() {
	}

	private PauseResumeResponse(boolean success, String errorMessage) {
		this.success = success;
		this.errors = new Error(errorMessage);
	}

	public static PauseResumeResponse of(boolean success) {
		return new PauseResumeResponse(success, null);
	}

	public static PauseResumeResponse fail(String errorMessage) {
		return new PauseResumeResponse(false, errorMessage);
	}

	public static PauseResumeResponse success() {
		return new PauseResumeResponse(true, null);
	}

	public boolean isSuccess() {
		return success;
	}
	public Error getErrors() {
		return errors;
	}
}
