package com.ctm.web.simples.phone.inin.model;

public class PauseResumeResponse {

	private boolean success;

	private PauseResumeResponse() {
	}

	private PauseResumeResponse(boolean success) {
		this.success = success;
	}

	public static PauseResumeResponse of(boolean success) {
		return new PauseResumeResponse(success);
	}

	public static PauseResumeResponse fail() {
		return new PauseResumeResponse(false);
	}

	public static PauseResumeResponse success() {
		return new PauseResumeResponse(true);
	}

	public boolean isSuccess() {
		return success;
	}
}
