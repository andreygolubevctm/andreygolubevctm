package com.ctm.web.homeloan.model;

import javax.validation.Valid;

import com.ctm.web.core.model.request.Person;

public class HomeLoanRequest {
	
	@Valid
	public Person contact;

}
