package com.ctm.model.request.health;

import javax.validation.constraints.Digits;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class Address {

	@Pattern(regexp = "^[A-Z]*")
	public String type;
	
	@Pattern(regexp = "^[\\w .'-()//,-/&]*")
	public String houseNoSel;
	
	@Pattern(regexp = "^[\\w .'-()//,-/&]*")
	public String suburbName;
	
	@Pattern(regexp = "^[\\w .'-()//,-/&]*")
	public String streetName;
	
	@Pattern(regexp = "^[\\w.'-()//,-/&]*")
	public String unitSel;
	
	@Pattern(regexp = "^[\\w .'-()//,-/&]*")
	public String streetNum;
	
	@Pattern(regexp = "^[\\w .'-()//,-/&]*")
	public String unitShop;
	
	@Size(min = 0, max = 30)
	@Digits(fraction = 0, integer = 30)
	public String suburb;

}
