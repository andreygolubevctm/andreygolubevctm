package com.ctm.services.health;

import static org.junit.Assert.assertEquals;

import java.sql.SQLException;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

import com.ctm.exceptions.DaoException;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;

public class HealthApplicationValidationServiceTest {

	private static final String REBATE_XPATH = "health/healthCover/rebate";
	private static final String PROVIDER_XPATH = "health/application/provider";
	private static final String MEDICARE_NUMBER_XPATH = "health/payment/medicare/number";
	private HealthApplicationValidationService validationService;
	private Data data;
	
	@Before
	public void setUp() {
		validationService = new HealthApplicationValidationService();
		data = new Data();
		data.put(REBATE_XPATH, "Y");
	}

	@Test
	public void testShouldValidateMedicareNumber() throws SQLException, DaoException {
		String validMedicareNumber = "2249944514";
		// invalid format
		String invalidMedicareNumber1 = "2241111114";
		// too short
		String invalidMedicareNumber2 = "224994";
		// starts with wrong number
		String invalidMedicareNumber3 = "9249944514";
		
		data.put(MEDICARE_NUMBER_XPATH, validMedicareNumber);
		List<SchemaValidationError> validationErrors = validationService.validate(data );
		assertEquals(0 , validationErrors.size());

		data.put(MEDICARE_NUMBER_XPATH, invalidMedicareNumber1);
		validationErrors = validationService.validate(data );
		assertEquals(1, validationErrors.size());

		data.put(MEDICARE_NUMBER_XPATH, invalidMedicareNumber2);
		validationErrors = validationService.validate(data );
		assertEquals(1, validationErrors.size());

		data.put(MEDICARE_NUMBER_XPATH, invalidMedicareNumber3);
		validationErrors = validationService.validate(data );
		assertEquals(validationErrors.size() , 1);

		// if rebate is not selected don't validate
		data.put(MEDICARE_NUMBER_XPATH,invalidMedicareNumber1);
		data.put(PROVIDER_XPATH, "AUF");
		data.put(REBATE_XPATH, "N");
		validationErrors = validationService.validate(data );
		assertEquals(0 , validationErrors.size());

		// if Bupa is the provider validate regardless of if rebate has being selected
		data.put(MEDICARE_NUMBER_XPATH,invalidMedicareNumber1);
		data.put(PROVIDER_XPATH, "BUP");
		data.put(REBATE_XPATH, "N");
		validationErrors = validationService.validate(data );
		assertEquals(1 ,validationErrors.size());
	}

	@Test
	public void validateEmptyMedicareNumber() {
		List<SchemaValidationError> validationErrors;
		// medicare number cannot be empty
		data.put(REBATE_XPATH, "Y");
		data.put(MEDICARE_NUMBER_XPATH, "");
		validationErrors = validationService.validate(data );
		assertEquals(1, validationErrors.size());
	}

}
