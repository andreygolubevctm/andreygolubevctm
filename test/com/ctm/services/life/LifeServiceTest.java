package com.ctm.services.life;

import static org.junit.Assert.*;

import java.sql.SQLException;
import java.util.List;

import static org.mockito.Mockito.*;

import com.ctm.services.RequestService;
import org.junit.Test;

import com.ctm.exceptions.DaoException;
import com.ctm.model.request.life.LifePerson;
import com.ctm.model.request.life.LifeRequest;
import com.ctm.web.validation.SchemaValidationError;

import javax.servlet.http.HttpServletRequest;

public class LifeServiceTest {

	private static final String vertical = "ip";

	@Test
	public void testShouldValidateOccupation() throws SQLException, DaoException {
		RequestService fromFormService = mock(RequestService.class);
		String validOccupation = "425813bb3eb10ecd2ec9ad4bcb16efc19813ecd8";

		LifeService lifeService = new LifeService();
		LifeRequest lifeRequest = new LifeRequest();
		lifeRequest.primary = new LifePerson();
		lifeRequest.partner = new LifePerson();

		lifeRequest.primary.occupation = null;
		lifeRequest.partner.occupation = null;
		HttpServletRequest request = mock(HttpServletRequest.class);
		lifeService.contactLead(lifeRequest, vertical, fromFormService);
		boolean valid = lifeService.isValid();
		assertTrue(valid);

		lifeRequest.primary.occupation = "test";
		lifeRequest.partner.occupation = null;

		List<SchemaValidationError> validationErrors = lifeService.contactLead(lifeRequest, vertical, fromFormService);
		assertEquals(1, validationErrors.size());

		lifeRequest.primary.occupation = null;
		lifeRequest.partner.occupation = "test";
		validationErrors = lifeService.contactLead(lifeRequest, vertical, fromFormService);
		assertEquals(1, validationErrors.size());

		lifeRequest.primary.occupation = validOccupation;
		lifeRequest.partner.occupation = validOccupation;
		validationErrors = lifeService.contactLead(lifeRequest, vertical, fromFormService);

		assertEquals(0, validationErrors.size());

		lifeRequest.primary.occupation = null;
		lifeRequest.partner.occupation = validOccupation;
		validationErrors = lifeService.contactLead(lifeRequest, vertical, fromFormService);
		assertEquals(0, validationErrors.size());

		lifeRequest.primary.occupation = validOccupation;
		lifeRequest.partner.occupation = null;
		validationErrors = lifeService.contactLead(lifeRequest, vertical, fromFormService);
		assertEquals(0, validationErrors.size());

		lifeRequest.primary.occupation = "invalid";
		lifeRequest.partner.occupation = validOccupation;
		validationErrors = lifeService.contactLead(lifeRequest, vertical, fromFormService);
		assertEquals(1, validationErrors.size());
	}

}
