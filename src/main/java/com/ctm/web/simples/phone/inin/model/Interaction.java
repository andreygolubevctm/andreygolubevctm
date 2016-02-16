package com.ctm.web.simples.phone.inin.model;

public class Interaction {

	private String interactionId;
	private InteractionAttributes attributes;

	public Interaction() {
	}

	public String getInteractionId() {
		return interactionId;
	}
	public InteractionAttributes getAttributes() {
		return attributes;
	}

	public void setInteractionId(String interactionId) {
		this.interactionId = interactionId;
	}
	public void setAttributes(InteractionAttributes attributes) {
		this.attributes = attributes;
	}
}
