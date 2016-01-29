package com.ctm.web.simples.phone.inin.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Collections;
import java.util.List;

public class Message {

	@JsonProperty("__type")
	private String type;
	private List<Interaction> interactionsAdded;
	private List<Interaction> interactionsChanged;
	private List<String> interactionsRemoved;
	private boolean isDelta;
	private String subscriptionId;

	private Message() {
	}

	public Message(String type, List<Interaction> interactionsAdded, List<Interaction> interactionsChanged, List<String> interactionsRemoved, boolean isDelta, String subscriptionId) {
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
		return interactionsAdded != null ? interactionsAdded : Collections.emptyList();
	}
	public List<Interaction> getInteractionsChanged() {
		return interactionsChanged != null ? interactionsChanged : Collections.emptyList();
	}
	public List<String> getInteractionsRemoved() {
		return interactionsRemoved != null ? interactionsRemoved : Collections.emptyList();
	}
	public boolean isDelta() {
		return isDelta;
	}
	public String getSubscriptionId() {
		return subscriptionId;
	}

	@Override
	public String toString() {
		return "Message{" +
				"type='" + type + '\'' +
				", interactionsAdded=" + interactionsAdded +
				", interactionsChanged=" + interactionsChanged +
				", interactionsRemoved=" + interactionsRemoved +
				", isDelta=" + isDelta +
				", subscriptionId='" + subscriptionId + '\'' +
				'}';
	}
}
