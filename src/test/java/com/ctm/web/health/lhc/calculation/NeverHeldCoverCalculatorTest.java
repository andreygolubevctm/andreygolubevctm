package com.ctm.web.health.lhc.calculation;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Unit test for {@link NeverHeldCoverCalculator}.
 */
public class NeverHeldCoverCalculatorTest {

    @Test
    public void givenAge44_thenCalculateLHC() {
        long calculate = new NeverHeldCoverCalculator(44).calculateLHCPercentage();
        assertEquals(28, calculate);
    }

    @Test
    public void givenAgeBelow30_thenReturn0() {
        long calculate = new NeverHeldCoverCalculator(25).calculateLHCPercentage();
        assertEquals(0, calculate);
    }

    @Test(expected = IllegalArgumentException.class)
    public void givenAgeBelowZero_thenThrowIllegalArgumentException() {
        new NeverHeldCoverCalculator(-1).calculateLHCPercentage();
    }
}