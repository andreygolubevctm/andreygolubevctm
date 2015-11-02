package com.ctm.web.life.utils;

import com.ctm.web.life.model.request.LifePerson;
import com.ctm.web.life.model.request.LifeRequest;
import com.ctm.web.core.web.go.Data;

public class LifeRequestParser {
	
	public static LifeRequest parseRequest(Data data, String vertical) {
		LifeRequest request = new LifeRequest();
		request.primary = parsePerson(data, request, vertical.toLowerCase() + "/primary/");
		if("Y".equals(data.getString(vertical.toLowerCase() + "/primary/insurance/partner"))) {
			request.partner = parsePerson(data, request, vertical.toLowerCase() + "/partner/");
		}
		return request;
	}
	
	private static LifePerson parsePerson(Data data, LifeRequest request,
			String prefix) {
		LifePerson lifePerson = new LifePerson();
		lifePerson.occupation = data.getString(prefix + "occupation");
		lifePerson.firstName = data.getString(prefix + "firstName");
		lifePerson.lastname = data.getString(prefix + "lastname");
		return lifePerson;
	}

}
