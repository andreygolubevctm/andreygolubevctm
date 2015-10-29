package com.ctm.web.core.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class FormDateUtils {

	static SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

	private static final Logger LOGGER = LoggerFactory.getLogger(FormDateUtils.class);

	public static Date parseDateFromForm(String searchDate) {
		Date searchDateValue = null;
		try {
			searchDateValue = formatter.parse(searchDate);
		} catch (ParseException e) {
			LOGGER.warn("Failed to parse date. {}" , kv("searchDate" , searchDate), e);
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
