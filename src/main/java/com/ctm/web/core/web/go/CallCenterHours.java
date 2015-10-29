package com.ctm.web.core.web.go;

import com.ctm.web.core.dao.GeneralDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class CallCenterHours {

	private static final Logger LOGGER = LoggerFactory.getLogger(GeneralDao.class.getName());

	public static final int MORNING_HOUR = 0;
	public static final int AFTERNOON_HOUR = 12;
	public static final int EVENING_HOUR = 18;

	private Map<String, List<Date>> openingHours = new HashMap<String, List<Date>>();

	public CallCenterHours(String vertical, GeneralDao generalDao) {
		setupOpenHours(generalDao, vertical);
	}

	public CallCenterHours(String vertical) {
		GeneralDao generalDao = new GeneralDao();
		setupOpenHours(generalDao, vertical);
	}

	public CallCenterHours() {
	}

	private void setupOpenHours(GeneralDao generalDao, String vertical) {
		Map<String, String> values = generalDao.getValues(vertical
				+ "CallCentreHours");
		for (Entry<String, String> value : values.entrySet()) {
			List<Date> hours = new ArrayList<Date>();
			String dayOfWeek = value.getKey();
			String[] times = value.getValue().split(",");
			SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm",
					Locale.ENGLISH);
			try {
				if (times.length > 1) {
					Date opening = dateFormat.parse(times[0]);
					Date closing = dateFormat.parse(times[1]);
					hours.add(opening);
					hours.add(closing);
				}
			} catch (ParseException e) {
				LOGGER.error("Failed to parse date. {}", kv("times", times), e);
			}
			openingHours.put(dayOfWeek, hours);
		}
	}

	public Date getCallCentreClosure() {
		Calendar now = Calendar.getInstance();
		Date closureTime = getDateRange(now).get(1);
		return closureTime;
	}

	public Calendar getCallCentreClosure(Calendar cal) {
		Calendar closureTime = (Calendar) cal.clone();
		List<Date> dateRange = getDateRange(cal);
		if (dateRange != null && dateRange.size() > 1) {
			closureTime.setTime(dateRange.get(1));
			closureTime.set(Calendar.YEAR, cal.get(Calendar.YEAR));
			closureTime.set(Calendar.MONTH, cal.get(Calendar.MONTH));
			closureTime.set(Calendar.DAY_OF_MONTH,
					cal.get(Calendar.DAY_OF_MONTH));
		} else {
			closureTime = null;
		}
		return closureTime;
	}

	private List<Date> getDateRange(Calendar date) {
		int currentDate = date.get(Calendar.DAY_OF_WEEK);
		List<Date> range = null;
		switch (currentDate) {
		case Calendar.SUNDAY:
			range = openingHours.get("Sun");
			break;
		case Calendar.MONDAY:
			range = openingHours.get("Mon");
			break;
		case Calendar.TUESDAY:
			range = openingHours.get("Tues");
			break;
		case Calendar.WEDNESDAY:
			range = openingHours.get("Wed");
			break;
		case Calendar.THURSDAY:
			range = openingHours.get("Thurs");
			break;
		case Calendar.FRIDAY:
			range = openingHours.get("Fri");
			break;
		case Calendar.SATURDAY:
			range = openingHours.get("Sat");
			break;
		}
		return range;
	}

	public Date getNextAvailableDate(Calendar avaliableDateCal, int count) {
		Calendar closure = getCallCentreClosure(avaliableDateCal);
		if (count <= 7 && (closure == null || avaliableDateCal.after(closure))) {
			avaliableDateCal.add(Calendar.DATE, 1);
			return getNextAvailableDate(avaliableDateCal, count++);
		} else {
			return avaliableDateCal.getTime();
		}
	}

	public Date getNextAvailableDate(int hour) {
		Calendar now = Calendar.getInstance();
		return getNextAvailableDate(hour, now);
	}

	public Date getNextAvailableDate(int hour, Calendar now) {
		Calendar avaliableDateCal = (Calendar) now.clone();

		avaliableDateCal.clear(Calendar.MINUTE);
		avaliableDateCal.clear(Calendar.MILLISECOND);
		avaliableDateCal.set(Calendar.HOUR_OF_DAY, hour);

		Calendar closure = getCallCentreClosure(avaliableDateCal);
		boolean inTimeRange = true;
		if (avaliableDateCal.before(now)) {
			int closureHour = closure == null ? 0 : closure
					.get(Calendar.HOUR_OF_DAY);
			if (hour == MORNING_HOUR && now.get(Calendar.HOUR_OF_DAY) > 12) {
				inTimeRange = false;
			}
			if (hour == AFTERNOON_HOUR && now.get(Calendar.HOUR_OF_DAY) > 18
					|| (now.get(Calendar.HOUR_OF_DAY) > closureHour)) {
				inTimeRange = false;
			}
		}
		if (!inTimeRange || closure == null || avaliableDateCal.after(closure)) {
			avaliableDateCal.add(Calendar.DATE, 1);
			/* Return calculated date and calculated time */
			return getNextAvailableDate(avaliableDateCal, 0);
		} else if (avaliableDateCal.after(now)) {
			/* Return current date and calculated time */
			return avaliableDateCal.getTime();
		} else {
			/* Return current date and time */
			return now.getTime();
		}
	}
}
