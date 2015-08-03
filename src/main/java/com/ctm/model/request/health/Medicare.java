package com.ctm.model.request.health;

import javax.validation.constraints.Size;

import com.ctm.web.validation.Name;

public class Medicare {
	
	public String number;
	public String cover;
	
	@Size(min = 0, max = 1)
	@Name
	public String middleInitial;

	public String cardExpiryYear;
	public String cardExpiryMonth;
	public String firstName;
	public String surname;

}
