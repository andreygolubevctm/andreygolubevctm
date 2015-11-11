package com.ctm.web;

import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.utils.SessionUtils;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertFalse;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.when;


public class NewPageTest {

    private PageSettings pageSettings = new PageSettings();
    @Mock
    private HttpServletRequest request;

    @Mock
    Vertical vertical;

    @Mock
    private javax.servlet.http.HttpSession session;
    private NewPage newPage;

    @Before
    public void setup(){
        initMocks(this);
        pageSettings.setVertical(vertical);
        when(vertical.getSettingValueForName("jwtEnabled")).thenReturn("true");
        when(request.getSession()).thenReturn(session);
        newPage= new NewPage();
    }

    @Test
    public void shouldReturnFalseForTokenEnabledIfCallCentre() throws Exception {
        when(session.getAttribute(SessionUtils.CALL_CENTRE_ATTR)).thenReturn("true");
        newPage.init(request , pageSettings);
        assertFalse(newPage.isTokenEnabled());

    }

    @Test
    public void shouldReturnTrueForTokenEnabledIfNotCallCentre() throws Exception {
        when(session.getAttribute(SessionUtils.CALL_CENTRE_ATTR)).thenReturn("false");
        newPage= new NewPage();
        newPage.init(request , pageSettings);
        assertTrue(newPage.isTokenEnabled());
    }
}