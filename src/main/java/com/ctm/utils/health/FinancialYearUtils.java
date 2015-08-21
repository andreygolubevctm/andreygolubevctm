package com.ctm.utils.health;

import java.util.Calendar;

public class FinancialYearUtils {

	/**
	 * Calculate the start of financial year - changes on 1st July each year
	 * @return calculated year
	 */
	public static int getFinancialYearStart(){
		Calendar current = Calendar.getInstance();
		int year = current.get(Calendar.YEAR);
		return isAfterEndOfFinancialYear(current)? year :  year - 1;
	}


	/**
	 * Calculate the end of financial year - changes on 1st July each year
	 * @return calculated year
	 */
	public static int getFinancialYearEnd(){
		Calendar current = Calendar.getInstance();
		int year = current.get(Calendar.YEAR);
		return isAfterEndOfFinancialYear(current)? year + 1 : year;
	}

	/**
	 * Calculate the year for continuous cover - changes on 1st July each year
	 * @return calculated year
	 */
	public static int getContinuousCoverYear(){
		Calendar current = Calendar.getInstance();
		int year = current.get(Calendar.YEAR);
		return isAfterEndOfFinancialYear(current)? year - 10 :  year - 11;
	}

	private static boolean isAfterEndOfFinancialYear(Calendar current) {
		return current.get(Calendar.MONTH) >= Calendar.JULY;
	}
}
