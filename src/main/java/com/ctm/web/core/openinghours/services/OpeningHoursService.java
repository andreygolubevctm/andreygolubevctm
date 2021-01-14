package com.ctm.web.core.openinghours.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.openinghours.dao.OpeningHoursDao;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.common.utils.DateUtils;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Component
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

    public boolean isCallCentreOpen(final int verticalId, final LocalDateTime effectiveDate) throws DaoException {
        return openingHoursDao.isCallCentreOpen(verticalId, effectiveDate);
    }

    public boolean isCallCentreOpenNow(final int verticalId, HttpServletRequest request) throws DaoException {
        Date theAppDate = ApplicationService.getApplicationDate(request);
        LocalDateTime theLocalAppDate =  DateUtils.toLocalDateTime(theAppDate);
        return openingHoursDao.isCallCentreOpen(verticalId, theLocalAppDate);
    }
}
