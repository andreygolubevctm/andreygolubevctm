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

	@Test
	public void testShouldValidateName() throws SQLException, DaoException {

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
		travelRequest.adults = "adult";
		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		travelRequest.adults = "1";
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

/*		TODO: fix this test
        travelRequest.destination = "bob";
		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());*/

		travelRequest.destination = "1";
		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());
	}

	@Test
	public void testShouldValidateCurrentJourney() throws SQLException, DaoException {

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


}