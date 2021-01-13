package com.ctm.web.core.openinghours.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.openinghours.dao.OpeningHoursDao;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.services.SettingsService;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;

import static com.ctm.web.core.services.ApplicationService.getApplicationDate;
import static com.ctm.web.core.utils.common.utils.DateUtils.toLocalDateTime;

@Component
public class OpeningHoursService {

    private final OpeningHoursDao openingHoursDao;

    public OpeningHoursService() {
        openingHoursDao = new OpeningHoursDao();
    }

    public List<OpeningHours> getAllOpeningHoursForDisplay(final HttpServletRequest request) throws DaoException, ConfigSettingException {
        return openingHoursDao.getAllOpeningHoursForDisplay(getVerticalId(request), getApplicationDate(request));
    }

    public String getCurrentOpeningHoursForEmail(HttpServletRequest request) throws DaoException, ConfigSettingException {
        List<OpeningHours> openingHoursList = openingHoursDao.getCurrentNormalOpeningHoursForEmail(
                getVerticalId(request), getApplicationDate(request));
        return openingHoursDao.toHTMLString(openingHoursList);
    }

    public String getOpeningHoursForDisplay(HttpServletRequest request, String dayType) throws DaoException, ConfigSettingException {
        return openingHoursDao.getOpeningHoursForDisplay(dayType, getApplicationDate(request), getVerticalId(request));
    }

    public boolean isCallCentreOpen(final int verticalId, final LocalDateTime effectiveDate) throws DaoException {
        return openingHoursDao.isCallCentreOpen(verticalId, effectiveDate);
    }

    public boolean isCallCentreOpenNow(final int verticalId, HttpServletRequest request) throws DaoException {
        return openingHoursDao.isCallCentreOpen(verticalId, toLocalDateTime(getApplicationDate(request)));
    }

    private int getVerticalId(HttpServletRequest request) throws DaoException, ConfigSettingException {
        return SettingsService.getPageSettingsForPage(request).getVertical().getId();
    }
}
