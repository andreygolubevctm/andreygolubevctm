package com.ctm.web.core.openinghours.helper;

import com.ctm.web.core.openinghours.model.OpeningHours;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class OpeningHoursHelper {

	public OpeningHours createOpeningHoursObject(int openingHoursId, String date, String daySequence, String description,
			String effectiveEnd, String effectiveStart, String endTime, String hoursType, String startTime, int verticalId) {
		OpeningHours openingHours = new OpeningHours();
		openingHours.setOpeningHoursId(openingHoursId);
		openingHours.setDate(date);
		openingHours.setDaySequence(daySequence);
		openingHours.setDescription(description);
		openingHours.setEffectiveEnd(effectiveEnd);
		openingHours.setEffectiveStart(effectiveStart);
		openingHours.setEndTime(endTime);
		openingHours.setHoursType(hoursType);
		openingHours.setStartTime(startTime);
		openingHours.setVerticalId(verticalId);
		return openingHours;
	}

	public String getFormattedHours(String time) {
		if (time != null && !time.trim().equals("")) {
			DateFormat dateFormat = new SimpleDateFormat("hh:mm a");
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.HOUR_OF_DAY, Integer.parseInt(time.substring(0, 2)));
			cal.set(Calendar.MINUTE, Integer.parseInt(time.substring(3, 5)));
			Date date = cal.getTime();
			String timeFormatted = dateFormat.format(date);
			return timeFormatted.toLowerCase();
		} else {
			return "";
		}
	}

	/**
	 * This method wil remove extra 0s and make it compact specially wrote to
	 * display hours on the website header timeFormatted : must be in 24hrs
	 * format "hh:mm AM/PM"
	 * */
	public String trimHours(String timeFormatted) {
		String hourPart = "", minutPart = "";
		try {
			if (timeFormatted.charAt(0) == '0') {
				hourPart += String.valueOf(timeFormatted.charAt(1));
			} else {
				hourPart += String.valueOf(timeFormatted.charAt(0)) + String.valueOf(timeFormatted.charAt(1));
			}
			if (timeFormatted.charAt(3) == '0' && timeFormatted.charAt(4) == '0') {
				minutPart = "";
			} else {
				minutPart += String.valueOf(timeFormatted.charAt(3)) + String.valueOf(timeFormatted.charAt(4));
			}
			if (minutPart == "") {
				timeFormatted = hourPart + timeFormatted.substring(6);
			} else {
				timeFormatted = hourPart + ":" + minutPart + timeFormatted.substring(6);
			}
		} catch (ArrayIndexOutOfBoundsException e) {
			return timeFormatted;
		}
		return timeFormatted;
	}
}
