package com.ctm.model.request;

import com.ctm.web.validation.Name;

/**
 * TODO: there are three variations of lastname across verticals update to just have one
 * @author lbuchanan
 *
 */
public class PersonAltlastName {
	
	@Name
	public String firstName;
	@Name
	public String lastName;
	
}
