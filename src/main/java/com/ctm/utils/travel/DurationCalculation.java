package com.ctm.utils.travel;

import java.text.SimpleDateFormat;

import java.util.Date;
import java.util.Locale;

import org.joda.time.DateTime;
import org.joda.time.Days;

public class DurationCalculation {

	/**
	 * Calculate the duration between two dates then apply a CEIL function
	 * @return calculated year
	 */
	public static int calculateDayDuration(String dateofLeave, String dateOfReturn) throws Exception {

		Date leaveDate = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(dateofLeave);
		Date returnDate = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(dateOfReturn);

		// plus one'd because travel requires inclusive dates. today - today is 1 due to interstate day trips
		return Days.daysBetween(new DateTime(leaveDate), new DateTime(returnDate)).getDays() + 1;
	}
}