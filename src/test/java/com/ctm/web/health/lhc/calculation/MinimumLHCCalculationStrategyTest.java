package com.ctm.web.health.lhc.calculation;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Unit test for {@link MinimumLHCCalculationStrategy}.
 */
public class MinimumLHCCalculationStrategyTest {

    @Test
    public void givenHealthCoverApplicant_whenAlwaysHeldCoverIsTrue_returnZeroLHCPercentage() {
        assertEquals(Constants.MIN_LHC_PERCENTAGE, new MinimumLHCCalculationStrategy().calculateLHCPercentage());
    }

}