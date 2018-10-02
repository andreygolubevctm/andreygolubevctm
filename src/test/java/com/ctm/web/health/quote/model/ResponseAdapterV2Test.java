package com.ctm.web.health.quote.model;

import org.junit.Test;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.Assert.assertEquals;

public class ResponseAdapterV2Test {

    @Test
    public void testCalculateRebateValueWithEmptyRebate() {
        assertEquals(new BigDecimal(25), ResponseAdapterV2.calculateRebateValue(Optional.empty(), new BigDecimal(100), new BigDecimal(25)));
    }

    @Test
    public void testCalculateRebateValueWithRebate() {
        assertEquals(new BigDecimal("30.00"), ResponseAdapterV2.calculateRebateValue(Optional.of(BigDecimal.valueOf(30)), new BigDecimal(100), new BigDecimal(25)));
    }

}