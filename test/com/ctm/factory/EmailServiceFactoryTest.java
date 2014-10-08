package com.ctm.factory;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import com.ctm.model.settings.PageSettings;
import com.ctm.services.email.EmailServiceHandler;
import com.ctm.services.email.EmailServiceHandler.EmailMode;
import com.ctm.services.email.health.HealthEmailService;
import com.ctm.test.TestUtils;
import com.disc_au.web.go.Data;

public class EmailServiceFactoryTest {

	@Test
	public void testShouldGetHealthService() throws Exception {

		PageSettings pageSettings = TestUtils.getCTMHealthPageSettings();
		EmailMode mode = EmailMode.BEST_PRICE;
		Data data = new Data();
		EmailServiceHandler emailServiceHandler = EmailServiceFactory.newInstance(pageSettings, mode, data );
		assertEquals(emailServiceHandler.getClass() , HealthEmailService.class);

	}

}
