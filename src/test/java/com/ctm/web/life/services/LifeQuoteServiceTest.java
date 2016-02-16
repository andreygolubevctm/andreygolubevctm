package com.ctm.web.life.services;

import com.ctm.data.common.TestMariaDbBean;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.RestClient;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.life.form.model.LifeQuoteWebRequest;
import com.ctm.web.life.form.response.model.LifeResultsWebResponse;
import com.ctm.web.life.model.LifeQuoteResponse;
import com.ctm.web.life.quote.adapter.LifeQuoteServiceResponseAdapter;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.*;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = {
        TestMariaDbBean.class,
        LifeQuoteService.class,
        LifeQuoteServiceTest.class,
        SessionDataServiceBean.class,
        ProviderFilterDao.class,
        TestConfig.class})
@ActiveProfiles({"test"})
@WebAppConfiguration
public class LifeQuoteServiceTest {

    private static final Long TRANSACTION_ID = 100000L;
    @Mock
    private Brand brand;
    @Mock
    private Vertical vertical;
    @Mock
    private ServiceConfiguration serviceConfig;

    private RestClient restClient = TestConfig.getRestClient();
    private ServiceConfigurationService serviceConfigurationService = TestConfig.getServiceConfigurationService();
    private LifeQuoteServiceResponseAdapter lifeQuoteServiceResponseAdapter = TestConfig.getLifeQuoteServiceResponseAdapter();

    @Autowired
    private LifeQuoteService service;
    LifeQuoteWebRequest webRequest = new LifeQuoteWebRequest();
    LifeResultsWebResponse lifeResult = new LifeResultsWebResponse();

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.initMocks(this);
        when(brand.getVerticalByCode(anyString())).thenReturn(vertical);
        when(serviceConfigurationService.getServiceConfiguration(eq("quoteServiceBER"), anyObject())).thenReturn(serviceConfig);
        webRequest.setTransactionId(TRANSACTION_ID);
    }

    @Test
    public void shouldCallService() throws Exception {
        LifeQuoteResponse response = new LifeQuoteResponse();
        when(lifeQuoteServiceResponseAdapter.adapt(response, webRequest)).thenReturn(lifeResult);

        Endpoint endpoint = Endpoint.QUOTE;
        when(restClient.sendPOSTRequest(anyObject(), eq(endpoint), eq(LifeQuoteResponse.class),
                anyObject()))
                .thenReturn(response);

        LifeResultsWebResponse result = service.getQuotes( webRequest,  brand);

        verify(restClient).sendPOSTRequest(anyObject(), eq(endpoint), eq(LifeQuoteResponse.class),
                anyObject());
        assertEquals(lifeResult , result);

    }

    @After
    public void tearDown() throws Exception {
        TestConfig.reset();
    }
}