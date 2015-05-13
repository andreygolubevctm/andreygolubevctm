package com.ctm.utils.common.utils;

import com.ctm.exceptions.DaoException;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtils {


	/**
	 * Adds number of days into supplied date and returns date
	 * */
	public static Date addDays(Date date,int days){
		Calendar cal = Calendar.getInstance();
		cal.setTime( date);
		cal.add( Calendar.DATE, days );
		return cal.getTime();
	}

	/**
	 * returns last starts from monday
	 * */
	public static Date getLastDayOfTheWeek(Date effectiveDate){
		Calendar c = Calendar.getInstance();
		c.setFirstDayOfWeek(Calendar.MONDAY);
		c.setTime(effectiveDate);
		int today = c.get(Calendar.DAY_OF_WEEK);
		c.add(Calendar.DAY_OF_WEEK, today != Calendar.SUNDAY ? today + Calendar.SUNDAY : 0);
		return c.getTime();
	}


	/**
	* returns first date on first day of the week  of supplied date
	* considering week starts from monday
	* */
	public static Date getStartDayOfTheWeek(Date effectiveDate){
		Calendar c = Calendar.getInstance();
		c.setFirstDayOfWeek(Calendar.MONDAY);
		c.setTime(effectiveDate);
		int today = c.get(Calendar.DAY_OF_WEEK);
		c.add(Calendar.DAY_OF_WEEK, -today+Calendar.MONDAY);
		return c.getTime();
	}



	/**
	 * Function converts time in a string into date object
	*/
	public static Date timeToDateTime(String time){
		if(time==null || time.trim().equals("")){
			return null;
		}
		SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
		Date timeDate = null;
		try {
			timeDate = dateFormat.parse(time);
		} catch (ParseException e) {
			new DaoException("Could not parse time "+ time +" into date");
		}
		return timeDate;
	}


	/*
	* returns TRUE if 'dateToCompare' is in the range of 'startDate' and 'endDate'
	* */
	public static boolean isDateInRange(Date dateToCompare , Date startDate,Date endDate){
		return dateToCompare.after(startDate) && dateToCompare.before(endDate);
	}


	/*Function returns current SQL timestamp- majorly used in prepared statements */
	public static Timestamp getSqlTimestamp(){
		java.util.Date today = new java.util.Date();
		return new java.sql.Timestamp(today.getTime());
	}

	/*Function converts and returns SQL date - majorly used in prepared statements */
	public static java.sql.Date toSQLDate(Date date){
		return new java.sql.Date(date.getTime());
	}


    public static  java.util.Date getUtilDate(java.sql.Date date) throws SQLException {
        return date != null ? new java.util.Date(date.getTime()) : null;
    }
}
