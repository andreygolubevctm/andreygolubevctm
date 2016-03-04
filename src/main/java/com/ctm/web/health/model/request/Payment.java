package com.ctm.web.health.model.request;

import com.ctm.web.core.validation.Name;

import javax.validation.Valid;
import javax.validation.constraints.Pattern;

public class Payment {
	
	@Pattern(regexp = "[\\w .-]+")
	public String creditName;
	
	@Valid
	public Bank bank = new Bank();
	
	@Valid
	public Bank claim = new Bank();
	
	@Valid
	public Credit credit;
	
	@Valid
	public Details details;
	
	@Pattern(regexp = "[\\w ]+")
	public String gatewayNumber;

	@Name
	public String gatewayName;

	@Valid
	public Medicare medicare;

}
