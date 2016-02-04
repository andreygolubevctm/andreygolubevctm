package com.ctm.web.life.utils;

import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.model.request.*;

public class LifeRequestParser {
	
	public static LifeRequest parseRequest(Data data, String vertical) {
		LifeRequest.Builder lifeRequestBuilder  = new LifeRequest.Builder();
		Primary primary = parsePrimary(data, vertical.toLowerCase() + "/primary");
		LifePerson partner = parsePartner(data, vertical.toLowerCase() + "/partner");
		ContactDetails contactDetails = parseContactDetails(data, vertical.toLowerCase() + "/contactDetails");
		return lifeRequestBuilder
				.partner(partner)
				.primary(primary)
				.contactDetails(contactDetails)
				.build();
	}

	private static ContactDetails parseContactDetails(Data data, String prefix) {
		ContactDetails contactDetails = new ContactDetails();
		data.createObjectFromData(contactDetails, prefix);
		return contactDetails;
	}

	private static LifePerson parsePartner(Data data,
										   String prefix) {
		LifePerson.Builder lifePersonB = new LifePerson.Builder();
		Insurance.Builder insuranceB = new Insurance.Builder();
		lifePersonB.insurance(data.createObjectFromData(insuranceB.build() , prefix + "/insurance"));
		LifePerson partner = lifePersonB.build();
		parsePartner(data, prefix, partner);
		data.createObjectFromData(partner, prefix);
		return partner;
	}

	private static Primary parsePrimary(Data data, String prefix) {
		Primary.Builder primaryBuilder = new Primary.Builder();
		primaryBuilder.insurance(data.createObjectFromData(new PrimaryInsurance(), prefix + "/insurance"));
		Primary pp = primaryBuilder.build();
		parsePartner(data, prefix, pp);
		Primary primary = primaryBuilder.build();
		data.createObjectFromData(primary, prefix);
		return primary;
	}

	private static void parsePartner(Data data, String prefix, LifePerson lifePerson) {
		data.createObjectFromData(lifePerson , prefix);
	}

}
