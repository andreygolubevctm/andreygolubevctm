package com.ctm.web.health.apply.model.request.fundData;

import java.util.function.Supplier;

/**
 * Created by msmerdon on 6/4/18.
 */
public class Referrer implements Supplier<String> {

	private final String value;

	public Referrer(final String value) {
		this.value = value;
	}

	@Override
	public String get() {
		return value;
	}
}
