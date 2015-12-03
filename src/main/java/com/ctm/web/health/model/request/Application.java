package com.ctm.web.health.model.request;

import com.ctm.web.core.model.request.Person;

import javax.validation.Valid;

public class Application {

	public String provider;
	public String selectedProductId;

	@Valid
	public final Person partner = new Person();

	@Valid
	public final Person primary = new Person();

	public Integer income;

	@Valid
	public Dependants dependants;

	@Valid
	public Address address = new Address();

	@Valid
	public Address postal = new Address();

	public boolean postalMatch;

	@Override
	public String toString() {
		return "partner:\t" + partner + ",primary:" + primary;
	}

}
