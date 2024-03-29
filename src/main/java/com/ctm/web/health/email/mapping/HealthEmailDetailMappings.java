package com.ctm.web.health.email.mapping;

import com.ctm.web.core.email.mapping.EmailDetailsMappings;
import com.ctm.web.core.web.go.Data;

public class HealthEmailDetailMappings implements EmailDetailsMappings {

	private static String NAME_XPATH = "health/contactDetails/name";
	private static String FIRSTNAME_XPATH = "health/application/primary/firstname";
	private static String SURNAME_XPATH = "health/application/primary/surname";

	@Override
	public String getFirstName(Data data) {
		Object nameObj = data.get(NAME_XPATH );
		String firstName = "";
		if (nameObj instanceof String && !((String) nameObj).isEmpty()) {
			firstName = (String) nameObj;
		} else {
			Object firstNameObj = data.get(FIRSTNAME_XPATH);
			if (firstNameObj instanceof String && !((String) firstNameObj).isEmpty()) {
				firstName = (String) firstNameObj;
			}
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
