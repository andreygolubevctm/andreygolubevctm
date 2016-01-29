package com.ctm.web.simples.phone.inin.model;

public class Interaction {

	private String interactionId;
	private InteractionAttributes attributes;

	public Interaction(String interactionId, InteractionAttributes attributes) {
		this.interactionId = interactionId;
		this.attributes = attributes;
	}

	public String getInteractionId() {
		return interactionId;
	}

	public InteractionAttributes getAttributes() {
		return attributes;
	}

}
