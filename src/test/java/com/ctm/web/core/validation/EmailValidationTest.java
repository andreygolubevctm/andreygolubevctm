package com.ctm.web.validation;

import static org.junit.Assert.*;
import org.junit.Test;

public class EmailValidationTest {

	private static final String VALID_EMAIL = "validEmail@test.com.au";
	private static final String INVALID_EMAIL = "invalidEmail";

	@Test
	public void shouldValidationEmailAddress() {

		boolean isValid = EmailValidation.validate(INVALID_EMAIL);
		assertFalse(isValid);

		isValid = EmailValidation.validate(VALID_EMAIL);
		assertTrue(isValid);

		isValid = EmailValidation.validate("");
		assertFalse(isValid);


		isValid = EmailValidation.validate("Testin.O'Test+7@comparethemarket.com.au");
		assertTrue(isValid);

		isValid = EmailValidation.validate("Testina.Mctest!@gmail.com");
		assertTrue(isValid);

		isValid = EmailValidation.validate("14049955@student.test.edu.au");
		assertTrue(isValid);

		isValid = EmailValidation.validate("-==---@test.com");
		assertTrue(isValid);
	}

}
