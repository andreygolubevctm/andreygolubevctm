package com.ctm.web.core.utils.common.utils;

import com.ctm.web.core.exceptions.DaoException;
import org.joda.time.LocalDate;
import org.joda.time.Period;
import org.joda.time.PeriodType;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.util.NoSuchElementException;
import java.util.TimeZone;

public class DateUtils {

    public enum StateTimeZones {
        ACT("Australia/ACT"),
        NSW("Australia/NSW"),
        NT("Australia/North"),
        QLD("Australia/Queensland"),
        SA("Australia/South"),
        TAS("Australia/Tasmania"),
        WA("Australia/West"),
        VIC("Australia/Victoria");
        private final String timeZone;

        StateTimeZones(String timeZone) {
            this.timeZone = timeZone;
        }

        public String getTimeZone() {
            return timeZone;
        }

        public static StateTimeZones findByTimeZone(String timeZone) {
            for (StateTimeZones t : StateTimeZones.values()) {
                if (timeZone.equalsIgnoreCase(t.getTimeZone())) {
                    return t;
                }
            }
            return null;
        }

    }

    /**
     * Adds number of days into supplied date and returns date
     */
    public static Date addDays(Date date, int days) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DATE, days);
        return cal.getTime();
    }


    /**
     * Function converts time in a string into date object
     */
    public static Date timeToDateTimeHHmm(String time) {
        if (time == null || time.trim().equals("")) {
            return null;
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
        Date timeDate = null;
        try {
            timeDate = dateFormat.parse(time);
        } catch (ParseException e) {
            new DaoException("Could not parse time " + time + " into date");
        }
        return timeDate;
    }

    /**
     * Function converts time in a string into date object
     *
     * @param time : must be in HH:mm:ss format
     * @param date : must not be null
     * @return
     */
    public static Date mergeDateAndTimeHHmmss(Date date, String time) {
        if (time == null || time.trim().equals("") || date == null) {
            return null;
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date dateTime = null;
        try {
            dateTime = dateTimeFormat.parse(dateFormat.format(date) + " " + time);
        } catch (ParseException e) {
            new DaoException("Could not parse time " + time + " into date");
        }
        return dateTime;
    }

    /*
    * returns TRUE if 'dateToCompare' is in the range of 'startDate' and 'endDate'
    * */
    public static boolean isDateInRange(Date dateToCompare, Date startDate, Date endDate) {
        return dateToCompare.after(startDate) && dateToCompare.before(endDate);
    }


    /*Function returns current SQL timestamp- majorly used in prepared statements */
    public static Timestamp getSqlTimestamp() {
        java.util.Date today = new java.util.Date();
        return new java.sql.Timestamp(today.getTime());
    }

    /*Function returns  SQL timestamp from java date Object- majorly used in prepared statements */
    public static Timestamp toSqlTimestamp(Date date) {
        return new java.sql.Timestamp(date.getTime());
    }

    /*Function converts and returns SQL date - majorly used in prepared statements */
    public static java.sql.Date toSQLDate(Date date) {
        return new java.sql.Date(date.getTime());
    }

    public static java.time.LocalDateTime toLocalDateTime(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
    }

    public static java.time.LocalDate getUtilDate(java.sql.Date date) throws SQLException {
        return date != null ? date.toLocalDate() : null;
    }


    /**
     * This function sets hours,minuets and seconds in the date supplied
     *
     * @param date    : Date object where time needs to be set
     * @param hours   : hours must be within 0 to 23
     * @param minutes : minuets must be between 0 to 59
     * @param seconds : seconds must be between 0 to 59
     */
    public static Date setTimeInDate(Date date, int hours, int minutes, int seconds) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, hours);
        cal.set(Calendar.MINUTE, minutes);
        cal.set(Calendar.SECOND, seconds);
        date = cal.getTime();
        return date;
    }

    /**
     * This function will converts date time of supplied date based on the timezone in supplied state
     *
     * @param date
     * @param state
     * @return
     * @throws ParseException
     */
    public static Date convertDateForState(Date date, String state) throws ParseException, NoSuchElementException {
        Date dateConverted = null;
        SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss");
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss");
        StateTimeZones timeZone = StateTimeZones.findByTimeZone(state);
        if (timeZone != null) {
            isoFormat.setTimeZone(TimeZone.getTimeZone(timeZone.getTimeZone()));
            dateConverted = df.parse(isoFormat.format(date));
        } else {
            throw new NoSuchElementException("No timezone found for state" + state);
        }
        return dateConverted;
    }


    /**
     * This function will converts date time of supplied date based on the timezone
     *
     * @param date
     * @param timeZone
     * @return
     * @throws ParseException
     */
    public static Date convertDateForTimeZone(Date date, String timeZone) throws ParseException {
        Date dateConverted;
        SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss");
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss");
        isoFormat.setTimeZone(TimeZone.getTimeZone(timeZone));
        dateConverted = df.parse(isoFormat.format(date));
        return dateConverted;
    }

    public static int getAgeFromDOBStr(String dob) throws Exception {
        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        Date dobObj =  df.parse(dob);
        return getAgeFromDOB(dobObj);
    }

    public static int getAgeFromDOB(Date dob) {
        LocalDate birthdate = new LocalDate (dob);
        LocalDate now = new LocalDate();
        Period period = new Period(birthdate, now, PeriodType.yearMonthDay());
        return period.getYears();
    }

    public static java.time.LocalDate parseStringToLocalDate(String date) {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("d/M/yyyy");
        return java.time.LocalDate.parse(date,dtf);

    }

    public static int getAgeFromDob(java.time.LocalDate dob) {
        final java.time.LocalDate today = java.time.LocalDate.now();
        final java.time.Period age = java.time.Period.between(dob,today);
        return age.getYears();
    }
}
