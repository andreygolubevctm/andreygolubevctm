package com.ctm.web.core.web.core.utils.travel;

import com.ctm.web.core.utils.SessionDataUtils;
import com.ctm.web.core.web.go.Data;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

/**
 * Created by lbuchanan on 19/12/2014.
 */
public class SessionDataUtilsTest {

    @Test
    public void shouldGetTransactionIdFromDataBucket(){
        Data data = new Data();
        data.put("current/transactionId" , "10000");
        Long result = SessionDataUtils.getTransactionId(data);
        assertEquals(Long.valueOf(10000L) , Long.valueOf(result));

        data = new Data();
        data.put("current/transactionId" , "meerkat");
        result = SessionDataUtils.getTransactionId(data);
        assertNull(result);
    }

    @Test
    public void shouldSetTransactionIdToDataBucket(){
        Data data = new Data();
        String transactionId = "10000";
        SessionDataUtils.setTransactionId(data, transactionId);
        assertEquals(transactionId, data.get("current/transactionId"));
    }

}