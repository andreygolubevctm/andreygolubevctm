package com.disc_au.web.go;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

public class CallCenterHours {

	public static final int MORNING_HOUR = 0;
	public static final int AFTERNOON_HOUR = 12;
	public static final int EVENING_HOUR = 18;

	private Map<String, List<Date>> openingHours = new HashMap<String, List<Date>>();

	public CallCenterHours(String vertical, DataSource ds) {
		Connection conn = null;
		try {
			// Allocate and use a connection from the pool
			conn = ds.getConnection();
			PreparedStatement stmt;
			stmt = conn.prepareStatement(
					"SELECT code, description " +
						"FROM aggregator.general g " +
						"WHERE g.type = ?;");
			stmt.setString(1, vertical + "CallCentreHours");
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				List<Date> hours = new ArrayList<Date>();
				String dayOfWeek = rs.getString("code");
				String[] times = rs.getString("description").split(",");
				SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm", Locale.ENGLISH);
				try {
					if(times.length > 1) {
						Date opening = dateFormat.parse(times[0]);
						Date closing = dateFormat.parse(times[1]);
						hours.add(opening);
						hours.add(closing);
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}
				openingHours.put(dayOfWeek, hours);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {}
			}
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
		if(dateRange != null && dateRange.size() > 1) {
			closureTime.setTime(dateRange.get(1));
			closureTime.set(Calendar.YEAR, cal.get(Calendar.YEAR));
			closureTime.set(Calendar.MONTH, cal.get(Calendar.MONTH));
			closureTime.set(Calendar.DAY_OF_MONTH, cal.get(Calendar.DAY_OF_MONTH));
		} else {
			closureTime =  null;
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

	public Date getNextAvailableDate(Calendar avaliableDateCal , int count) {
		Calendar closure = getCallCentreClosure(avaliableDateCal);
		if(count <= 7 && (closure == null || avaliableDateCal.after(closure)) ) {
			avaliableDateCal.add(Calendar.DATE, 1);
			return getNextAvailableDate(avaliableDateCal, count++);
		} else {
			return avaliableDateCal.getTime();
		}
	}

	public Date getNextAvailableDate(int hour) {
		Calendar now = Calendar.getInstance();
		return getNextAvailableDate(hour , now);
	}

	public Date getNextAvailableDate(int hour , Calendar now) {
		Calendar avaliableDateCal = (Calendar) now.clone();

		avaliableDateCal.clear(Calendar.MINUTE);
		avaliableDateCal.clear(Calendar.MILLISECOND);
		avaliableDateCal.set(Calendar.HOUR_OF_DAY, hour);

		Calendar closure = getCallCentreClosure(avaliableDateCal);
		boolean inTimeRange = true;
		if(avaliableDateCal.before(now)) {
			int closureHour = closure == null ? 0 : closure.get(Calendar.HOUR_OF_DAY);
			if(hour == MORNING_HOUR && now.get(Calendar.HOUR_OF_DAY) > 12) {
				inTimeRange = false;
			}
			if(hour == AFTERNOON_HOUR && now.get(Calendar.HOUR_OF_DAY) > 18 || (now.get(Calendar.HOUR_OF_DAY) > closureHour)) {
				inTimeRange = false;
			}
		}
		if(!inTimeRange|| closure == null || avaliableDateCal.after(closure) ) {
			avaliableDateCal.add(Calendar.DATE, 1);
			/* Return calculated date and calculated time */
			return getNextAvailableDate(avaliableDateCal , 0);
		} else if(avaliableDateCal.after(now)) {
			/* Return current date and calculated time */
			return avaliableDateCal.getTime();
		} else {
			/* Return current date and time */
			return now.getTime();
		}
	}

}
