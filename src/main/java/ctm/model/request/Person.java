package com.ctm.model.request;

import com.ctm.web.validation.Name;

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
