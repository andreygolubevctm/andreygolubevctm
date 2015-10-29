package com.disc_au.web.go.tags;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;

import com.ctm.web.core.dao.GeneralDao;
import com.ctm.web.core.web.go.CallCenterHours;

public class CallCenterHoursTest {

	private static final String SUN = "Sun";
	private static final String MON = "Mon";
	private static final String TUES = "Tues";
	private static final String WED = "Wed";
	private static final String THURS = "Thurs";
	private static final String FRI = "Fri";
	private static final String SAT = "Sat";
	private Calendar mondayMorning;
	private Calendar mondayAfterNoon;
	private Calendar saturdayMorning;
	private Calendar saturdayAfterNoon;
	private Calendar sundayMorning;
	private CallCenterHours callCenterHours;
	private Calendar saturdayEvening;
	private Calendar saturdayLateAfterNoon;
	private Calendar sundayAfternoon;
	private Calendar mondayEvening;
	private Calendar fridayEvening;
	private Calendar fridayAfterHours;
	private Calendar mondayEveningAfterHours;

	@Before
	public void setup() throws SQLException, ClassNotFoundException {
		/* set to 25/11/2013 and 10am */
		mondayMorning = getBaseCalendar();
		mondayMorning.set(Calendar.MONTH, Calendar.NOVEMBER);
		mondayMorning.set(Calendar.DAY_OF_MONTH, 25);
		mondayMorning.clear(Calendar.MINUTE);
		mondayMorning.clear(Calendar.MILLISECOND);
		mondayMorning.set(Calendar.HOUR_OF_DAY, 10);

		/* set to 25/11/2013 and 2pm */
		mondayAfterNoon = (Calendar) mondayMorning.clone();
		mondayAfterNoon.set(Calendar.HOUR_OF_DAY, 14);

		/* set to 25/11/2013 and 7pm */
		mondayEvening = (Calendar) mondayMorning.clone();
		mondayEvening.set(Calendar.HOUR_OF_DAY, 19);

		/* set to 25/11/2013 and 9pm */
		mondayEveningAfterHours = (Calendar) mondayMorning.clone();
		mondayEveningAfterHours.set(Calendar.HOUR_OF_DAY, 21);

		fridayEvening = getBaseCalendar();
		fridayEvening.set(Calendar.MONTH, Calendar.NOVEMBER);
		fridayEvening.set(Calendar.DAY_OF_MONTH, 29);
		fridayEvening.set(Calendar.HOUR_OF_DAY, 19);
		fridayAfterHours= (Calendar) fridayEvening.clone();
		fridayAfterHours.set(Calendar.HOUR_OF_DAY, 21);

		saturdayMorning = getBaseCalendar();
		saturdayMorning.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
		saturdayMorning.set(Calendar.HOUR_OF_DAY, 10);

		saturdayAfterNoon = (Calendar) saturdayMorning.clone();
		saturdayAfterNoon.set(Calendar.HOUR_OF_DAY, 14);

		saturdayLateAfterNoon = (Calendar) saturdayMorning.clone();
		saturdayLateAfterNoon.set(Calendar.HOUR_OF_DAY, 17);

		saturdayEvening = (Calendar) saturdayAfterNoon.clone();
		saturdayEvening.set(Calendar.HOUR_OF_DAY, 19);

		sundayMorning = getBaseCalendar();
		sundayMorning.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
		sundayMorning.set(Calendar.HOUR_OF_DAY, 10);

		sundayAfternoon =(Calendar) sundayMorning.clone();
		sundayAfternoon.set(Calendar.HOUR_OF_DAY, 14);
		GeneralDao generalDao = mock(GeneralDao.class);
		Map<String, String> values = new HashMap<String, String>();
		values.put(MON, "08:30,20:00");
		values.put(TUES, "08:30,20:00");
		values.put(WED, "08:30,20:00");
		values.put(THURS, "08:30,20:00");
		values.put(FRI, "08:30,20:00");
		values.put(SAT, "10:00,16:00");
		values.put(SUN, "");
		values.put(MON, "08:30,20:00");
		when(generalDao.getValues("healthCallCentreHours")).thenReturn(values );
		callCenterHours = new CallCenterHours("health", generalDao );
	}

