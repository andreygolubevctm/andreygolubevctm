package com.ctm.web.core.validation.health;

import static org.junit.Assert.assertEquals;

import java.sql.SQLException;
import java.util.List;

import com.ctm.web.health.validation.HealthApplicationValidation;
import org.junit.Before;
import org.junit.Test;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.model.request.Application;
import com.ctm.web.health.model.request.Dependants;
import com.ctm.web.health.model.request.Dependant;
import com.ctm.web.health.model.request.HealthApplicationRequest;
import com.ctm.web.health.model.request.Medicare;
import com.ctm.web.health.model.request.Payment;
import com.ctm.web.core.validation.SchemaValidationError;

public class HealthApplicationValidationTest {

	private HealthApplicationValidation validationService;
	private HealthApplicationRequest healthApplication;
	private String validMedicareNumber = "2249944514";
	
	@Before
	public void setUp() {
		validationService = new HealthApplicationValidation();
		healthApplication = new HealthApplicationRequest();
		healthApplication.payment = new Payment();
		healthApplication.application = new Application();
		healthApplication.hasRebate = true;
		healthApplication.payment.medicare = new Medicare();
		healthApplication.application.dependants  = new Dependants();
		Dependant d1 = new Dependant();
		Dependant d2 = new Dependant();
		healthApplication.application.dependants.dependants.add(d1);
		healthApplication.application.dependants.dependants.add(d2);
		setToValidState();
	}

	@Test
	public void testShouldValidateMedicareNumber() throws SQLException, DaoException {
		// invalid format
		String invalidMedicareNumber1 = "2241111114";
		// too short
		String invalidMedicareNumber2 = "224994";
		// starts with wrong number
		String invalidMedicareNumber3 = "9249944514";
		
		healthApplication.payment.medicare.number = validMedicareNumber;
		List<SchemaValidationError> validationErrors = validationService.validate(healthApplication);
		assertEquals(0 , validationErrors.size());

		healthApplication.payment.medicare.number = invalidMedicareNumber1;
		validationErrors = validationService.validate(healthApplication);
		assertEquals(1, validationErrors.size());

		healthApplication.payment.medicare.number = invalidMedicareNumber2;
		validationErrors = validationService.validate(healthApplication);
		assertEquals(1, validationErrors.size());

		healthApplication.payment.medicare.number = invalidMedicareNumber3;
		validationErrors = validationService.validate(healthApplication);
		assertEquals(validationErrors.size() , 1);

		// if rebate is not selected don't validate
		healthApplication.payment.medicare.number = invalidMedicareNumber1;
		healthApplication.application.provider = "AUF";
		healthApplication.hasRebate = false;
		validationErrors = validationService.validate(healthApplication);
		assertEquals(0 , validationErrors.size());

		// if Bupa is the provider validate regardless of if rebate has being selected
		healthApplication.payment.medicare.number = invalidMedicareNumber1;
		healthApplication.application.provider = "BUP";
		healthApplication.hasRebate = false;
		validationErrors = validationService.validate(healthApplication);
		assertEquals(1 ,validationErrors.size());
		
		
		setToValidState();
		healthApplication.payment.medicare.middleInitial = "aaa";
		runValidation(1);
		healthApplication.payment.medicare.middleInitial = "A";
		runValidation(0);
	}

	@Test
	public void validateEmptyMedicareNumber() {
		List<SchemaValidationError> validationErrors;
		// medicare number cannot be empty
		healthApplication.hasRebate = true;
		healthApplication.payment.medicare.number = "";
		validationErrors = validationService.validate(healthApplication);
		assertEquals(1, validationErrors.size());
	}
	

	@Test
	public void shouldCheckForSQLOnValidate() {
		testForSQL("105; DROP TABLE Suppliers");
		testForSQL("engineer' AND 8613=IF((ORD(MID((SELECT IFNULL(CAST(table_name AS CHAR),0x20) FROM INFORMATION_SCHEMA.TABLES WHERE table_schema=0x72657461696c LIMIT 6,1),10,1))>64),BENCHMARK(8000000,MD5(0x44496f47)),8613) AND 'FWKp'='FWKp");	
		testForSQL("engineer'((..]'.[(");	
		testForSQL("engineer) AND 5963=3584 AND (8750=8750");
	}
	
