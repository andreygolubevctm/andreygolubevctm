package com.ctm.web.simples.phone.inin.model;

import com.fasterxml.jackson.annotation.JsonValue;

public enum QueueType {
	SYSTEM(0),
	USER(1),
	WORKGROUP(2),
	STATION(3);

	private final int value;

	QueueType(final int value) {
		this.value = value;
	}

	@JsonValue
	public int value() {
		return value;
	}
}
