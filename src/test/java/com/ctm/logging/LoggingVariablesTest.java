package com.ctm.logging;

import com.ctm.model.settings.Vertical;
import org.apache.log4j.MDC;
import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class LoggingVariablesTest {

    @Test
    public void testSetLoggingVariables() throws Exception {
        String transactionId = "transactionId";
        String transactionId2 = "transactionId2";
        String brandCode = "brandCode";
        String vertical = "health";
        String correlationId = "correlationId";
        LoggingVariables.setLoggingVariables( transactionId,  brandCode,  vertical,  correlationId);
        assertEquals(transactionId, MDC.get(LoggingVariables.TRANSACTION_ID_KEY));
        assertEquals(brandCode, MDC.get(LoggingVariables.BRAND_CODE_KEY));
        assertEquals(Vertical.VerticalType.HEALTH.getCode(), MDC.get(LoggingVariables.VERTICAL_CODE_KEY));
        assertEquals(correlationId, MDC.get(LoggingVariables.CORRELATION_ID_KEY));
        LoggingVariables.setTransactionId(transactionId2);
        assertEquals(transactionId2, MDC.get(LoggingVariables.TRANSACTION_ID_KEY));

    }
}