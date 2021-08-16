package com.ctm.web.health.model.request;

import com.ctm.web.core.validation.Name;

import javax.validation.constraints.Size;


public class Medicare {
	
	public String number;
	public String cover;
	
	@Size(min = 0, max = 1)
	@Name
	public String middleInitial;

	public String cardExpiryDay;
	public String cardExpiryYear;
	public String cardExpiryMonth;
	public String firstName;
	public String surname;
	public String cardColour;

}
