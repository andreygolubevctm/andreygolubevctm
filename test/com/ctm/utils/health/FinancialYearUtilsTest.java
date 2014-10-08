package com.ctm.utils.health;

import static org.junit.Assert.*;

import java.util.Calendar;
import java.util.GregorianCalendar;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;

@RunWith(PowerMockRunner.class)
@PrepareForTest( { FinancialYearUtils.class})
public class FinancialYearUtilsTest {

	private Calendar calendar;

	@Before
	public void setup(){
		PowerMockito.mockStatic(Calendar.class);
		calendar = new GregorianCalendar();
		calendar.set(Calendar.YEAR , 2014);

		Mockito.when(Calendar.getInstance()).thenReturn(calendar);
	}


	@Test
	public void shouldGetFinancialYearStart(){
		//before end of financial year
		calendar.set(Calendar.MONTH , Calendar.JANUARY);
		assertEquals(2013 , FinancialYearUtils.getFinancialYearStart());

		//after end of financial year
		calendar.set(Calendar.MONTH , Calendar.JULY);
		assertEquals(2014 , FinancialYearUtils.getFinancialYearStart());
	}

	@Test
	public void shouldGetFinancialYearEnd(){
		//before end of financial year
		calendar.set(Calendar.MONTH , Calendar.JANUARY);
		assertEquals(2014 , FinancialYearUtils.getFinancialYearEnd());

		//after end of financial year
		calendar.set(Calendar.MONTH , Calendar.JULY);
		assertEquals(2015 , FinancialYearUtils.getFinancialYearEnd());
	}

	@Test
	public void shouldGetContinuousCoverYear(){
		calendar.set(Calendar.MONTH , Calendar.JANUARY);
		assertEquals(2003 , FinancialYearUtils.getContinuousCoverYear());

		calendar.set(Calendar.MONTH , Calendar.JULY);
		assertEquals(2004 , FinancialYearUtils.getContinuousCoverYear());
	}

}
