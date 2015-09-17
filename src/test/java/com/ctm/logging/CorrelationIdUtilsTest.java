package com.ctm.logging;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class CorrelationIdUtilsTest {

    @Test
    public void shouldSetCorrelationId() throws InterruptedException {
        String corrId = "test";
        String corrId2 = "test2";
        String corrId3 = "test3";
        final boolean[] testThreadOutcome = {false,false};
        CorrelationIdUtils.setCorrelationId(corrId);
        assertEquals(corrId, CorrelationIdUtils.getCorrelationId());
        Thread thread = new Thread(() -> {
            assertEquals(null, CorrelationIdUtils.getCorrelationId());
            CorrelationIdUtils.setCorrelationId(corrId2);
            assertEquals(corrId2, CorrelationIdUtils.getCorrelationId());
            testThreadOutcome[0] = true;
        });
        Thread thread2 = new Thread(() -> {
            assertEquals(null, CorrelationIdUtils.getCorrelationId());
            CorrelationIdUtils.setCorrelationId(corrId3);
            assertEquals(corrId3, CorrelationIdUtils.getCorrelationId());
            testThreadOutcome[1] = true;
        });
        thread.start();
        thread2.start();

        thread.join();
        thread2.join();
        assertEquals(corrId, CorrelationIdUtils.getCorrelationId());
        assertTrue(testThreadOutcome[0]);
        assertTrue(testThreadOutcome[1]);

    }
}