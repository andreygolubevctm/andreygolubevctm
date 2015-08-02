package com.ctm.web.validation;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class EmailValidation {

	private static final String EMAIL_PATTERN =
			"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$";
	private static final Pattern pattern = Pattern.compile(EMAIL_PATTERN);

	public static boolean validate(String emailAddress) {
		if(emailAddress == null){
			return false;
		}
		Matcher  matcher = pattern.matcher(emailAddress);
		return matcher.matches();
	}

}
