package com.ctm.web.core.openinghours.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.openinghours.helper.OpeningHoursHelper;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.utils.common.utils.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class OpeningHoursDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(OpeningHoursDao.class);
    private final OpeningHoursHelper helper = new OpeningHoursHelper();
    private final SimpleDatabaseConnection dbSource;

    public OpeningHoursDao() {
        this.dbSource = new SimpleDatabaseConnection();
    }

    public OpeningHoursDao(final SimpleDatabaseConnection dbSource) {
        this.dbSource = dbSource;
    }

    /**
     * Get data to display on website
     *
     * @param verticalId Required to display opening hours for respective vertical
     * @param effectiveDate Required. The effective datetime.
     * @param isSpecial If true returns special hours records else returns normal hours
     * @return Data to display on website
     */
    public List<OpeningHours> getAllOpeningHoursForDisplay(int verticalId, Date effectiveDate, boolean isSpecial) throws DaoException {
        String sql = "SELECT daySequence, startTime,endTime,description, date FROM ctm.opening_hours "
                + "where ? between effectiveStart and effectiveEnd and verticalId=? ";
        if (isSpecial) {
            sql += " and date is not null  and date between  ? and ?  and hoursType='S'  order by date";
        } else {
            sql += "  and date is null  and hoursType='N' order by daySequence";
        }
        try (PreparedStatement stmt = dbSource.getConnection().prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(effectiveDate.getTime()));
            stmt.setInt(2, verticalId);
            if (isSpecial) {
                stmt.setDate(3, new java.sql.Date(effectiveDate.getTime()));
                stmt.setDate(4, new java.sql.Date(DateUtils.addDays(effectiveDate, 20).getTime()));
            }
            List<OpeningHours> mapOpeningHoursDetails = new ArrayList<>();

            try (ResultSet resultSet = stmt.executeQuery()) {
                while (resultSet.next()) {
                    String startTime, endTime;
                    OpeningHours openingHours = new OpeningHours();
                    startTime = helper.getFormattedHours(resultSet.getString("startTime"));
                    endTime = helper.getFormattedHours(resultSet.getString("endTime"));
                    if (!Objects.equals(startTime, "") && !Objects.equals(endTime, "")) {
                        openingHours.setStartTime(startTime);
                        openingHours.setEndTime(endTime);
                    } else {
                        openingHours.setStartTime(null);
                        openingHours.setEndTime(null);
                    }
                    openingHours.setDescription(resultSet.getString("description"));
                    openingHours.setDate(resultSet.getDate("date") != null ? new SimpleDateFormat("dd-MM-yyyy").format(resultSet
                            .getDate("date")) : "");
                    mapOpeningHoursDetails.add(openingHours);
                }
            }
            return mapOpeningHoursDetails;
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to get opening hours for display {}, {}, {}", kv("verticalId", verticalId), kv("effectiveDate", effectiveDate), kv("isSpecial", isSpecial), e);
            throw new DaoException(e);
        } finally {
            if (dbSource != null) {
                dbSource.closeConnection();
            }
        }
    }

    /**
     * This method returns compact list of all current opening hours objects
     * and is being used in E-mails right now
     *
     * @param verticalId
     * @param effectiveDate
     * @return
     * @throws DaoException #example
     *                      Consider the openinghours table has following normal hours
     *                      Day         StartTime   EndTime
     *                      Monday	    08:00:00	22:00:00
     *                      Tuesday	    08:00:00	22:00:00
     *                      Wednesday	08:00:00	22:00:00
     *                      Thursday	08:00:00	22:00:00
     *                      Friday	    09:00:00	23:00:00
     *                      Saturday	10:00:00	24:00:00
     *                      Sunday	    10:00:00	24:00:00
     *                      <p/>
     *                      then function will return a compact list like below     *
     *                      Day         StartTime   EndTime
     *                      Mon-Thu	    08:00:00	22:00:00
     *                      Fri 	    09:00:00	23:00:00
     *                      Sat-Sun	    10:00:00	24:00:00
     */
    public List<OpeningHours> getCurrentNormalOpeningHoursForEmail(int verticalId, Date effectiveDate) throws DaoException {
        List<OpeningHours> openingHoursList = new ArrayList<>();
        try {
            PreparedStatement stmt;
            String sql = "SELECT SUBSTR(description, 1, 3) description, " +
                    "        daysequence,\n" +
                    "        startTime,\n" +
                    "        endTime,\n" +
                    "        date\n" +
                    " FROM   ctm.opening_hours\n" +
                    " WHERE  ? BETWEEN effectiveStart AND effectiveEnd\n" +
                    "        AND verticalId = ? " +
                    " AND date IS NULL AND hourstype='N' ORDER BY daysequence";

            stmt = dbSource.getConnection().prepareStatement(sql);
            stmt.setDate(1, new java.sql.Date(effectiveDate.getTime()));
            stmt.setInt(2, verticalId);
            ResultSet resultSet = stmt.executeQuery();

            String startTime, endTime, dayDesc, firstDayDesc = "",
                    startTimePrev = "", endTimePrev = "", dayDescPrev = "", description;
            boolean isFirstRec = true;
            while (resultSet.next()) {
                startTime = helper.getFormattedHours(resultSet.getString("startTime"));
                endTime = helper.getFormattedHours(resultSet.getString("endTime"));
                dayDesc = resultSet.getString("description");
                if (isFirstRec) {
                    firstDayDesc = dayDesc;
                    isFirstRec = false;
                } else {
                    if (!(startTime.equalsIgnoreCase(startTimePrev) && endTime.equalsIgnoreCase(endTimePrev))) {
                        OpeningHours openingHours;
                        if (firstDayDesc.equalsIgnoreCase(dayDescPrev)) {
                            description = firstDayDesc;
                        } else {
                            description = firstDayDesc + " - " + dayDescPrev;
                        }
                        firstDayDesc = dayDesc;
                        openingHours = helper.createOpeningHoursObject(0, null, null, description, null, null, endTimePrev.equals("") ? null : endTimePrev, null,
                                startTimePrev.equals("") ? null : startTimePrev, 0);
                        openingHoursList.add(openingHours);
                    }
                }
                startTimePrev = startTime;
                endTimePrev = endTime;
                dayDescPrev = dayDesc;
            }
            //add the last record in the list
            OpeningHours openingHours;
            if (!firstDayDesc.equals("")) {
                if (firstDayDesc.equalsIgnoreCase(dayDescPrev)) {
                    description = firstDayDesc.length() > 3 ? firstDayDesc.substring(0, 3) : firstDayDesc;
                } else {
                    description = firstDayDesc + " - " + dayDescPrev;
                }
                openingHours = helper.createOpeningHoursObject(0, null, null, description, null, null, endTimePrev.equals("") ? null : endTimePrev, null,
                        startTimePrev.equals("") ? null : startTimePrev, 0);
                openingHoursList.add(openingHours);
            }
            return openingHoursList;
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed while executing getting current normal opening hours for email {}, {}", kv("verticalId", verticalId), kv("effectiveDate", effectiveDate), e);
            throw new DaoException(e);
        } finally {
            if (dbSource != null) {
                dbSource.closeConnection();
            }
        }
    }

    public String toHTMLString(List<OpeningHours> openingHoursList) {
        String str = "";
        for (OpeningHours openingHours : openingHoursList) {
            if((openingHours.getStartTime()==null || openingHours.getStartTime().equals("")) ||
                    (openingHours.getEndTime()==null || openingHours.getEndTime().equals(""))){
                str += openingHours.getDescription() + ": Closed <br>";
            }else {
                str += openingHours.getDescription() + ": " + openingHours.getStartTime() + " - " + openingHours.getEndTime() + "<br>";
            }
        }
        return str;
    }

    /**
     * Get string representation of opening hours to display on the website header
     *
     * @param dayDescription Can only be "today" or "tomorrow"
     * @param effectiveDate Effective date
     * @param verticalId Vertical Id
     */
    public String getOpeningHoursForDisplay(String dayDescription, Date effectiveDate, int verticalId) throws DaoException {
        String openingHours = null;
        try {
            ResultSet resultSet = getPreparedStatementForOneDay(dayDescription, DateUtils.toLocalDateTime(effectiveDate).toLocalDate(), verticalId);

            while (resultSet.next()) {
                String startTime, endTime;
                startTime = helper.getFormattedHours(resultSet.getString("startTime"));
                endTime = helper.getFormattedHours(resultSet.getString("endTime"));
                if (!Objects.equals(startTime, "") && !Objects.equals(endTime, "")) {
                    openingHours = helper.trimHours(startTime) + " - " + helper.trimHours(endTime);
                } else {
                    openingHours = "closed";
                }
            }
            return openingHours;
        } catch (DaoException | SQLException e) {
            LOGGER.error("Failed while getting opening hours for display {}, {}, {}", kv("dayDescription", dayDescription), kv("effectiveDate", effectiveDate), kv("verticalId", verticalId));
            throw new DaoException(e);
        }
    }

    public boolean isCallCentreOpen(final int verticalId, final LocalDateTime effectiveDate) throws DaoException {
        try {
            ResultSet resultSet = getPreparedStatementForOneDay("today", effectiveDate.toLocalDate(), verticalId);

            if (resultSet.next()) {
                LocalTime effectiveTime = effectiveDate.toLocalTime();
                Optional<LocalTime> startTime = Optional.ofNullable(resultSet.getTime("startTime")).map(Time::toLocalTime);
                Optional<LocalTime> endTime = Optional.ofNullable(resultSet.getTime("endTime")).map(Time::toLocalTime);
                if (
                        (startTime.isPresent() && (effectiveTime.equals(startTime.get()) || effectiveTime.isAfter(startTime.get())))
                        && (!endTime.isPresent() || (endTime.isPresent() && effectiveTime.isBefore(endTime.get())))
                        ) {
                    return true;
                }
            }
            return false;
        } catch (DaoException | SQLException e) {
            LOGGER.error("Failed to check if call centre is open now. {}, {}", kv("verticalId", verticalId), kv("effectiveDate", effectiveDate));
            throw new DaoException(e);
        }
    }

    protected ResultSet getPreparedStatementForOneDay(final String dayDescription, final LocalDate effectiveDate,
                                                    final int verticalId) throws DaoException {
        try {
            PreparedStatement stmt;
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT startTime, endTime, description, date FROM ctm.opening_hours "
                            + "WHERE" +
                            " ? BETWEEN effectiveStart AND effectiveEnd" +
                            " AND ((LOWER(description) = ? AND hoursType = 'N') OR (date = ? AND hoursType = 'S'))" +
                            " AND verticalId = ?" +
                            " ORDER BY date DESC LIMIT 1");
            LocalDate dayDate = dayDescription.equalsIgnoreCase("tomorrow")
                    ? effectiveDate.plusDays(1)
                    : effectiveDate;
            String day = dayDate.format(DateTimeFormatter.ofPattern("EEEE")).toLowerCase();
            stmt.setDate(1, java.sql.Date.valueOf(effectiveDate));
            stmt.setString(2, day);
            stmt.setDate(3, java.sql.Date.valueOf(dayDate));
            stmt.setInt(4, verticalId);
            return stmt.executeQuery();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            if (dbSource != null) {
                dbSource.closeConnection();
            }
        }
    }

}
