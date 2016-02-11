package com.ctm.web.life.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.data.common.TestMariaDbBean;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.apply.exceptions.FailedToRegisterException;
import com.ctm.web.core.Application;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.RestClient;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.apply.model.request.LifeApplyWebRequest;
import com.ctm.web.life.apply.response.LifeApplyWebResponse;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.web.WebAppConfiguration;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


@RunWith(MockitoJUnitRunner.class)
@SpringApplicationConfiguration(classes = {Application.class,TestMariaDbBean.class, LifeApplyService.class, LifeApplyServiceTest.class})
@ActiveProfiles({"test"})
@ComponentScan({"com.ctm.web.core"})
@WebAppConfiguration
public class LifeApplyServiceTest {

    private static final Long TRANSACTION_ID = 100000L;
    @Mock
    private ProviderFilterDao providerFilterDAO;
    @Mock
    private RestClient restClient;
    @Mock
    private SessionDataServiceBean sessionDataService;
    @Mock
    private Brand brand;
    @Mock
    private HttpServletRequest request;
    @Mock
    SessionData sessionData;
    @Mock
    ServiceConfigurationService serviceConfigurationService;
    @Mock
    private com.ctm.web.core.model.settings.ServiceConfiguration serviceConfiguration;
    @Mock
    private com.ctm.web.core.model.settings.Vertical vertical;
    @Mock
    private LifeApplyResponse response;

    private LifeApplyService service;
    @Mock
    private LifeApplyCompleteService lifeApplyCompleteService;
    @Mock
    private ApplyResponse applyResponse;


    @Before
    public void setUp() throws Exception {
        service = new LifeApplyService( providerFilterDAO,  restClient,
                 sessionDataService,
                 serviceConfigurationService,
                EnvironmentService.Environment.LOCALHOST,
                 lifeApplyCompleteService);
         when(sessionDataService.getSessionDataFromSession(request)).thenReturn(sessionData);
         Data data = getData();
         when(sessionData.getSessionDataForTransactionId(TRANSACTION_ID)).thenReturn(data);
        when(brand.getVerticalByCode(anyString())).thenReturn(vertical);
        when(serviceConfigurationService.getServiceConfiguration(anyString(), anyObject())).thenReturn(serviceConfiguration);
        when(restClient.sendPOSTRequest(anyObject(), anyObject(), anyString(), anyObject(), anyObject())).thenReturn(response);
    }

    private Data getData() {
        Data data = new Data();
        data.put("life/primary/insurance/partner" , "Y");
        data.put("life/primary/insurance/samecover" , "Y");
        data.put("life/primary/insurance/term" , "500000");
        data.put("life/primary/insurance/termentry" , "500,000");
        data.put("life/primary/insurance/tpd" , "250000");
        data.put("life/primary/insurance/tpdentry" , "250,000");
        data.put("life/primary/insurance/trauma" , "150000");
        data.put("life/primary/insurance/traumaentry" , "150,000");
        data.put("life/primary/insurance/tpdanyown" , "A");
        data.put("life/partner/insurance/term" , "200000");
        data.put("life/partner/insurance/termentry" , "200,000");
        data.put("life/partner/insurance/tpd" , "125000");
        data.put("life/partner/insurance/tpdentry" , "125,000");
        data.put("life/partner/insurance/trauma" , "75000");
        data.put("life/partner/insurance/traumaentry" , "75,000");
        data.put("life/partner/insurance/tpdanyown" , "A");
        data.put("life/primary/insurance/frequency" , "M");
        data.put("life/primary/insurance/type" , "S");
        data.put("life/primary/firstName" , "Joe");
        data.put("life/primary/lastname" , "Blogs");
        data.put("life/primary/gender" , "M");
        data.put("life/primary/dob" , "25/01/1967");
        data.put("life/primary/age" , "50");
        data.put("life/primary/smoker" , "N");
        data.put("life/primary/occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
        data.put("life/primary/hannover" , "1");
        data.put("life/primary/occupationTitle" , "Accountant - Qualified (professionally or degree)");
        data.put("life/partner/firstName" , "Josephine");
        data.put("life/partner/lastname" , "Bloggs");
        data.put("life/partner/gender" , "F");
        data.put("life/partner/dob" , "11/07/1971");
        data.put("life/partner/age" , "45");
        data.put("life/partner/smoker" , "N");
        data.put("life/partner/occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71");
        data.put("life/partner/hannover" , "1");
        data.put("life/partner/occupationTitle" , "Accountant - Qualified (professionally or degree)");
        data.put("life/contactDetails/email" , "preload.testing@comparethemarket.com.au");
        data.put("life/contactDetails/contactNumber" , "0400123123");
        data.put("life/contactDetails/contactNumberinput" , "(0400) 123 123");
        data.put("life/primary/state" , "QLD");
        data.put("life/primary/postCode" , "4007");
        data.put("life_privacyoptin" , "Y");
        data.put("life/contactDetails/call" , "Y");
        data.put("life/splitTestingJourney" , "0");
        data.put("life/refine/insurance/type" , "primary");
        return data;
    }

    @Test
    public void shouldCallServiceAndReturnTransactionId() throws Exception {
        LifeApplyWebRequest webRequest = new LifeApplyWebRequest();
        webRequest.setTransactionId(TRANSACTION_ID);
        webRequest.setVertical("life");
        LifeApplyWebResponse result = service.apply( webRequest,  brand,  request);
        verify(restClient).sendPOSTRequest(anyObject(), anyObject(), anyString(), anyObject(), anyObject());
        assertEquals(TRANSACTION_ID , result.getResults().getTransactionId());

    }

    @Test
    public void shouldMapException() throws Exception {
        FailedToRegisterException e = new FailedToRegisterException( applyResponse,  TRANSACTION_ID);
        ErrorInfo result = service.mapException( e);
        assertEquals(TRANSACTION_ID , result.getTransactionId());

    }
}