package com.ctm.web.life.model.request;

import javax.validation.Valid;

public class LifeRequest {
	
	@Valid
	public LifePerson primary;
	
	@Valid
	public LifePerson partner;

}
