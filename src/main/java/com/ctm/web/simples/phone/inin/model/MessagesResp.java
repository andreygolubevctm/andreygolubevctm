package com.ctm.web.simples.phone.inin.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class MessagesResp {

	@JsonProperty("__type")
	private String type;
	private List<Interaction> interactionsAdded;
	private List<Interaction> interactionsChanged;
	private List<String> interactionsRemoved;
	private boolean isDelta;
	private String subscriptionId;

	private MessagesResp() {
	}

	public MessagesResp(String type, List<Interaction> interactionsAdded, List<Interaction> interactionsChanged, List<String> interactionsRemoved, boolean isDelta, String subscriptionId) {
		this.type = type;
		this.interactionsAdded = interactionsAdded;
		this.interactionsChanged = interactionsChanged;
		this.interactionsRemoved = interactionsRemoved;
		this.isDelta = isDelta;
		this.subscriptionId = subscriptionId;
	}

	public String getType() {
		return type;
	}
	public List<Interaction> getInteractionsAdded() {
		return interactionsAdded;
	}
	public List<Interaction> getInteractionsChanged() {
		return interactionsChanged;
	}
	public List<String> getInteractionsRemoved() {
		return interactionsRemoved;
	}
	public boolean isDelta() {
		return isDelta;
	}
	public String getSubscriptionId() {
		return subscriptionId;
	}
}
