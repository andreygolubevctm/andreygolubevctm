package com.ctm.model.request.health;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

public class Dependants {

	public int income;
	
	@Valid
	public List<Dependant> dependants = new ArrayList<>();

}
