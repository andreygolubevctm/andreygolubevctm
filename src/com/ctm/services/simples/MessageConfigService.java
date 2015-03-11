package com.ctm.services.simples;

import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;

import com.ctm.dao.UserDao;
import com.ctm.dao.simples.MessageConfigDao;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.StampingService;
import com.ctm.exceptions.DaoException;

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
}