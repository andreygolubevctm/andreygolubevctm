package com.ctm.services.life;

import static org.junit.Assert.assertEquals;

import java.sql.SQLException;
import java.util.List;

import org.junit.Test;

import com.ctm.exceptions.DaoException;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;

public class LifeValidationServiceTest {

	private static final String vertical = "ip";
	private static final String PRIMARY_OCCUPATION_XPATH = vertical +  "/primary/occupation";
	private static final String PARTNER_OCCUPATION_XPATH = vertical +  "/partner/occupation";

	@Test
	public void testShouldValidateOccupation() throws SQLException, DaoException {
		String validOccupation = "425813bb3eb10ecd2ec9ad4bcb16efc19813ecd8";

		LifeValidationService validationService = new LifeValidationService();
		Data data = new Data();

		data.put(PRIMARY_OCCUPATION_XPATH, "");
		data.put(PARTNER_OCCUPATION_XPATH, "");
		List<SchemaValidationError> validationErrors = validationService.validateQuoteResults(data, vertical);
		assertEquals(validationErrors.size() , 0);

		data.put(PRIMARY_OCCUPATION_XPATH, "test");
		data.put(PARTNER_OCCUPATION_XPATH, "");
		validationErrors = validationService.validateQuoteResults(data, vertical);
		assertEquals(1, validationErrors.size());

		data.put(PRIMARY_OCCUPATION_XPATH, "");
		data.put(PARTNER_OCCUPATION_XPATH, "test");
		validationErrors = validationService.validateQuoteResults(data, vertical);
		assertEquals(validationErrors.size() , 1);

		data.put(PRIMARY_OCCUPATION_XPATH, validOccupation);
		data.put(PARTNER_OCCUPATION_XPATH, validOccupation);
		validationErrors = validationService.validateQuoteResults(data, vertical);
		assertEquals(validationErrors.size() , 0);

		data.put(PRIMARY_OCCUPATION_XPATH, "");
		data.put(PARTNER_OCCUPATION_XPATH, validOccupation);
		validationErrors = validationService.validateQuoteResults(data, vertical);
		assertEquals(validationErrors.size() , 0);

		data.put(PRIMARY_OCCUPATION_XPATH, validOccupation);
		data.put(PARTNER_OCCUPATION_XPATH, "");
		validationErrors = validationService.validateQuoteResults(data, vertical);
		assertEquals(0 , validationErrors.size());

		data.put(PRIMARY_OCCUPATION_XPATH, "invalid");
		data.put(PARTNER_OCCUPATION_XPATH, validOccupation);
		validationErrors = validationService.validateQuoteResults(data, vertical);
		assertEquals(validationErrors.size() , 1);
	}

}
