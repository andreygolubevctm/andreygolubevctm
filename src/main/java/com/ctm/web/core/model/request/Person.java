package com.ctm.web.core.model.request;

import com.ctm.web.core.validation.Name;

public class Person {

	@Name
	public String firstname;
	
	@Name
	public String surname;

	@Override
	public String toString() {
		return "firstname:" + firstname + ", surname:" + surname;
	}
}
