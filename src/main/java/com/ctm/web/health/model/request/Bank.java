package com.ctm.web.health.model.request;

import com.ctm.web.core.validation.Name;

import javax.validation.constraints.Digits;
import javax.validation.constraints.Size;

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
