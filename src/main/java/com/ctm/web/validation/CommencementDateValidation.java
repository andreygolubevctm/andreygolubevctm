package com.ctm.web.validation;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class CommencementDateValidation {

	public static boolean isValid(String commencementDate, String dateFormat) {

		try {
			Date today = new Date(); // your date
			Calendar todayCal = Calendar.getInstance();
			todayCal.setTime(today);
			todayCal = new GregorianCalendar(todayCal.get(Calendar.YEAR), todayCal.get(Calendar.MONTH), todayCal.get(Calendar.DAY_OF_MONTH));

			SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
			Date commencementDateObj = sdf.parse(commencementDate);
			Calendar commencementDateCal = Calendar.getInstance();
			commencementDateCal.setTime(commencementDateObj);

			return commencementDateCal.compareTo(todayCal) >= 0;

		} catch (Exception e) {
			return false;
		}
	}

	public static String getToday(String dateFormat) throws Exception {

		Date today = new Date(); // your date
		Calendar todayCal = Calendar.getInstance();
		todayCal.setTime(today);
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
		return sdf.format(todayCal.getTime());
	}

}
