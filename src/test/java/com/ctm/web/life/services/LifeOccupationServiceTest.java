package com.ctm.web.life.services;

import com.ctm.data.common.TestMariaDbBean;
import com.ctm.life.occupation.model.response.Occupation;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.RestClient;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.life.form.response.model.LifeResultsWebResponse;
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

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = {
        TestMariaDbBean.class,
        LifeOccupationService.class,
        LifeOccupationServiceTest.class,
        SessionDataServiceBean.class,
        ProviderFilterDao.class,
        TestConfig.class})
@ActiveProfiles({"test"})
@WebAppConfiguration
public class LifeOccupationServiceTest {

    @Mock
    private Brand brand;
    @Mock
    private Vertical vertical;
    @Mock
    private ServiceConfiguration serviceConfig;

    private RestClient restClient = TestConfig.getRestClient();
    private ServiceConfigurationServiceBean serviceConfigurationServiceBean = TestConfig.getServiceConfigurationServiceBean();

    @Autowired
    private LifeOccupationService service;
    LifeResultsWebResponse lifeResult = new LifeResultsWebResponse();

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.initMocks(this);
        when(brand.getVerticalByCode(anyString())).thenReturn(vertical);
        when(serviceConfigurationServiceBean.getServiceConfiguration(eq("quoteServiceBER"), anyObject())).thenReturn(serviceConfig);
    }

    @Test
    public void shouldCallService() throws Exception {
        List<Occupation> response = new ArrayList<>();
        Occupation occupation = new Occupation.Builder().build();
        response.add(occupation);

        when(restClient.sendGETRequest(anyObject(), anyObject(), (com.fasterxml.jackson.core.type.TypeReference) anyObject(), anyObject()))
                .thenReturn(response);

        List<Occupation> result = service.getOccupations(brand);


        verify(restClient).sendGETRequest(anyObject(), anyObject(), (com.fasterxml.jackson.core.type.TypeReference) anyObject(), anyObject());
        assertEquals(response , result);

    }

    @After
    public void tearDown() throws Exception {
        TestConfig.reset();
    }
}