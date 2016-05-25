package com.ctm.web.core.model.session;

import com.ctm.web.core.utils.SessionDataUtils;
import com.ctm.web.core.web.go.Data;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class SessionDataTest {

    @Test
    public void shouldGetSessionDataForTransactionId(){
        String id = "10000";
        SessionData sessionData = new SessionData();
        Data data = sessionData.addTransactionDataInstance();
        SessionDataUtils.setTransactionId(data , id);
        Data result = sessionData.getSessionDataForTransactionId(id);
        assertEquals(id,String.valueOf(SessionDataUtils.getTransactionId(result)));
    }

    @Test
    public void shouldGetSessionDataForTransactionIdZero(){
        String id = "0";
        SessionData sessionData = new SessionData();
        Data data = sessionData.addTransactionDataInstance();
        Data result = sessionData.getSessionDataForTransactionId(id);
        assertEquals(data, result);
    }

}