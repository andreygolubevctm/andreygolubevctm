package com.ctm.utils.travel;

import com.ctm.utils.SessionDataUtils;
import com.disc_au.web.go.Data;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by lbuchanan on 19/12/2014.
 */
public class SessionDataUtilsTest {

    @Test
    public void shouldGetTransactionIdFromDataBucket(){
        Data data = new Data();
        data.put("current/transactionId" , "10000");
        Long result = SessionDataUtils.getTransactionIdFromTransactionSessionData(data);
        assertEquals(Long.valueOf(10000L) , Long.valueOf(result));

        data = new Data();
        data.put("current/transactionId" , "meerkat");
        result = SessionDataUtils.getTransactionIdFromTransactionSessionData(data);
        assertEquals(Long.valueOf(0L) , Long.valueOf(result));
    }

}
