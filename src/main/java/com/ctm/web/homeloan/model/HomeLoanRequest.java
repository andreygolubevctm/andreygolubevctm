package com.ctm.web.homeloan.model;

import com.ctm.web.core.model.request.Person;

import javax.validation.Valid;

public class HomeLoanRequest {
	
	@Valid
	public Person contact;

}