	private Calendar getBaseCalendar() {
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR , 2014);
		cal.set(Calendar.MONTH, Calendar.JANUARY);
		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.clear(Calendar.MINUTE);
		cal.clear(Calendar.MILLISECOND);
		cal.set(Calendar.HOUR_OF_DAY, 1);
		return cal;
	}

	@Test
	public void testGetCallBackDateTimeMonday() throws SQLException, ClassNotFoundException {

		int expectedHour = mondayMorning.get(Calendar.HOUR_OF_DAY);
		Date result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , mondayMorning);
		assertDayOfWeek(TUES ,result);
		assertDayOfMonth(25 ,result);

		assertHour(expectedHour , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , mondayMorning);
		assertDayOfWeek(TUES ,result);
		assertDayOfMonth(25 ,result);
		assertHour(CallCenterHours.AFTERNOON_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , mondayMorning);
		assertDayOfWeek(TUES ,result);
		assertDayOfMonth(25 ,result);
		assertHour(CallCenterHours.EVENING_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , mondayAfterNoon);
		assertDayOfWeek(WED ,result);
		assertDayOfMonth(26 ,result);
		assertHour(CallCenterHours.MORNING_HOUR , result);

		expectedHour = mondayAfterNoon.get(Calendar.HOUR_OF_DAY);
		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , mondayAfterNoon);
		assertDayOfWeek(TUES ,result);
		assertDayOfMonth(25 ,result);
		assertHour(expectedHour , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , mondayAfterNoon);
		assertDayOfWeek(TUES ,result);
		assertDayOfMonth(25 ,result);
		assertHour(CallCenterHours.EVENING_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , mondayEvening);
		assertDayOfWeek(WED ,result);
		assertDayOfMonth(26 ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , mondayEvening);
		assertDayOfWeek(WED ,result);
		assertDayOfMonth(26 ,result);
		assertHour(CallCenterHours.AFTERNOON_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , mondayEvening);
		assertDayOfWeek(TUES ,result);
		assertDayOfMonth(25 ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , mondayEveningAfterHours);
		assertDayOfWeek(WED ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , mondayEveningAfterHours);
		assertDayOfWeek(WED ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , mondayEveningAfterHours);
		assertDayOfWeek(WED ,result);

	}

	@Test
	public void testGetCallBackDateTimeFriday() throws SQLException, ClassNotFoundException {
		Date result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , fridayEvening);
		assertDayOfWeek(MON ,result);
		assertDayOfMonth(1 ,result);
		assertHour(CallCenterHours.MORNING_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , fridayEvening);
		assertDayOfWeek(MON ,result);
		assertHour(CallCenterHours.AFTERNOON_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , fridayEvening);
		assertDayOfWeek(MON ,result);
		assertHour(CallCenterHours.EVENING_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , fridayAfterHours);
		assertDayOfWeek(MON ,result);
		assertHour(CallCenterHours.EVENING_HOUR , result);
	}

	@Test
	public void testGetCallBackDateTimeSaturday() throws SQLException, ClassNotFoundException {
		Date result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , saturdayMorning);
		assertDayOfWeek(SAT ,result);
		assertHour(10 , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , saturdayMorning);
		assertDayOfWeek(SAT ,result);
		assertHour(CallCenterHours.AFTERNOON_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , saturdayMorning);
		assertDayOfWeek(MON ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , saturdayAfterNoon);
		assertDayOfWeek(MON ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , saturdayAfterNoon);
		assertDayOfWeek(SAT ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , saturdayAfterNoon);
		assertDayOfWeek(MON ,result);


		result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , saturdayLateAfterNoon);
		assertDayOfWeek(MON ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , saturdayLateAfterNoon);
		assertDayOfWeek(MON ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , saturdayLateAfterNoon);
		assertDayOfWeek(MON ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , saturdayEvening);
		assertDayOfWeek(MON ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , saturdayEvening);
		assertDayOfWeek(MON ,result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , saturdayEvening);
		assertDayOfWeek(MON ,result);
	}

	@Test
	public void testGetCallBackDateTimeSunday() throws SQLException, ClassNotFoundException {
		Date result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , sundayMorning);
		assertDayOfWeek(MON ,result);
		assertHour(CallCenterHours.MORNING_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , sundayMorning);
		assertDayOfWeek(MON ,result);
		System.out.println("result " + result);
		assertHour(CallCenterHours.AFTERNOON_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , sundayMorning);
		assertDayOfWeek(MON ,result);
		assertHour(CallCenterHours.EVENING_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.MORNING_HOUR , sundayAfternoon);
		assertDayOfWeek(MON ,result);
		assertHour(CallCenterHours.MORNING_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.AFTERNOON_HOUR , sundayAfternoon);
		assertDayOfWeek(MON ,result);
		assertHour(CallCenterHours.AFTERNOON_HOUR , result);

		result = callCenterHours.getNextAvailableDate(CallCenterHours.EVENING_HOUR , sundayAfternoon);
		assertDayOfWeek(MON ,result);
		assertHour(CallCenterHours.EVENING_HOUR , result);

	}

	protected void assertDayOfMonth(int expected, Date result) {
		Calendar returnedResult = getBaseCalendar();
		returnedResult.setTime(result);
		assertEquals(expected, returnedResult.get(Calendar.DAY_OF_MONTH));
	}

	protected void assertDayOfWeek(String expected, Date result) {
		Calendar returnedResult = getBaseCalendar();
		returnedResult.setTime(result);
		String resultDay = "";
		switch (returnedResult.get(Calendar.DAY_OF_WEEK)) {
			case Calendar.SUNDAY:
				resultDay = SUN;
				break;
			case Calendar.MONDAY:
				resultDay =MON;
				break;
			case Calendar.TUESDAY:
				resultDay = TUES;
				break;
			case Calendar.WEDNESDAY:
				resultDay = WED;
				break;
			case Calendar.THURSDAY:
				resultDay =THURS;
				break;
			case Calendar.FRIDAY:
				resultDay =FRI;
				break;
			case Calendar.SATURDAY:
				resultDay =SAT;
				break;
		}
		assertEquals(expected, resultDay);
	}


	private void assertHour(int hour, Date result) {
		Calendar returnedResult = getBaseCalendar();
		returnedResult.setTime(result);
		System.out.println("returnedResult " + returnedResult.getTime());
		assertEquals(hour, returnedResult.get(Calendar.HOUR_OF_DAY));
	}
}
