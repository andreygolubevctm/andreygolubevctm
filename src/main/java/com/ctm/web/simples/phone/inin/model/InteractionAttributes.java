package com.ctm.web.simples.phone.inin.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class InteractionAttributes {

	public String getCallIdKey() {
		return callIdKey;
	}

	@JsonProperty("Eic_CallIdKey")
	public String callIdKey;

	@JsonProperty("Eic_State")
	public String callState;

	@JsonProperty("Eic_CallStateString")
	public String callStateString;

	public InteractionAttributes() {
	}

	@Override
	public String toString() {
		return "InteractionAttributes{" +
				"callIdKey='" + callIdKey + '\'' +
				", callState='" + callState + '\'' +
				", callStateString='" + callStateString + '\'' +
				'}';
	}
}
