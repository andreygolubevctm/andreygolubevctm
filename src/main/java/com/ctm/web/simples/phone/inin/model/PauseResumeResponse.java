package com.ctm.web.simples.phone.inin.model;

public class PauseResumeResponse {

	private boolean success;
	private String responseText;

	private PauseResumeResponse() {
	}

	private PauseResumeResponse(boolean success, String responseText) {
		this.success = success;
		this.responseText = responseText;
	}

	public static PauseResumeResponse of(boolean success) {
		return new PauseResumeResponse(success, null);
	}

	public static PauseResumeResponse fail(String responseText) {
		return new PauseResumeResponse(false, responseText);
	}

	public static PauseResumeResponse success() {
		return new PauseResumeResponse(true, null);
	}

	public boolean isSuccess() {
		return success;
	}
	public String getResponseText() {
		return responseText;
	}
}
