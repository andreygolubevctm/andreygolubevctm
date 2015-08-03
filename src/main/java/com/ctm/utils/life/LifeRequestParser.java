package com.ctm.utils.life;

import com.ctm.model.request.life.LifePerson;
import com.ctm.model.request.life.LifeRequest;
import com.disc_au.web.go.Data;

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
