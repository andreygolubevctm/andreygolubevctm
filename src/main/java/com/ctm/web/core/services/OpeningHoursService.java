package com.ctm.web.core.services;

import com.ctm.web.core.dao.OpeningHoursDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.OpeningHours;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;


public class OpeningHoursService {

    private final OpeningHoursDao openingHoursDao;

    public OpeningHoursService(){
        openingHoursDao = new OpeningHoursDao();
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

    public String getCurrentOpeningHoursForEmail(HttpServletRequest request) throws DaoException, ConfigSettingException {
        String currentOpeningHours;
        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
        int verticalId = pageSettings.getVertical().getId();
        Date serverDate = ApplicationService.getApplicationDate(request);
        List<OpeningHours> openingHoursList = openingHoursDao.getCurrentNormalOpeningHoursForEmail(verticalId, serverDate);
        currentOpeningHours = openingHoursDao.toHTMLString(openingHoursList);
        return currentOpeningHours;
    }

    public String getOpeningHoursForDisplay(HttpServletRequest request,String dayType) throws DaoException,ConfigSettingException {
        PageSettings pageSettings = SettingsService
                .getPageSettingsForPage(request);
        int verticalId = pageSettings.getVertical().getId();
        Date serverDate = ApplicationService.getApplicationDate(request);
        return openingHoursDao.getOpeningHoursForDisplay(dayType, serverDate,verticalId);
    }
}
