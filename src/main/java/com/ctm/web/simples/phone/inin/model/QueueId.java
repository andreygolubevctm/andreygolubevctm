package com.ctm.web.simples.phone.inin.model;

import java.util.Objects;

public class QueueId {

	private QueueType queueType;
	private String queueName;

	private QueueId() {
	}

	public QueueId(QueueType queueType, String queueName) {
		this.queueType = queueType;
		this.queueName = queueName;
	}

	public QueueType getQueueType() {
		return queueType;
	}

	public String getQueueName() {
		return queueName;
	}

	@Override
	public boolean equals(final Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		final QueueId that = (QueueId) o;
		return Objects.equals(queueType, that.queueType) &&
				Objects.equals(queueName, that.queueName);
	}

	@Override
	public int hashCode() {
		return Objects.hash(queueType, queueName);
	}

	@Override
	public String toString() {
		return "QueueId{" +
				"queueType=" + queueType +
				", queueName='" + queueName + '\'' +
				'}';
	}
}
