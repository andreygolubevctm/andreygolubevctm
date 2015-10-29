package com.ctm.factory;

import com.ctm.model.email.EmailMode;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.email.EmailServiceHandler;
import com.ctm.web.health.services.email.HealthEmailService;
import com.ctm.test.TestUtils;
import com.disc_au.web.go.Data;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

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
