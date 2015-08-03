package com.ctm.model.request.health;

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
	@Pattern(regexp = "[a-zA-Z ]+")
	public String gatewayName;

	@Valid
	public Medicare medicare;

}
