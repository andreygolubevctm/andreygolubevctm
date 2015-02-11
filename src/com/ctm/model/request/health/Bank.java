package com.ctm.model.request.health;

import javax.validation.constraints.Digits;
import javax.validation.constraints.Size;
import javax.validation.constraints.Pattern;

import com.ctm.web.validation.Name;

public class Bank {

	@Size(min = 0, max = 30)
	@Digits(fraction = 0, integer = 30)
	public String number;
	
	@Size(min = 0, max = 30)
	@Name
	public String account;
	
	@Size(min = 0, max = 30)
	@Name
	public String name;

}
