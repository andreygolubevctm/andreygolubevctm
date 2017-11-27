package com.ctm.web.health.services;

import java.time.*;
import com.ctm.web.health.model.HealthFundTimeZone;
import com.ctm.web.health.model.HealthFundTimeZoneResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class HealthFundTimeZoneService {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthFundTimeZoneService.class);

    // Application and submit cutoff times
    private static final int APPLICATION_TEST_HOURS = 23;
    private static final int APPLICATION_TEST_MINS = 45;
    private static final int SUBMIT_TEST_HOURS = 23;
    private static final int SUBMIT_TEST_MINS = 59;

    /**
     * get() Returns a repsonse confirming whether the current time is before the cutoff time
     * as per the fund timezone.
     * @param fundCode
     * @return
     */
    public HealthFundTimeZoneResponse get(String fundCode) throws Exception {
        ZoneId zoneId = HealthFundTimeZone.getByCode(fundCode);
        if(zoneId == null) {
            String copy = "Invalid fund code (" + fundCode + ") received by HealthFundTimeZoneService";
            LOGGER.error(copy);
            throw new Exception(copy);
        }
        return new HealthFundTimeZoneResponse(isApplicationTimeValid(zoneId), isSubmitTimeValid(zoneId));
    }

    private boolean isApplicationTimeValid(ZoneId zoneId) {
        return isTimeValid(zoneId, APPLICATION_TEST_HOURS, APPLICATION_TEST_MINS);
    }

    private boolean isSubmitTimeValid(ZoneId zoneId) {
        return isTimeValid(zoneId, SUBMIT_TEST_HOURS, SUBMIT_TEST_MINS);
    }

    /**
     * isValidTime confirms whether the current time before the cutoff time (of same day)
     * @param zoneId
     * @param cutoff_hours
     * @param cutoff_minutes
     * @return
     */
    private boolean isTimeValid(ZoneId zoneId, int cutoff_hours, int cutoff_minutes) {
        ZonedDateTime current = Instant.now().atZone(zoneId);
        ZonedDateTime cutoff = ZonedDateTime.of(LocalDate.of(YearMonth.now().getYear(), YearMonth.now().getMonth(),
                LocalDate.now().getDayOfMonth()), LocalTime.of ( cutoff_hours , cutoff_minutes ), zoneId);
        return current.compareTo(cutoff) < 0;
    }
}