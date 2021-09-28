package com.ctm.test.controller;

import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import org.mockito.Mock;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.Matchers.anyBoolean;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.when;

public class BaseControllerTest {

    protected MockMvc mvc;

    @Mock
    protected SessionDataServiceBean sessionDataServiceBean;
    @Mock
    protected IPAddressHandler ipAddressHandler;
    @Mock
    protected ApplicationService applicationService;
    @Mock
    protected com.ctm.web.core.web.go.Data value;

    public void setUp(Object controllerUnderTest) throws Exception {
        when(sessionDataServiceBean.getDataForTransactionId(anyObject(), anyString(), anyBoolean())).thenReturn(value);
        mvc = MockMvcBuilders.standaloneSetup(controllerUnderTest).build();
    }
}
