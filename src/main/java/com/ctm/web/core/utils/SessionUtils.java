package com.ctm.web.core.utils;


import javax.servlet.http.HttpSession;

public class SessionUtils {
    public static final String CALL_CENTRE_ATTR = "callCentre";

    public static boolean isCallCentre(HttpSession session) {
        Object isCallCentreObj = session.getAttribute(CALL_CENTRE_ATTR);
        if(isCallCentreObj instanceof Boolean){
            return (Boolean) isCallCentreObj;
        }
        return false;
    }

    public static void setIsCallCentre(HttpSession session, boolean isCallCentre) {
        session.setAttribute(CALL_CENTRE_ATTR, isCallCentre);
    }
}
