package com.ctm.utils.travel;

import static org.junit.Assert.assertEquals;

import com.ctm.web.travel.utils.DurationCalculation;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

@RunWith(PowerMockRunner.class)
@PrepareForTest( { DurationCalculation.class})
public class DurationCalculationTest {

	@Test
	public void shouldcalculateDayDuration() throws Exception{
		// weird date calculation triggers 44 days instead of 43 in JSTL (TRV-400)
		assertEquals(43, DurationCalculation.calculateDayDuration("2014-10-01", "2014-11-12"));

		// Test where start month = 30 days (TRV-260)
		assertEquals(124, DurationCalculation.calculateDayDuration("2014-06-30", "2014-10-31"));
		assertEquals(91, DurationCalculation.calculateDayDuration("2014-09-29", "2014-12-28"));

		// Test start month = 31 days (TRV-260)
		assertEquals(124, DurationCalculation.calculateDayDuration("2014-08-31", "2015-01-01"));
		assertEquals(93, DurationCalculation.calculateDayDuration("2014-07-31", "2014-10-31"));

		// Additional Test end month = 30 days (TRV-260)
		assertEquals(122, DurationCalculation.calculateDayDuration("2014-08-01", "2014-11-30"));
		assertEquals(92,  DurationCalculation.calculateDayDuration("2014-08-31", "2014-11-30"));

		// Test mid-month (TRV-260)
		assertEquals(93,  DurationCalculation.calculateDayDuration("2014-08-15", "2014-11-15"));

		// Test year cross-over (TRV-260)
		assertEquals(216,  DurationCalculation.calculateDayDuration("2014-07-01", "2015-02-01"));

		// Test February - No leap year (TRV-260)
		assertEquals(186, DurationCalculation.calculateDayDuration("2014-08-27", "2015-02-28"));
		assertEquals(186, DurationCalculation.calculateDayDuration("2014-08-28", "2015-03-01"));

		// Test February - Leap year (TRV-260)
		assertEquals(338, DurationCalculation.calculateDayDuration("2015-03-29", "2016-02-29"));
		assertEquals(337, DurationCalculation.calculateDayDuration("2015-03-31", "2016-03-01"));
	}
}
