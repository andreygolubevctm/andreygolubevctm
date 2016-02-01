package com.ctm.web.simples.phone.inin.model;

import java.util.List;

public class QueueSubscriptionReq {

	private List<QueueId> queueIds;
	private List<String> attributeNames;

	private QueueSubscriptionReq() {
	}

	public QueueSubscriptionReq(List<QueueId> queueIds, List<String> attributeNames) {
		this.queueIds = queueIds;
		this.attributeNames = attributeNames;
	}

	public List<QueueId> getQueueIds() {
		return queueIds;
	}

	public List<String> getAttributeNames() {
		return attributeNames;
	}

	@Override
	public String toString() {
		return "QueueSubscriptionReq{" +
				"queueIds=" + queueIds +
				", attributeNames=" + attributeNames +
				'}';
	}
}
