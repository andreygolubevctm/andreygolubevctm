package com.ctm.services.travel;

import com.ctm.exceptions.DaoException;
import com.ctm.model.request.travel.TravelRequest;
import com.ctm.web.validation.SchemaValidationError;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;
import java.util.List;

import static org.junit.Assert.*;

public class TravelServiceTest {

	private static final String vertical = "travel";
	private TravelService travelService;
	private TravelRequest travelRequest;

	@Before
	public void setup() throws SQLException, DaoException {
		travelService = new TravelService();
		travelRequest = new TravelRequest();
	}

    // TODO FIX
/*
	@Test
	public void testShouldValidateName() throws SQLException, DaoException {

		// Set defaults for mandatory fields
		travelRequest.adults = "1";
		travelRequest.children = "1";
		travelRequest.oldest = "30";

		travelRequest.firstName = null;
		travelRequest.surname = null;
		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		boolean valid = travelService.isValid();
		assertTrue(valid);

		travelRequest.firstName = "test";
		travelRequest.surname = null;
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.firstName = null;
		travelRequest.surname = "test";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.firstName = "test";
		travelRequest.surname = "hurrow";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.firstName = "test??";
		travelRequest.surname = "hurrow";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.firstName = "test";
		travelRequest.surname = "hurrow??";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.firstName = "test??";
		travelRequest.surname = "hurrow??";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertEquals(2, validationErrors.size());

		travelRequest.firstName = "test";
		travelRequest.surname = "O'hurrow-you.";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());
	}

	@Test
	public void testShouldValidatePassengerCount() throws SQLException, DaoException {

		// Set defaults
		travelRequest.children = "1";
		travelRequest.oldest = "30";

		travelRequest.adults = "adult";
		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.adults = "1";
		travelRequest.children = "1";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.children = "children";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.children = "2";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());
	}


	@Test
	public void testShouldValidateOldestAge() throws SQLException, DaoException {

		// Set defaults
		travelRequest.adults = "1";
		travelRequest.children = "1";

		travelRequest.oldest = "ff";
		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.oldest = "3f";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.oldest = "22";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());
	}


	@Test
	public void testShouldValidateDestination() throws SQLException, DaoException {

		// Set defaults
		travelRequest.adults = "1";
		travelRequest.children = "1";
		travelRequest.oldest = "30";

		// Destination field only accepts 3 letter characters
        travelRequest.destination = "BOB";
		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.destination = "BOB,ABC";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.destination = "BOB,ABC,TED";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());
*/
		/** INVALID TEST CASES **/
/*		travelRequest.destination = "bob";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.destination = "BOB,TED,";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.destination = "BOB,TED, HI";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.destination = "bob,bob1-sfhs3-dfk";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.destination = "1";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		// check for blank fields
		travelRequest.destination = "";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.destination = " ";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());
	}

	@Test
	public void testShouldValidateCurrentJourney() throws SQLException, DaoException {

		// Set defaults
		travelRequest.adults = "1";
		travelRequest.children = "1";
		travelRequest.oldest = "30";

		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.currentJourney = "gggg";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.currentJourney = "g3";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.currentJourney = "3g";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.currentJourney = "36";
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());


	}

	@Test
	public void testShouldCheckForMandatoryValues() throws SQLException, DaoException {

		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		// Set defaults
		travelRequest.adults = "1";
		travelRequest.children = "1";
		travelRequest.oldest = "30";

		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());


	}
*/

}