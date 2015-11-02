package com.ctm.web.core.logging;

import org.junit.Test;

import static junit.framework.TestCase.assertFalse;
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
        assertEquals(corrId, CorrelationIdUtils.getCorrelationId().get());
        Thread thread = new Thread(() -> {
            assertFalse(CorrelationIdUtils.getCorrelationId().isPresent());
            CorrelationIdUtils.setCorrelationId(corrId2);
            assertEquals(corrId2, CorrelationIdUtils.getCorrelationId().get());
            testThreadOutcome[0] = true;
        });
        Thread thread2 = new Thread(() -> {
            assertFalse(CorrelationIdUtils.getCorrelationId().isPresent());
            CorrelationIdUtils.setCorrelationId(corrId3);
            assertEquals(corrId3, CorrelationIdUtils.getCorrelationId().get());
            testThreadOutcome[1] = true;
        });
        thread.start();
        thread2.start();

        thread.join();
        thread2.join();
        assertEquals(corrId, CorrelationIdUtils.getCorrelationId().get());
        assertTrue(testThreadOutcome[0]);
        assertTrue(testThreadOutcome[1]);

    }
}