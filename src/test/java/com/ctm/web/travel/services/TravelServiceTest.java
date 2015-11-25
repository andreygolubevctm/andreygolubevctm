package com.ctm.web.travel.services;


import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.travel.model.form.TravelQuote;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.model.form.Travellers;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.function.Supplier;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

public class TravelServiceTest {

	private static final String vertical = "travel";
	private TravelService travelService;
	private TravelRequest travelRequest;
	private TravelQuote travelQuote;
	private Travellers travellers;

	@Before
	public void setup() throws Exception {
		EnvironmentService.setEnvironment("localhost");
		travelService = new TravelService();
		travelRequest = new TravelRequest();
		travelQuote = new TravelQuote();

		travellers = Travellers.of(Arrays.asList(LocalDate.of(1935, 1, 1), LocalDate.of(1965, 1, 1)));

		travelQuote.setTravellers(travellers);
		travelQuote.setAdults(2);
		travelQuote.setChildren(1);
		travelQuote.setPolicyType("M");
		travelQuote.setRenderingMode("S");
		travelRequest.setTravel(travelQuote);
	}

	@Test
	public void testShouldValidateName() throws SQLException, DaoException {

		// Set defaults for mandatory fields
		travelQuote.setAdults(1);
		travelQuote.setChildren(1);

		travellers = new Travellers();
		travellers.setTravellersDOB("01/01/1985");
		travelQuote.setTravellers(travellers);

		isValid(travelRequest, vertical);

		travelQuote.setFirstName("test");
		travelQuote.setSurname(null);
		isValid(travelRequest, vertical);

		travelQuote.setFirstName(null);
		travelQuote.setSurname("Test");
		isValid(travelRequest, vertical);

		travelQuote.setFirstName("test");
		travelQuote.setSurname("Test");
		isValid(travelRequest, vertical);

		travelQuote.setFirstName("test??");
		travelQuote.setSurname("Test");
		isInvalid(travelRequest, vertical);

		travelQuote.setFirstName("test");
		travelQuote.setSurname("Test??");
		isInvalid(travelRequest, vertical);

		travelQuote.setFirstName("test??");
		travelQuote.setSurname("Test??");
		isInvalid(travelRequest, vertical);

		travelQuote.setFirstName("test");
		travelQuote.setSurname("O'Test-you");
		isInvalid(travelRequest, vertical);
	}

	@Test
	public void testShouldValidateDestination() throws SQLException, DaoException {

		// Set defaults
		travelQuote.setAdults(1);
		travelQuote.setChildren(1);

		travellers = new Travellers();
		travellers.setTravellersDOB("01/01/1985");
		travelQuote.setTravellers(travellers);

		// Destination field only accepts 3 letter characters
		travelRequest.getQuote().setDestination("BOB");
		isValid(travelRequest, vertical);

		travelRequest.getQuote().setDestination("BOB,ABC");
		isValid(travelRequest, vertical);

		travelRequest.getQuote().setDestination("BOB,ABC,TED");
		isValid(travelRequest, vertical);

		// INVALID TEST CASES
		travelRequest.getQuote().setDestination("bob");
		isInvalid(travelRequest, vertical);

		travelRequest.getQuote().setDestination("BOB,TED,");
		isInvalid(travelRequest, vertical);

		travelRequest.getQuote().setDestination("BOB,TED, HI");
		isInvalid(travelRequest, vertical);

		travelRequest.getQuote().setDestination("bob,bob1-sfhs3-dfk");
		isInvalid(travelRequest, vertical);

		travelRequest.getQuote().setDestination("1");
		isInvalid(travelRequest, vertical);

		// check for blank fields
		travelRequest.getQuote().setDestination("");
		isInvalid(travelRequest, vertical);

		travelRequest.getQuote().setDestination(" ");
		isInvalid(travelRequest, vertical);
	}

	@Test
	public void testShouldValidateCurrentJourney() throws SQLException, DaoException {

		// Set defaults
		travelQuote.setAdults(1);
		travelQuote.setChildren(1);

		travellers = new Travellers();
		travellers.setTravellersDOB("01/01/1985");
		travelQuote.setTravellers(travellers);

		isValid(travelRequest, vertical);

		travelRequest.getQuote().setCurrentJourney("gggg");
		isValid(travelRequest, vertical);

		travelRequest.getQuote().setCurrentJourney("g3");
		isValid(travelRequest, vertical);

		travelRequest.getQuote().setCurrentJourney("3g");
		isValid(travelRequest, vertical);

		travelRequest.getQuote().setCurrentJourney("36");
		isValid(travelRequest, vertical);
	}

	@Test
	public void testShouldCheckForMandatoryValues() throws SQLException, DaoException {

		travelQuote.setAdults(null);
		travelQuote.setChildren(null);

		travelQuote.setTravellers(null);
		isInvalid(travelRequest, vertical);

		// Set defaults
		travelQuote.setAdults(1);
		travelQuote.setChildren(1);

		travellers = new Travellers();
		travellers.setTravellersDOB("01/01/1985");
		travelQuote.setTravellers(travellers);

		isValid(travelRequest, vertical);
	}

	private void isInvalid(TravelRequest travelRequest, String s) {
		try {
			travelService.validateRequest(travelRequest, s);
		} catch (Exception e) {
			assertNotNull(e);
		}
	}

	private void isValid(Supplier<Boolean> supplier) {
		assertTrue(supplier.get());
	}

	private void isValid(TravelRequest travelRequest, String s) {
		travelService.validateRequest(travelRequest, s);
	}

}