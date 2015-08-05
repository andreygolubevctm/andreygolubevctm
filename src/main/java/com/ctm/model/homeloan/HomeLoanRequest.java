package com.ctm.model.homeloan;

import javax.validation.Valid;

import com.ctm.model.request.Person;

public class HomeLoanRequest {
	
	@Valid
	public Person contact;

}
