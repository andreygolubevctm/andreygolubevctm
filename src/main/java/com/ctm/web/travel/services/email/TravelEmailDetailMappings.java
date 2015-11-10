package com.ctm.web.travel.services.email;

import com.ctm.web.core.email.mapping.EmailDetailsMappings;
import com.ctm.web.core.web.go.Data;

public class TravelEmailDetailMappings implements EmailDetailsMappings {

	private static String FIRSTNAME_XPATH = "travel/firstName";
	private static String SURNAME_XPATH = "travel/surname";

	@Override
	public String getFirstName(Data data) {
		Object firstNameObj = data.get(FIRSTNAME_XPATH);
		String firstName = "";
		if (firstNameObj instanceof String && !((String) firstNameObj).isEmpty()) {
			firstName = (String) firstNameObj;
		}
		return firstName;
	}

	@Override
	public String getLastName(Data data) {
		Object lastNameObj = data.get(SURNAME_XPATH);
		String lastName = "";
		if (lastNameObj instanceof String && !((String) lastNameObj).isEmpty()) {
			lastName = (String) lastNameObj;
		}
		return lastName;
	}
}
