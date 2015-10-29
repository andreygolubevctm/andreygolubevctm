package com.ctm.web.health.model.request;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

public class Dependants {

	public int income;
	
	@Valid
	public List<Dependant> dependants = new ArrayList<>();

}
