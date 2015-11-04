package com.ctm.web.simples.admin.model.request;

import com.ctm.web.core.helper.request.OpeningHoursHelper;
import com.ctm.web.core.model.OpeningHours;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import java.sql.SQLException;

import static org.junit.Assert.assertEquals;

@RunWith(MockitoJUnitRunner.class)
public class OpeningHoursHelperTest {
	OpeningHoursHelper openingHoursHelper;
	
	@Before
	public void setup() throws SQLException, ClassNotFoundException {
		openingHoursHelper = new OpeningHoursHelper(); 
	}
	public static OpeningHours createOpeningHoursObject(int openingHoursId, String date, String daySequence, String description,
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

	@Test
	public void getFormattedHoursTest(){
		String result = openingHoursHelper.getFormattedHours("22:33:00");
		assertEquals("10:33 pm", result);
		result = openingHoursHelper.getFormattedHours("11:11:11");
		assertEquals("11:11 am", result);
	}
	@Test
	public void trimHoursTest(){
		String result = openingHoursHelper.trimHours("10:33 pm");
		assertEquals("10:33pm", result);
		result = openingHoursHelper.trimHours("00:30 am");
		assertEquals("0:30am", result);
		result = openingHoursHelper.trimHours("08:00 am");
		assertEquals("8am", result);
		result = openingHoursHelper.trimHours("11:30 am");
		assertEquals("11:30am", result);
	}

}
