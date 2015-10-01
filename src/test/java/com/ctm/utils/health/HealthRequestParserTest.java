package com.ctm.utils.health;

import com.ctm.services.RequestService;
import com.disc_au.web.go.Data;
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
        String vertical = "health";
        Data data = new Data();
        RequestService requestService = new RequestService( httpRequest,  vertical,  data);
        healthRequestParser.getHealthRequestToken( httpRequest,  requestService);

    }

    @Test
    public void testIsCallCentre() throws Exception {
        HealthRequestParser.isCallCentre(httpRequest);
    }
}