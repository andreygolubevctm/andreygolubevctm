package com.ctm.web.core.dao;


import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.core.model.OpeningHours;
import com.ctm.web.simples.admin.model.request.OpeningHoursHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class OpeningHoursDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(OpeningHoursDao.class);
    private final OpeningHoursHelper helper = new OpeningHoursHelper();

    /**
     * This method will return data to display on website verticalId : must be
     * pass to display opening hours for respective vertical effectiveDate : is
     * the server date and must be pass isSpecial : if 'true' returns special
     * hours records else returns normal hours
     *
     * @param verticalId
     * @param effectiveDate
     * @param isSpecial
     * @return
     * @throws DaoException
     */
    public List<OpeningHours> getAllOpeningHoursForDisplay(int verticalId, Date effectiveDate, boolean isSpecial) throws DaoException {
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        List<OpeningHours> mapOpeningHoursDetails = new ArrayList<>();
        try {
            PreparedStatement stmt;
            String sql = "SELECT daySequence, startTime,endTime,description, date FROM ctm.opening_hours "
                    + "where ? between effectiveStart and effectiveEnd and verticalId=? ";
            if (isSpecial) {
                sql += " and date is not null  and date between  ? and ?  and hoursType='S'  order by date";
            } else {
                sql += "  and date is null  and hoursType='N' order by daySequence";
            }
            stmt = dbSource.getConnection().prepareStatement(sql);
            stmt.setDate(1, new java.sql.Date(effectiveDate.getTime()));
            stmt.setInt(2, verticalId);
            if (isSpecial) {
                stmt.setDate(3, new java.sql.Date(effectiveDate.getTime()));
                stmt.setDate(4, new java.sql.Date(DateUtils.addDays(effectiveDate, 20).getTime()));
            }

            ResultSet resultSet = stmt.executeQuery();

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
            return mapOpeningHoursDetails;
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to get opening hours for display {}, {}, {}", kv("verticalId", verticalId), kv("effectiveDate", effectiveDate), kv("isSpecial", isSpecial), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
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
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
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
            dbSource.closeConnection();
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
     * this method returns string representation of opening hours to display on
     * the website header dayDescription : can only be "today" or "tomorrow"
     *
     * @param dayDescription
     * @param effectiveDate
     * @return
     * @throws DaoException
     */
    public String getOpeningHoursForDisplay(String dayDescription, Date effectiveDate, int verticalId) throws DaoException {
        String openingHours = null;
        ResultSet resultSet;
        SimpleDatabaseConnection dbSource =  new SimpleDatabaseConnection();
        try {
            PreparedStatement stmt;
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT startTime,endTime,description, date FROM ctm.opening_hours "
                            + "WHERE" +
                            " ? between effectiveStart and effectiveEnd and" +
                            " (lower(description) = ?  AND hoursType  ='N') or (date = ? AND hoursType  ='S') AND" +
                            " verticalId = ?" +
                            " ORDER BY date DESC  LIMIT 1;");
            String day = new SimpleDateFormat("EEEE").format(
                    dayDescription.equalsIgnoreCase("tomorrow") ? DateUtils.addDays(effectiveDate, 1) : effectiveDate).toLowerCase();
            java.sql.Date dayDate = new java.sql.Date((dayDescription.equalsIgnoreCase("tomorrow") ? DateUtils.addDays(effectiveDate, 1)
                    : effectiveDate).getTime());
            java.sql.Date sqlEffectiveDate = new java.sql.Date(effectiveDate.getTime());
            stmt.setDate(1, sqlEffectiveDate);
            stmt.setString(2, day);
            stmt.setDate(3, dayDate);
            stmt.setInt(4, verticalId);
            resultSet = stmt.executeQuery();

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
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed while getting opening hours for display {}, {}, {}", kv("dayDescription", dayDescription), kv("effectiveDate", effectiveDate), kv("verticalId", verticalId));
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }

}
