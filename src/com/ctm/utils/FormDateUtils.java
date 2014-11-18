package com.ctm.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import org.apache.log4j.Logger;

public class FormDateUtils {

	private static Logger logger = Logger.getLogger(FormDateUtils.class.getName());

	public static Date parseDateFromForm(String searchDate) {
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		Date searchDateValue = null;
		try {
			searchDateValue = formatter.parse(searchDate);
		} catch (ParseException e) {
			logger.warn("failed to parse " + searchDate, e);
		}
		return searchDateValue;
	}

	/**
	 * getTodaysDate returns the current date in the requested format
	 *
	 * @return
	 */
	public static String getTodaysDate(String format) {

		Date today = new Date();

		Calendar cal = Calendar.getInstance();
		cal.setTime(today);

		SimpleDateFormat sdf = new SimpleDateFormat(format);
		sdf.setCalendar(cal);

		return sdf.format(cal.getTime());
	}
}
