package com.ctm.web.core.utils.health;

import com.ctm.web.core.services.RequestService;
import com.ctm.web.health.utils.HealthRequestParser;
import com.ctm.web.core.web.go.Data;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class HealthRequestParserTest {

    private HttpServletRequest httpRequest;

    @Before
    public void setup(){
        httpRequest = mock(HttpServletRequest.class);
        HttpSession session = mock(HttpSession.class);
        when(httpRequest.getSession()).thenReturn(session);
    }

    @Test
    public void testGetHealthRequestToken() throws Exception {
        HealthRequestParser healthRequestParser = new HealthRequestParser();
        Data data = new Data();
        RequestService requestService = new RequestService( httpRequest,  "",  data);
        healthRequestParser.getHealthRequestToken(requestService, false);

    }

}