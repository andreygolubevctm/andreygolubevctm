package com.ctm.services.travel;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.TravelServiceException;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.travel.form.TravelQuote;
import com.ctm.model.travel.form.TravelRequest;
import com.ctm.model.travel.form.Travellers;
import com.ctm.services.EnvironmentService;
import com.ctm.web.validation.SchemaValidationError;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class TravelServiceTest {

	private static final String vertical = "travel";
	private TravelService travelService;
	private TravelRequest travelRequest;
    private TravelQuote travelQuote;
	private SimpleConnection connection;
	private Travellers travellers;

	@Before
	public void setup() throws Exception {
		EnvironmentService.setEnvironment("localhost");
		ServiceConfiguration serviceConfig = new ServiceConfiguration();
		connection = mock(SimpleConnection.class);
		travelService = new TravelService(serviceConfig, connection);
		travelRequest = new TravelRequest();
        travelQuote = new TravelQuote();

		travellers = new Travellers();
		travellers.setTravellersDOB("01/01/1935,01/01/1965");

		travelQuote.setTravellers(travellers);
		travelQuote.setAdults(2);
		travelQuote.setChildren(1);
		travelQuote.setPolicyType("M");
		travelQuote.setRenderingMode("S");
        travelRequest.setTravel(travelQuote);
	}

	@Test
	public void testShouldSetCorrelationId() throws TravelServiceException {
		String verticalCode = "travel";
		Brand brand = new Brand();
		travelRequest.setTransactionId(1000L);
		travelRequest.setTravel(travelQuote);
		when(connection.get(null + "/quote")).thenReturn("result");
		travelService.getQuotes(brand, verticalCode, travelRequest);
		verify(connection, times(1)).setHasCorrelationId(true);
	}


	@Test
	public void testShouldValidateName() throws SQLException, DaoException {

		// Set defaults for mandatory fields
        travelQuote.setAdults(1);
        travelQuote.setChildren(1);

		travellers = new Travellers();
		travellers.setTravellersDOB("01/01/1985");
		travelQuote.setTravellers(travellers);

		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		boolean valid = travelService.isValid();
		assertTrue(valid);

        travelQuote.setFirstName("test");
        travelQuote.setSurname(null);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

        travelQuote.setFirstName(null);
        travelQuote.setSurname("Test");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

        travelQuote.setFirstName("test");
        travelQuote.setSurname("Test");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

        travelQuote.setFirstName("test??");
        travelQuote.setSurname("Test");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

        travelQuote.setFirstName("test");
        travelQuote.setSurname("Test??");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

        travelQuote.setFirstName("test??");
        travelQuote.setSurname("Test??");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertEquals(2, validationErrors.size());

        travelQuote.setFirstName("test");
        travelQuote.setSurname("O'Test-you");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());
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
		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

        travelRequest.getQuote().setDestination("BOB,ABC");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

        travelRequest.getQuote().setDestination("BOB,ABC,TED");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		// INVALID TEST CASES
        travelRequest.getQuote().setDestination("bob");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

        travelRequest.getQuote().setDestination("BOB,TED,");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

        travelRequest.getQuote().setDestination("BOB,TED, HI");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

        travelRequest.getQuote().setDestination("bob,bob1-sfhs3-dfk");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

        travelRequest.getQuote().setDestination("1");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		// check for blank fields
        travelRequest.getQuote().setDestination("");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

        travelRequest.getQuote().setDestination(" ");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());
	}

	@Test
	public void testShouldValidateCurrentJourney() throws SQLException, DaoException {

		// Set defaults
        travelQuote.setAdults(1);
        travelQuote.setChildren(1);

		travellers = new Travellers();
		travellers.setTravellersDOB("01/01/1985");
		travelQuote.setTravellers(travellers);

		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

		travelRequest.getQuote().setCurrentJourney("gggg");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

        travelRequest.getQuote().setCurrentJourney("g3");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

        travelRequest.getQuote().setCurrentJourney("3g");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());

        travelRequest.getQuote().setCurrentJourney("36");
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());


	}

	@Test
	public void testShouldCheckForMandatoryValues() throws SQLException, DaoException {

		List<SchemaValidationError> validationErrors = travelService.validateRequest(travelRequest, vertical);

		travelQuote.setAdults(null);
		travelQuote.setChildren(null);

		travelQuote.setTravellers(null);
		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertFalse(travelService.isValid());

		// Set defaults
        travelQuote.setAdults(1);
        travelQuote.setChildren(1);

		travellers = new Travellers();
		travellers.setTravellersDOB("01/01/1985");
		travelQuote.setTravellers(travellers);

		validationErrors = travelService.validateRequest(travelRequest, vertical);
		assertTrue(travelService.isValid());


	}


}