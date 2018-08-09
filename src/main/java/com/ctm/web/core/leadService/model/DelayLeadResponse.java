package com.ctm.web.core.leadService.model;

public class DelayLeadResponse {

	private String outcome;

	public DelayLeadResponse(){}

	public DelayLeadResponse(final String outcome) {
		this.outcome = outcome;
	}

	public String getOutcome() {
		return outcome;
	}

	@Override
	public String toString() {
		return "DelayLeadResponse{" +
				"outcome='" + outcome + "'" +
				'}';
	}
}