	@Test
	public void shouldValidateAddress() {	
		testValidStreetName("Gregory St.");	
		testValidStreetName("Grey St (Mantra Southbank)");	
		testValidStreetName("O'Doherty Avenue");	
		testValidStreetName("St Tropez Gardens, Piara Waters WA");
		testValidStreetName("Gavial-Gracemere Rd");
		testValidStreetName("R/O Station Road");
		testValidUnitShop("523");
		testValidUnitShop("5-7");
		testValidUnitShop("2/10");
	}

	@Test
	public void shouldValidateSuburb() {
		testValidSuburb("7");
		testValidSuburb("1007742");
		testValidSuburb("9994");
		testValidSuburb("1000108");
		
		healthApplication.application.address.suburb = "aaa";
		runValidation(1);
		setToValidState();
	}

	private void testValidSuburb(String value) {
		healthApplication.application.address.suburb = value;
		runValidation(0);
	}
	
	@Test
	public void shouldValidateDependents() {
		healthApplication.application.dependants.dependants.get(0).firstname = "Brodi";
		runValidation(0);
		
		healthApplication.application.dependants.dependants.get(0).lastname = "TAMAS";
		runValidation(0);
	
		healthApplication.application.dependants.dependants.get(0).lastname = "Test-Tester";
		runValidation(0);
		
		healthApplication.application.dependants.dependants.get(1).firstname = "Celine";
		runValidation(0);
		
		healthApplication.application.dependants.dependants.get(1).lastname = "Charlesworth";
		runValidation(0);
		
		healthApplication.application.dependants.dependants.get(1).lastname = "O'Test";
		runValidation(0);
	}

	private void testValidUnitShop(String value) {
		healthApplication.application.address.unitShop = value;
		runValidation(0);
	}
	
	private void testValidStreetName(String value) {
		healthApplication.application.address.streetName = value;
		runValidation(0);
	}

	private void runValidation(int expectedErrors) {
		List<SchemaValidationError> validationErrors;
		validationErrors = validationService.validate(healthApplication);
		for(SchemaValidationError error : validationErrors){
			System.out.println("validation error " + error.getMessage());
		}
		assertEquals(expectedErrors, validationErrors.size());
	}
	
	private void testForSQL(String value) {
		setToValidState();
		healthApplication.application.address.streetName = value;
		runValidation(1);
		
		setToValidState();
		healthApplication.application.address.unitShop = value;
		runValidation(1);
		
		setToValidState();
		healthApplication.application.dependants.dependants.get(0).firstname = value;
		runValidation(1);
		
		setToValidState();
		healthApplication.application.dependants.dependants.get(0).lastname = value;
		runValidation(1);
		
		setToValidState();
		healthApplication.application.dependants.dependants.get(1).firstname = value;
		runValidation(1);
		
		setToValidState();
		healthApplication.application.dependants.dependants.get(1).lastname = value;
		runValidation(1);
		
		
		setToValidState();
		healthApplication.application.primary.firstname = value;
		runValidation(1);
		
		setToValidState();
		healthApplication.application.primary.surname = value;
		runValidation(1);
	}

	private void setToValidState() {
		healthApplication.payment.medicare.number = validMedicareNumber;
		healthApplication.application.dependants.dependants.get(0).firstname  = "Meerkoff";
		healthApplication.application.dependants.dependants.get(0).lastname  = "Meerkat";
		healthApplication.application.dependants.dependants.get(1).firstname  = "Sergie";
		healthApplication.application.dependants.dependants.get(1).lastname  = "Meerkat";
		healthApplication.application.address.streetName = "Valid St";
		healthApplication.application.address.unitShop = "1";
		healthApplication.application.address.suburb = "1002476";
		
		healthApplication.application.primary.firstname = "Alexandar";
		healthApplication.application.primary.surname = "Olaf";
	}

}
