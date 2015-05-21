package com.ctm.services.simples;

import com.ctm.dao.UserDao;
import com.ctm.dao.simples.MessageConfigDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.MessageConfig;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.StampingService;
import com.ctm.utils.common.utils.DateUtils;
import com.ctm.utils.common.utils.DateUtils.StateTimeZones;

import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MessageConfigService {
	private static final Logger logger = Logger.getLogger(MessageConfigService.class.getName());

	public boolean isInAntiHawkingTimeframe(final HttpServletRequest request, String state) throws DaoException {
		Date currentDate = ApplicationService.getApplicationDate(request);
		return isInAntiHawkingTimeframe(currentDate, state);
	}
	public boolean isInAntiHawkingTimeframe(Date date, String state) throws DaoException {
		MessageConfigDao messageConfigDao = new MessageConfigDao();
		return messageConfigDao.isInAntiHawkingTimeframe(date, state);
	}
	public static void setHawkingStatus(int status, int operatorId, final HttpServletRequest request) throws DaoException {
		MessageConfigDao messageConfigDao = new MessageConfigDao();
		int outcome =  messageConfigDao.setStatus(status);
		if (outcome > 0) {
			String stampValue = status == 1? "on" : "off";
			StampingService stampingService = new StampingService();
			UserDao userDao = new UserDao();
			String operator = userDao.getUser(operatorId).getUsername();
			String ipAddress = request.getRemoteAddr();

			stampingService.writeStamp(0, "toggle_antiHawking", "ctm", Vertical.VerticalType.SIMPLES.getCode().toLowerCase(), "simples.message_config/hawking/status", stampValue, operator, "Altered via simples.jsp: /simples/hawking/toggle", ipAddress);
		}
	}
	public static int getHawkingStatus() throws DaoException {
		MessageConfigDao messageConfigDao = new MessageConfigDao();
		return messageConfigDao.getStatus();
	}
	public List<MessageConfig> getCurrentMessageConfigList() throws DaoException {
		MessageConfigDao messageConfigDao = new MessageConfigDao();
		return messageConfigDao.getCurrentMessageConfigList();
	}

	/**
	 * This function gives map of 2 lists
	 * 1) list of states where current time in hawking hours (key value: statesInHawkingPeriod)
	 * 2) list of states where current time outside hawking hours(key value: statesOutOfHawkingPeriod)
	 * based on hawking hours in the database
	 * eg.
	 * {"statesOutOfHawkingPeriod":["ACT","NSW","QLD","TAS","WA","VIC"],"statesInHawkingPeriod":["NT","SA"]}
	 *
	 * @param authenticatedData
	 * @param applicationDate
	 * @return
	 * @throws ParseException
	 */
	public Map<String, List<String>> getStatesMapForHawkingTime(Date applicationDate, List<MessageConfig> hawkingHours) throws ParseException {
		Map<String, List<String>> statesInHawkingTime = new HashMap<>();
		List<String> statesInHawkingPeriod = new ArrayList<>();
		List<String> statesOutOfHawkingPeriod = new ArrayList<>();

		Calendar c = Calendar.getInstance();
		c.setFirstDayOfWeek(Calendar.SUNDAY);
		c.setTime(applicationDate);

		//logger.debug("Hawking hours --> Today is " + c.get(Calendar.DAY_OF_WEEK) + " Day of the week , Date : " + applicationDate);

		for (MessageConfig hawkingHour : hawkingHours) {
			if (c.get(Calendar.DAY_OF_WEEK) == hawkingHour.getDayOfWeek() && hawkingHour.getStartTime() != null && hawkingHour.getEndTime() != null) {
				Date startDate = DateUtils.mergeDateAndTimeHHmmss(applicationDate, hawkingHour.getStartTime());
				Date endDate = DateUtils.mergeDateAndTimeHHmmss(applicationDate, hawkingHour.getEndTime());
				for (StateTimeZones t : StateTimeZones.values()) {
					Date date1 = DateUtils.convertDateForTimeZone(applicationDate, t.getTimeZone());
					if (DateUtils.isDateInRange(date1, startDate, endDate)) {
						statesInHawkingPeriod.add(t.name());
					} else {
						statesOutOfHawkingPeriod.add(t.name());
					}
					//logger.debug("Hawking hours --> Time in " + t.name() + " : '" + date1 + "'");
					//logger.debug("Hawking hours --> Hawking hours from '" + startDate + "' to '" + endDate + "'");
				}
			}
		}
		// if both list are empty add all states to out of hawking hours list
		if (statesInHawkingPeriod.isEmpty() && statesOutOfHawkingPeriod.isEmpty()) {
			for (StateTimeZones t : StateTimeZones.values()) {
				statesOutOfHawkingPeriod.add(t.name());
			}
		}
		statesInHawkingTime.put("statesInHawkingPeriod", statesInHawkingPeriod);
		statesInHawkingTime.put("statesOutOfHawkingPeriod", statesOutOfHawkingPeriod);
		return statesInHawkingTime;
	}

	public Map<String, List<String>> getStatesMapForHawkingTime(final HttpServletRequest request, List<MessageConfig> hawkingHours) throws ParseException {
		Date applicationDate = ApplicationService.getApplicationDate(request);
		return getStatesMapForHawkingTime(applicationDate, hawkingHours);
	}
}