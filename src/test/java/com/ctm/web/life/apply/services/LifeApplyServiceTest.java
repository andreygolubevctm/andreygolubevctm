package com.ctm.web.life.apply.services;

import com.ctm.data.common.TestMariaDbBean;
import com.ctm.web.core.Application;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.apply.response.LifeApplyWebResponseModel;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;


@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = {Application.class,TestMariaDbBean.class, LifeApplyService.class, LifeApplyServiceTest.class})
@ActiveProfiles({"test"})
@ComponentScan({"com.ctm.web.core"})
public class LifeApplyServiceTest {

    private static final Long TRANSACTION_ID = 100000L;
    @Mock
    private ProviderFilterDao providerFilterDAO;
    @Mock
    private ObjectMapper objectMapper;
    @Mock
    SessionDataServiceBean sessionDataService;
    @Mock
    private LifeApplyPostRequestPayload model;
    @Mock
    private Brand brand;
    @Mock
    private HttpServletRequest request;

    @Autowired
    private LifeApplyService service;

    @Test
    public void shouldCallService() throws Exception {
        LifeApplyWebResponseModel result = service.apply( model,  brand,  request);
        assertEquals(TRANSACTION_ID , result.getTransactionId());

    }
}