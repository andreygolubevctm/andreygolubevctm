package com.ctm.web.factory;

import com.ctm.test.TestUtils;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailServiceHandler;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.email.services.HealthEmailService;
import com.ctm.web.life.dao.OccupationsDao;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.mockito.MockitoAnnotations.initMocks;

public class EmailServiceFactoryTest {

    @Mock
	private IPAddressHandler ipHandler;
	@Mock
	private OccupationsDao occupationsDao;
    @Mock
    private TransactionDetailsDao transactionDetailsDao;
    @Mock
    private ApplicationService applicationService;

    private EmailServiceFactory emailServiceFactory;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
		 emailServiceFactory = new EmailServiceFactory(occupationsDao, ipHandler,transactionDetailsDao,applicationService);
    }

    @Test
	public void testShouldGetHealthService() throws Exception {
		PageSettings pageSettings = TestUtils.getCTMHealthPageSettings();
		EmailMode mode = EmailMode.BEST_PRICE;
		Data data = new Data();
		EmailServiceHandler emailServiceHandler = emailServiceFactory.newInstance(pageSettings, mode, data);
		Assert.assertEquals(emailServiceHandler.getClass(), HealthEmailService.class);

	}

}
