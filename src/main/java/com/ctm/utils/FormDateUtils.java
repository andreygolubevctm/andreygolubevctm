package com.ctm.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import org.apache.log4j.Logger;

public class FormDateUtils {

	static SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

	private static Logger logger = Logger.getLogger(FormDateUtils.class.getName());

	public static Date parseDateFromForm(String searchDate) {
		Date searchDateValue = null;
		try {
			searchDateValue = formatter.parse(searchDate);
		} catch (ParseException e) {
			logger.warn("failed to parse " + searchDate, e);
		}
		return searchDateValue;
	}

	public static String convertDateToString(Date date, String format){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);

		SimpleDateFormat sdf = new SimpleDateFormat(format);
		sdf.setCalendar(cal);

		return sdf.format(cal.getTime());
	}

	/**
	 * getTodaysDate returns the current date in the requested format
	 *
	 * @return
	 */
	public static String getTodaysDate(String format) {
		Date today = new Date();
		return convertDateToString(today, format);

	}

	public static Object convertDateToFormFormat(Date date) {
		String dateString = null;
		dateString = formatter.format(date);
		return dateString;
	}
}
