package com.ctm.model.request.health;

import javax.validation.Valid;

import com.ctm.model.request.Person;

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
