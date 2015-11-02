package com.ctm.web.simples.admin.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.model.OpeningHours;
import com.ctm.web.simples.admin.model.request.OpeningHoursHelper;
import com.ctm.web.simples.dao.OpeningHoursDao;

import javax.servlet.ServletException;
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

	/**
	 * Method validates opening hours details send via request an returns list of schemaValidationErros
	 * @param request
	 * @return
	 * @throws ServletException
	 */
	public List<SchemaValidationError> validateOpeningHoursData(HttpServletRequest request) throws ServletException {
		List<SchemaValidationError> validations =null;
		try {
			PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request,"HEALTH");
			int verticalId = pageSettings.getVertical().getId();
			OpeningHours openingHours = new OpeningHours();
			openingHours = RequestUtils.createObjectFromRequest(request, openingHours);
			openingHours.setVerticalId(verticalId);
			List<OpeningHours> clashingOpeningHours = openingHoursDao.findClashingHoursCount(openingHours);
			validations = openingHoursHelper.validateHoursRowData(openingHours);
			if (clashingOpeningHours.size() > 0) {
				SchemaValidationError error = new SchemaValidationError();
				error.setElements("effectiveStart , effectiveEnd");
				error.setMessage("Record already exist with  overlapping date limits " + clashingOpeningHours.get(0).getEffectiveStart() + " to "
						+ clashingOpeningHours.get(0).getEffectiveEnd());
				validations.add(error);
			}
		}catch (ConfigSettingException | DaoException e){
			throw  new ServletException("Error while validating opening hours",e);
		}
		return validations;
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
			return openingHoursDao.createOpeningHours(openingHours, userName, ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}

	public String deleteOpeningHours(HttpServletRequest request,AuthenticatedData authenticatedData){
		try {
			final String userName = authenticatedData.getUid();
			final String ipAddress = request.getRemoteAddr();
			return openingHoursDao.deleteOpeningHours(request.getParameter("openingHoursId"), userName, ipAddress);
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

	public String getOpeningHoursForDisplay(HttpServletRequest request,String dayType) throws DaoException,ConfigSettingException {
		PageSettings pageSettings = SettingsService
				.getPageSettingsForPage(request);
		int verticalId = pageSettings.getVertical().getId();
		Date serverDate = ApplicationService.getApplicationDate(request);
		return openingHoursDao.getOpeningHoursForDisplay(dayType, serverDate,verticalId);
	}

	public String getCurrentOpeningHoursForEmail(HttpServletRequest request) throws DaoException, ConfigSettingException {
		String currentOpeningHours;
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
		int verticalId = pageSettings.getVertical().getId();
		Date serverDate = ApplicationService.getApplicationDate(request);
		List<OpeningHours> openingHoursList = openingHoursDao.getCurrentNormalOpeningHoursForEmail(verticalId, serverDate);
		currentOpeningHours = openingHoursDao.toHTMLString(openingHoursList);
		return currentOpeningHours;
	}
}