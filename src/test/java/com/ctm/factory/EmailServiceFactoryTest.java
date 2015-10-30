package com.ctm.factory;

import com.ctm.web.core.email.model.EmailMode;
import com.ctm.model.settings.PageSettings;
import com.ctm.web.core.email.services.EmailServiceHandler;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.health.services.email.HealthEmailService;
import com.ctm.test.TestUtils;
import com.ctm.web.core.web.go.Data;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class EmailServiceFactoryTest {

	@Test
	public void testShouldGetHealthService() throws Exception {

		PageSettings pageSettings = TestUtils.getCTMHealthPageSettings();
		EmailMode mode = EmailMode.BEST_PRICE;
		Data data = new Data();
		EmailServiceHandler emailServiceHandler = EmailServiceFactory.newInstance(pageSettings, mode, data);
		assertEquals(emailServiceHandler.getClass() , HealthEmailService.class);

	}

}
