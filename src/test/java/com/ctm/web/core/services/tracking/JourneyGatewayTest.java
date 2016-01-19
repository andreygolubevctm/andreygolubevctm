package com.ctm.web.core.services.tracking;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.SettingsService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest({JourneyGateway.class, SettingsService.class})
public class JourneyGatewayTest {

    @Mock
    private PageSettings pageSettings;
    @Mock
    private Random random;
    @Mock
    private HttpServletRequest request;
    @Mock
    private HttpServletResponse response;

    @Before
    public void setup() throws Exception {
        PowerMockito.mockStatic(SettingsService.class);
        when(pageSettings.getBaseUrl()).thenReturn("http://localhost:8080/ctm/");
    }

    @Test
    public void calculateJValueRangeBelow50Test() throws Exception {

        PowerMockito.whenNew(Random.class).withNoArguments().thenReturn(random);
        when(random.nextInt(99)).thenReturn(25);

        String splitTestRef = "optins";
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_COUNT))
                .thenReturn("2");
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + "_1" + JourneyGateway.LABEL_SUFFIX_RANGE))
                .thenReturn("50");
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + "_1" + JourneyGateway.LABEL_SUFFIX_JVAL))
                .thenReturn("1");
        final String s = JourneyGateway.calculateJValue(pageSettings, splitTestRef);
        assertEquals("1", s);
    }

    @Test
    public void calculateJValueRangeAbove50Test() throws Exception {

        PowerMockito.whenNew(Random.class).withNoArguments().thenReturn(random);
        when(random.nextInt(99)).thenReturn(75);

        String splitTestRef = "optins";
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_COUNT))
                .thenReturn("2");
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + "_1" + JourneyGateway.LABEL_SUFFIX_RANGE))
                .thenReturn("50");
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + "_2" + JourneyGateway.LABEL_SUFFIX_RANGE))
                .thenReturn("100");
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + "_2" + JourneyGateway.LABEL_SUFFIX_JVAL))
                .thenReturn("2");
        final String s = JourneyGateway.calculateJValue(pageSettings, splitTestRef);
        assertEquals("2", s);
    }

    @Test
    public void getJourneyHasRequestJValue() throws Exception {
        PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);

        String splitTestRef = "optins";

        final Vertical vertical = mock(Vertical.class);
        when(vertical.getCode()).thenReturn("health");
        when(pageSettings.getVertical()).thenReturn(vertical);

        when(pageSettings.hasSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn(true);
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn("Y");

        when(request.getParameter(JourneyGateway.J_PARAMETER)).thenReturn("40");
        Map<String, String[]> parameters = new HashMap<>();
        parameters.put(JourneyGateway.J_PARAMETER, new String[]{"40"});
        when(request.getParameterMap()).thenReturn(parameters);

        final String url = JourneyGateway.getJourney(request, splitTestRef, response);
        assertNull(url);

        verify(response, times(1)).addCookie(any());
    }

    @Test
    public void getJourneyHasEmptyRequestJValue() throws Exception {
        PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);

        String splitTestRef = "optins";

        final Vertical vertical = mock(Vertical.class);
        when(vertical.getCode()).thenReturn("health");
        when(pageSettings.getVertical()).thenReturn(vertical);

        when(pageSettings.hasSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn(true);
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn("Y");

        when(request.getParameter(JourneyGateway.J_PARAMETER)).thenReturn("");
        Map<String, String[]> parameters = new HashMap<>();
        parameters.put(JourneyGateway.J_PARAMETER, new String[]{""});
        when(request.getParameterMap()).thenReturn(parameters);
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://localhost:8080"));
        when(request.getQueryString()).thenReturn("param1=1&param2=2");

        final String url = JourneyGateway.getJourney(request, splitTestRef, response);
        assertEquals("http://localhost:8080/ctm/health_quote_v2.jsp?param1=1&param2=2&j=1", url);

        verify(response, times(1)).addCookie(any());
    }

    @Test
    public void getJourneyHasCookieJValue() throws Exception {
        PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);

        String splitTestRef = "optins";

        String verticalCode = "health";

        final Vertical vertical = mock(Vertical.class);
        when(vertical.getCode()).thenReturn(verticalCode);
        when(pageSettings.getVertical()).thenReturn(vertical);

        when(pageSettings.hasSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn(true);
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn("Y");

        when(request.getCookies()).thenReturn(new Cookie[]{new Cookie(JourneyGateway.COOKIE_LABEL_PREFIX + splitTestRef + verticalCode, "30")});

        when(request.getRequestURL()).thenReturn(new StringBuffer("http://localhost:8080"));
        when(request.getQueryString()).thenReturn("param1=1&param2=2");

        final String url = JourneyGateway.getJourney(request, splitTestRef, response);
        assertEquals("http://localhost:8080/ctm/health_quote_v2.jsp?param1=1&param2=2&j=30", url);

        verify(response, times(1)).addCookie(any());
    }

    @Test
    public void getJourneyNoJValue() throws Exception {
        PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);

        String splitTestRef = "optins";

        String verticalCode = "health";

        final Vertical vertical = mock(Vertical.class);
        when(vertical.getCode()).thenReturn(verticalCode);
        when(pageSettings.getVertical()).thenReturn(vertical);

        when(pageSettings.hasSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn(true);
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn("Y");

        when(request.getRequestURL()).thenReturn(new StringBuffer("http://localhost:8080"));
        when(request.getQueryString()).thenReturn("param1=1&param2=2");

        PowerMockito.whenNew(Random.class).withNoArguments().thenReturn(random);
        when(random.nextInt(99)).thenReturn(75);

        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_COUNT))
                .thenReturn("2");
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + "_1" + JourneyGateway.LABEL_SUFFIX_RANGE))
                .thenReturn("50");
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + "_2" + JourneyGateway.LABEL_SUFFIX_RANGE))
                .thenReturn("100");
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + "_2" + JourneyGateway.LABEL_SUFFIX_JVAL))
                .thenReturn("70");


        final String url = JourneyGateway.getJourney(request, splitTestRef, response);
        assertEquals("http://localhost:8080/ctm/health_quote_v2.jsp?param1=1&param2=2&j=70", url);

        verify(response, times(1)).addCookie(any());
    }

    @Test
    public void getJourneyNotSplitTest() throws Exception {
        PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);

        String splitTestRef = "optins";

        String verticalCode = "health";

        final Vertical vertical = mock(Vertical.class);
        when(vertical.getCode()).thenReturn(verticalCode);
        when(pageSettings.getVertical()).thenReturn(vertical);

        when(pageSettings.hasSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn(false);
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn("N");

        when(request.getRequestURL()).thenReturn(new StringBuffer("http://localhost:8080"));
        when(request.getQueryString()).thenReturn("param1=1&param2=2");

        final String url = JourneyGateway.getJourney(request, splitTestRef, response);
        assertEquals("http://localhost:8080/ctm/health_quote_v2.jsp?param1=1&param2=2&j=1", url);

        verify(response, times(1)).addCookie(any());
    }

    @Test
    public void getJourneyNotSplitTestWithRequestJValue() throws Exception {
        PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);

        String splitTestRef = "optins";

        String verticalCode = "health";

        final Vertical vertical = mock(Vertical.class);
        when(vertical.getCode()).thenReturn(verticalCode);
        when(pageSettings.getVertical()).thenReturn(vertical);

        when(pageSettings.hasSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn(false);
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn("N");

        when(request.getRequestURL()).thenReturn(new StringBuffer("http://localhost:8080"));
        when(request.getQueryString()).thenReturn("param1=1&param2=2&j=");

        when(request.getParameter(JourneyGateway.J_PARAMETER)).thenReturn("");
        Map<String, String[]> parameters = new HashMap<>();
        parameters.put(JourneyGateway.J_PARAMETER, new String[]{""});
        when(request.getParameterMap()).thenReturn(parameters);

        final String url = JourneyGateway.getJourney(request, splitTestRef, response);
        assertEquals("http://localhost:8080/ctm/health_quote_v2.jsp?param1=1&param2=2&j=1", url);

        verify(response, times(1)).addCookie(any());
    }

    @Test
    public void getJourneyNotSplitTestWithRequestJValue40() throws Exception {
        PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);

        String splitTestRef = "optins";

        String verticalCode = "health";

        final Vertical vertical = mock(Vertical.class);
        when(vertical.getCode()).thenReturn(verticalCode);
        when(pageSettings.getVertical()).thenReturn(vertical);

        when(pageSettings.hasSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn(false);
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn("N");

        when(request.getRequestURL()).thenReturn(new StringBuffer("http://localhost:8080"));
        when(request.getQueryString()).thenReturn("param1=1&param2=2&j=40");

        when(request.getParameter(JourneyGateway.J_PARAMETER)).thenReturn("40");
        Map<String, String[]> parameters = new HashMap<>();
        parameters.put(JourneyGateway.J_PARAMETER, new String[]{"40"});
        when(request.getParameterMap()).thenReturn(parameters);

        final String url = JourneyGateway.getJourney(request, splitTestRef, response);
        assertNull(url);

        verify(response, times(1)).addCookie(any());
    }

    @Test
    public void getJourneyNotSplitTestWithRequestJValueNoRedirect() throws Exception {
        PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);

        String splitTestRef = "optins";

        String verticalCode = "health";

        final Vertical vertical = mock(Vertical.class);
        when(vertical.getCode()).thenReturn(verticalCode);
        when(pageSettings.getVertical()).thenReturn(vertical);

        when(pageSettings.hasSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn(false);
        when(pageSettings.getSetting(JourneyGateway.LABEL_PREFIX + splitTestRef + JourneyGateway.LABEL_SUFFIX_ACTIVE))
                .thenReturn("N");

        when(request.getRequestURL()).thenReturn(new StringBuffer("http://localhost:8080"));
        when(request.getQueryString()).thenReturn("param1=1&param2=2&j=1");

        when(request.getParameter(JourneyGateway.J_PARAMETER)).thenReturn("1");
        Map<String, String[]> parameters = new HashMap<>();
        parameters.put(JourneyGateway.J_PARAMETER, new String[]{"1"});
        when(request.getParameterMap()).thenReturn(parameters);

        final String url = JourneyGateway.getJourney(request, splitTestRef, response);
        assertNull(url);

        verify(response, times(1)).addCookie(any());
    }

}