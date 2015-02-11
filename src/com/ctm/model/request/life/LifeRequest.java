package com.ctm.model.request.life;

import javax.validation.Valid;

public class LifeRequest {
	
	@Valid
	public LifePerson primary;
	
	@Valid
	public LifePerson partner;

}
