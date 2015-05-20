package com.ctm.services.simples;

import com.ctm.dao.simples.OpeningHoursDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.helper.simples.OpeningHoursHelper;
import com.ctm.model.OpeningHours;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;
import com.ctm.utils.RequestUtils;
import com.ctm.web.validation.SchemaValidationError;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

public class OpeningHoursService {

	private final OpeningHoursDao openingHoursDao = new OpeningHoursDao();
	private final OpeningHoursHelper openingHoursHelper = new OpeningHoursHelper();
	public static final String dateField = "date";
	public static final String sequenceField = "daySequence";
	public OpeningHoursService() {
	}

	public List<OpeningHours> getAllHours(HttpServletRequest request)  {
		try {
			List<OpeningHours> openingHours;
			String hoursType = request.getParameter("hoursType");
			openingHours = openingHoursDao.fetchOpeningHours(!(hoursType != null && hoursType.trim().equalsIgnoreCase("n")), 0);
			return openingHours;
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}

	}

	public List<SchemaValidationError> validateOpeningHoursData(HttpServletRequest request){
		OpeningHours openingHours = new OpeningHours();
		openingHours = RequestUtils.createObjectFromRequest(request, openingHours);
		return openingHoursHelper.validateHoursRowData(openingHours);
	}

	public OpeningHours updateOpeningHours(HttpServletRequest request,AuthenticatedData authenticatedData)  {
		try {
			OpeningHours openingHours = new OpeningHours();
			openingHours = RequestUtils.createObjectFromRequest(request, openingHours);
			final String userName = authenticatedData.getUid();
			final String ipAddress = request.getRemoteAddr();
			return openingHoursDao.updateOpeningHours(openingHours,userName,ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}

	public OpeningHours createOpeningHours(HttpServletRequest request,AuthenticatedData authenticatedData){
		try {
			OpeningHours openingHours = new OpeningHours();
			openingHours = RequestUtils.createObjectFromRequest(request, openingHours);
			final String userName = authenticatedData.getUid();
			final String ipAddress = request.getRemoteAddr();
			return openingHoursDao.createOpeningHours(openingHours,userName,ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}

	public String deleteOpeningHours(HttpServletRequest request,AuthenticatedData authenticatedData){
		try {
			final String userName = authenticatedData.getUid();
			final String ipAddress = request.getRemoteAddr();
			return openingHoursDao.deleteOpeningHours(request.getParameter("openingHoursId"),userName,ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}

	public List<OpeningHours> getAllOpeningHoursForDisplay(
			HttpServletRequest request, boolean isSpecial) throws DaoException,
			ConfigSettingException {
		PageSettings pageSettings = SettingsService
				.getPageSettingsForPage(request);
		int verticalId = pageSettings.getVertical().getId();
		Date serverDate = ApplicationService.getApplicationDate(request);

		return openingHoursDao.getAllOpeningHoursForDisplay(verticalId,
				serverDate, isSpecial);
	}

	public String getOpeningHoursForDisplay(HttpServletRequest request,String dayType) throws DaoException {
		Date serverDate = ApplicationService.getApplicationDate(request);
		return openingHoursDao.getOpeningHoursForDisplay(dayType, serverDate);
	}

}
