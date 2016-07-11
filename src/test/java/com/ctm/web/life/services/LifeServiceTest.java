package com.ctm.web.life.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.life.form.model.Applicant;
import com.ctm.web.life.form.model.LifeQuote;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class LifeServiceTest {

	private static final String vertical = "ip";
	private LifeService lifeService;
	private String validOccupation = "425813bb3eb10ecd2ec9ad4bcb16efc19813ecd8";
	private LifeQuote lifeQuote;

	@Before
	public void setup() throws Exception {
		lifeQuote = getLifeQuote();
		lifeService = new LifeService();
	}

	@Test
	public void testShouldValidateNullOccupation() throws Exception {
		lifeQuote.getPrimary().setOccupation(null);
		lifeQuote.getPartner().setOccupation(null);
		lifeService.contactLead(lifeQuote, vertical);
		boolean valid = lifeService.isValid();
		assertTrue(valid);
	}

	@Test
	public void testShouldValidateInvalidOccupationPrimary() throws Exception {
		lifeQuote.getPrimary().setOccupation("test");
		lifeQuote.getPartner().setOccupation(null);
		List<SchemaValidationError> validationErrors = lifeService.contactLead(lifeQuote, vertical);
		assertEquals(1, validationErrors.size());
	}


	@Test
	public void testShouldValidateValidOccupation() throws SQLException, DaoException {
		lifeQuote.getPrimary().setOccupation(validOccupation);
		lifeQuote.getPartner().setOccupation(validOccupation);
		List<SchemaValidationError> validationErrors = lifeService.contactLead(lifeQuote, vertical);
		assertEquals(0, validationErrors.size());

		lifeQuote.getPrimary().setOccupation(null);
		lifeQuote.getPartner().setOccupation(validOccupation);
		validationErrors = lifeService.contactLead(lifeQuote, vertical);
		assertEquals(0, validationErrors.size());


		lifeQuote.getPrimary().setOccupation(validOccupation);
		lifeQuote.getPartner().setOccupation(null);
		validationErrors = lifeService.contactLead(lifeQuote, vertical);
		assertEquals(0, validationErrors.size());
	}

	@Test
	public void testShouldValidateInvalidOccupationFromPrimary() throws SQLException, DaoException {
		lifeQuote.getPrimary().setOccupation("invalid");
		lifeQuote.getPartner().setOccupation(validOccupation);
		List<SchemaValidationError> validationErrors
				= lifeService.contactLead(lifeQuote, vertical);
		assertEquals(1, validationErrors.size());
	}

	private LifeQuote getLifeQuote() {
		LifeQuote lifeQuote = new LifeQuote();
		Applicant primary = new Applicant();
		Applicant partner = new Applicant();
		lifeQuote.setPartner(partner);
		lifeQuote.setPrimary(primary);
		return lifeQuote;
	}

}
