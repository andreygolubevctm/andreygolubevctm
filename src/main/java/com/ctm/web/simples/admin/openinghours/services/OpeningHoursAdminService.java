package com.ctm.web.simples.admin.openinghours.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.openinghours.helper.AdminOpeningHoursHelper;
import com.ctm.web.simples.admin.openinghours.dao.OpeningHoursAdminDao;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

public class OpeningHoursAdminService {

	private final OpeningHoursAdminDao openingHoursAdminDao = new OpeningHoursAdminDao();
	private final AdminOpeningHoursHelper adminOpeningHoursHelper = new AdminOpeningHoursHelper();
	public static final String dateField = "date";
	public static final String sequenceField = "daySequence";
	private final IPAddressHandler ipAddressHandler;

	public OpeningHoursAdminService(IPAddressHandler ipAddressHandler) {
		this.ipAddressHandler =  ipAddressHandler;
	}

	public List<OpeningHours> getAllHours(HttpServletRequest request)  {
		try {
			List<OpeningHours> openingHours;
			String hoursType = request.getParameter("hoursType");
			openingHours = openingHoursAdminDao.fetchOpeningHours(!(hoursType != null && hoursType.trim().equalsIgnoreCase("n")), 0);
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
			List<OpeningHours> clashingOpeningHours = openingHoursAdminDao.findClashingHoursCount(openingHours);
			validations = adminOpeningHoursHelper.validateHoursRowData(openingHours);
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
			final String ipAddress = ipAddressHandler.getIPAddress(request);
			return openingHoursAdminDao.updateOpeningHours(openingHours,userName,ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}

	public OpeningHours createOpeningHours(HttpServletRequest request,AuthenticatedData authenticatedData){
		try {
			OpeningHours openingHours = new OpeningHours();
			openingHours = RequestUtils.createObjectFromRequest(request, openingHours);
			final String userName = authenticatedData.getUid();
			final String ipAddress = ipAddressHandler.getIPAddress(request);
			return openingHoursAdminDao.createOpeningHours(openingHours, userName, ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}

	public String deleteOpeningHours(HttpServletRequest request,AuthenticatedData authenticatedData){
		try {
			final String userName = authenticatedData.getUid();
			final String ipAddress = ipAddressHandler.getIPAddress(request);
			return openingHoursAdminDao.deleteOpeningHours(request.getParameter("openingHoursId"), userName, ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}
}