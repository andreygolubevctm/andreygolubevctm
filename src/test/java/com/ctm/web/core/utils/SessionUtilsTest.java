package com.ctm.web.core.utils;

import com.ctm.test.TestHttpSession;
import org.junit.Test;

import javax.servlet.http.HttpSession;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;


public class SessionUtilsTest {

    @Test
    public void testIsCallCentreBooleanInSessions() throws Exception {
        HttpSession session = new TestHttpSession();
        assertFalse(SessionUtils.isCallCentre(session));

        SessionUtils.setIsCallCentre(session, true);

        assertTrue(SessionUtils.isCallCentre(session));

        SessionUtils.setIsCallCentre(session, false);

        assertFalse(SessionUtils.isCallCentre(session));
    }


    @Test
    public void testIsCallCentreStringInSession() throws Exception {
        HttpSession session = new TestHttpSession();
        assertFalse(SessionUtils.isCallCentre(session));

        session.setAttribute(SessionUtils.CALL_CENTRE_ATTR, "true");
        assertTrue(SessionUtils.isCallCentre(session));

        session.setAttribute(SessionUtils.CALL_CENTRE_ATTR, "false");

        assertFalse(SessionUtils.isCallCentre(session));
    }

}