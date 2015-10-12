package com.ctm.utils;

import com.ctm.test.TestHttpSession;
import org.junit.Test;

import javax.servlet.http.HttpSession;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;


public class SessionUtilsTest {

    @Test
    public void testIsCallCentre() throws Exception {
        HttpSession session = new TestHttpSession();
        assertFalse(SessionUtils.isCallCentre(session));

        SessionUtils.setIsCallCentre(session, true);

        assertTrue(SessionUtils.isCallCentre(session));

        SessionUtils.setIsCallCentre(session, false);

        assertFalse(SessionUtils.isCallCentre(session));
    }

}