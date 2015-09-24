package com.ctm.services.travel;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.travel.form.TravelQuote;
import com.ctm.model.travel.form.TravelRequest;
import com.ctm.services.EnvironmentService;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;
import java.util.function.Supplier;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

public class TravelServiceTest {

	private static final String vertical = "travel";
	private TravelService travelService;
	private TravelRequest travelRequest;
    private TravelQuote travelQuote;
	private SimpleConnection connection;

	@Before
	public void setup() throws Exception {
		EnvironmentService.setEnvironment("localhost");
		travelService = new TravelService();
		travelRequest = new TravelRequest();
        travelQuote = new TravelQuote();
		travelQuote.setOldest(80);
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
        travelQuote.setOldest(30);

		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelQuote.setFirstName("test");
        travelQuote.setSurname(null);
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelQuote.setFirstName(null);
        travelQuote.setSurname("Test");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelQuote.setFirstName("test");
        travelQuote.setSurname("Test");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelQuote.setFirstName("test??");
        travelQuote.setSurname("Test");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

        travelQuote.setFirstName("test");
        travelQuote.setSurname("Test??");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

        travelQuote.setFirstName("test??");
        travelQuote.setSurname("Test??");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

        travelQuote.setFirstName("test");
        travelQuote.setSurname("O'Test-you");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));
	}



	@Test
	public void testShouldValidateDestination() throws SQLException, DaoException {

		// Set defaults
        travelQuote.setAdults(1);
        travelQuote.setChildren(1);
        travelQuote.setOldest(30);

		// Destination field only accepts 3 letter characters
        travelRequest.getQuote().setDestination("BOB");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setDestination("BOB,ABC");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setDestination("BOB,ABC,TED");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

		// INVALID TEST CASES
        travelRequest.getQuote().setDestination("bob");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setDestination("BOB,TED,");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setDestination("BOB,TED, HI");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setDestination("bob,bob1-sfhs3-dfk");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setDestination("1");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

		// check for blank fields
        travelRequest.getQuote().setDestination("");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setDestination(" ");
		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

	}

	@Test
	public void testShouldValidateCurrentJourney() throws SQLException, DaoException {

		// Set defaults
        travelQuote.setAdults(1);
        travelQuote.setChildren(1);
        travelQuote.setOldest(30);

		isValid(() -> travelService.validateRequest(travelRequest, vertical));

		travelRequest.getQuote().setCurrentJourney("gggg");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setCurrentJourney("g3");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setCurrentJourney("3g");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

        travelRequest.getQuote().setCurrentJourney("36");
		isValid(() -> travelService.validateRequest(travelRequest, vertical));

	}

	@Test
	public void testShouldCheckForMandatoryValues() throws SQLException, DaoException {

		travelQuote.setAdults(null);
		travelQuote.setChildren(null);
		travelQuote.setOldest(null);

		isInvalid(() -> travelService.validateRequest(travelRequest, vertical));

		// Set defaults
        travelQuote.setAdults(1);
        travelQuote.setChildren(1);
        travelQuote.setOldest(30);

		isValid(() -> travelService.validateRequest(travelRequest, vertical));
	}

	private void isInvalid(Supplier<Boolean> supplier) {
		try {
			supplier.get();
		} catch (Exception e) {
			assertNotNull(e);
		}
	}

	private void isValid(Supplier<Boolean> supplier) {
		assertTrue(supplier.get());
	}


}