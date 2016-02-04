package com.ctm.web.life.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.life.model.request.LifePerson;
import com.ctm.web.life.model.request.LifeRequest;
import com.ctm.web.life.model.request.Primary;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class LifeServiceTest {

	private static final String vertical = "ip";
	private Primary.Builder primaryB;
	private LifePerson.Builder partnerB;
	private LifeService lifeService;
	private String validOccupation = "425813bb3eb10ecd2ec9ad4bcb16efc19813ecd8";

	@Before
	public void setup() throws Exception {
		primaryB = new Primary.Builder();
		partnerB = new LifePerson.Builder();
		lifeService = new LifeService();
	}

	@Test
	public void testShouldValidateNullOccupation() throws SQLException, DaoException {
		primaryB.occupation(null);
		partnerB.occupation(null);
		LifeRequest lifeRequest = getLifeRequest();
		lifeService.contactLead(lifeRequest, vertical);
		boolean valid = lifeService.isValid();
		assertTrue(valid);
	}

	@Test
	public void testShouldValidateInvalidOccupationPrimary() throws SQLException, DaoException {
		primaryB.occupation("test");
		partnerB.occupation(null);
		LifeRequest lifeRequest = getLifeRequest();
		List<SchemaValidationError> validationErrors = lifeService.contactLead(lifeRequest, vertical);
		assertEquals(1, validationErrors.size());
	}
	@Test
	public void testShouldValidateOccupation() throws SQLException, DaoException {
		primaryB.occupation(validOccupation);
		partnerB.occupation(validOccupation);
		LifeRequest lifeRequest = getLifeRequest();
		List<SchemaValidationError> validationErrors = lifeService.contactLead(lifeRequest, vertical);
		assertEquals(0, validationErrors.size());

		primaryB.occupation(null);
		partnerB.occupation(validOccupation);
		 lifeRequest = getLifeRequest();
		validationErrors = lifeService.contactLead(lifeRequest, vertical);
		assertEquals(0, validationErrors.size());


		primaryB.occupation(validOccupation);
		partnerB.occupation(null);
		 lifeRequest = getLifeRequest();
		validationErrors = lifeService.contactLead(lifeRequest, vertical);
		assertEquals(0, validationErrors.size());


		primaryB.occupation("invalid");
		partnerB.occupation(validOccupation);
		 lifeRequest = getLifeRequest();
		validationErrors = lifeService.contactLead(lifeRequest, vertical);
		assertEquals(1, validationErrors.size());
	}

	private LifeRequest getLifeRequest() {
		LifeRequest.Builder lifeRequestBuilder = new LifeRequest.Builder();
		Primary primary =primaryB.build();
		LifePerson partner = partnerB.build();
		return lifeRequestBuilder.partner(partner).primary(primary).build();
	}

}
