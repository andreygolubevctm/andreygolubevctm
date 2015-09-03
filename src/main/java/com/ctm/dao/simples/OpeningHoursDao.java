package com.ctm.dao.simples;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.dao.AuditTableDao;
import com.ctm.exceptions.DaoException;
import com.ctm.helper.simples.OpeningHoursHelper;
import com.ctm.model.OpeningHours;
import com.ctm.utils.common.utils.DateUtils;
import com.mysql.jdbc.Statement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

import static com.ctm.logging.LoggingArguments.kv;

public class OpeningHoursDao {
	private static final Logger logger = LoggerFactory.getLogger(OpeningHoursDao.class.getName());
    private final OpeningHoursHelper helper = new OpeningHoursHelper();
    private final AuditTableDao auditTableDao = new AuditTableDao();
    private static boolean autoCommit = true;
    private final SimpleDateFormat sdfUI = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * this method will return single record if ID exist else return null
     *
     * @param openingHoursId : Unique identifier of opening hours record
     */
    private OpeningHours fetchSingleRecOpeningHours(int openingHoursId) throws DaoException {
        OpeningHours openingHours;
        List<OpeningHours> openingHoursList = fetchOpeningHours(true, openingHoursId);
        openingHours = openingHoursList.isEmpty() ? null : openingHoursList.get(0);
        return openingHours;
    }

    /**
     * this method will fetch all the opening hours record from database
     *
     * @param isSpecial      : if 'True' it will return all special hours else will return
     * @param openingHoursId : if 0 return all results else return the  specific one
     */
    public List<OpeningHours> fetchOpeningHours(boolean isSpecial, int openingHoursId) throws DaoException {
        SimpleDatabaseConnection dbSource;
        List<OpeningHours> openingHoursList = new ArrayList<>();
        PreparedStatement stmt;
        dbSource = new SimpleDatabaseConnection();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT openingHoursId,date,daySequence,description,hoursType,effectiveEnd,effectiveStart,endTime,"
                            + "verticalId,startTime FROM ctm.opening_hours where  ");
            if (openingHoursId != 0) {
                sql.append(" openingHoursId = ?  ");
            } else {
                if (isSpecial) {
                    sql.append(" hoursType='S'  order by effectiveStart desc");
                } else {
                    sql.append(" hoursType='N' order by daySequence");
                }
            }
            stmt = dbSource.getConnection().prepareStatement(sql.toString());
            if (openingHoursId != 0) {
                stmt.setInt(1, openingHoursId);
            }
            ResultSet resultSet = stmt.executeQuery();
            while (resultSet.next()) {
                OpeningHours openingHours = helper.createOpeningHoursObject(resultSet.getInt("openingHoursId"),
                        resultSet.getDate("date") != null ? sdfUI.format(resultSet.getDate("date")) : "", resultSet.getString("daySequence"),
                        resultSet.getString("description"),
                        resultSet.getDate("effectiveEnd") != null ? sdfUI.format(resultSet.getDate("effectiveEnd")) : "",
                        resultSet.getDate("effectiveStart") != null ? sdfUI.format(resultSet.getDate("effectiveStart")) : "",
                        resultSet.getString("endTime"), resultSet.getString("hoursType"), resultSet.getString("startTime"),
                        resultSet.getInt("verticalId"));
                openingHoursList.add(openingHours);
            }
            return openingHoursList;
        } catch (SQLException | NamingException e) {
            logger.error("Failed to retrieve Opening Hours {}, {}", kv("isSpecial", isSpecial), kv("openingHoursId", openingHoursId), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }

    /**
     * This method will delete record associated with supplied ID
     *
     * @param openingHoursId : Unique identifier of opening hours
     * @param userName       : userName of the user who has logged in during the session
     */
    public String deleteOpeningHours(String openingHoursId, String userName, String ipAddress) throws DaoException {
        SimpleDatabaseConnection dbSource;
        PreparedStatement stmt;
        if (openingHoursId == null || openingHoursId.trim().equalsIgnoreCase("")) {
            return "Opening Hours Id is null";
        }
        dbSource = new SimpleDatabaseConnection();
        try {
            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            auditTableDao.auditAction("opening_hours", "openingHoursId", Integer.parseInt(openingHoursId.trim()), userName, ipAddress,
                    AuditTableDao.DELETE, dbSource.getConnection());
            stmt = dbSource.getConnection().prepareStatement("DELETE FROM opening_hours WHERE openingHoursId = ?");
            stmt.setInt(1, Integer.parseInt(openingHoursId.trim()));
            stmt.executeUpdate();
            dbSource.getConnection().commit();
            return "success";
        } catch (SQLException | NamingException e) {
            logger.error("Failed to delete Opening Hours {}, {}, {}", kv("openingHoursId", openingHoursId), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
    }

    /**
     * This method will update record as per data in "openingHoursParams"
     *
     * @param openingHoursParams : OpeningHours object
     * @param userName           : userName of the user who has logged in during the session
     */
    public OpeningHours updateOpeningHours(OpeningHours openingHoursParams, String userName, String ipAddress) throws DaoException {
        OpeningHours openingHours = new OpeningHours();
        SimpleDatabaseConnection dbSource;
        int openingHoursId;
        PreparedStatement stmt;
        dbSource = new SimpleDatabaseConnection();
        try {

            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            openingHoursId = openingHoursParams.getOpeningHoursId();
            if (openingHoursId == 0) {
                throw new DaoException("failed : openingHoursId is null");
            }
            stmt = dbSource.getConnection().prepareStatement(" UPDATE opening_hours SET  daySequence = ?,startTime=?, endTime = ?, hoursType = ?, description = ?," +
                    "date = ?, effectiveStart = ?, effectiveEnd = ?, verticalId = ?  WHERE openingHoursId= ?");
            if (openingHoursParams.getDaySequence() != null && !openingHoursParams.getDaySequence().equals(""))
                stmt.setString(1, openingHoursParams.getDaySequence());
            else
                stmt.setNull(1, Types.NULL);
            if (openingHoursParams.getStartTime() != null && !openingHoursParams.getStartTime().equals(""))
                stmt.setString(2, openingHoursParams.getStartTime());
            else
                stmt.setNull(2, Types.NULL);
            if (openingHoursParams.getEndTime() != null && !openingHoursParams.getEndTime().equals(""))
                stmt.setString(3, openingHoursParams.getEndTime());
            else
                stmt.setNull(3, Types.NULL);
            stmt.setString(4, openingHoursParams.getHoursType());
            stmt.setString(5, openingHoursParams.getDescription());
            if (openingHoursParams.getDate() != null && !openingHoursParams.getDate().equals(""))
                stmt.setDate(6, new java.sql.Date(sdfUI.parse(openingHoursParams.getDate()).getTime()));
            else
                stmt.setNull(6, Types.NULL);
            stmt.setDate(7, new java.sql.Date(sdfUI.parse(openingHoursParams.getEffectiveStart()).getTime()));
            stmt.setDate(8, new java.sql.Date(sdfUI.parse(openingHoursParams.getEffectiveEnd()).getTime()));
            stmt.setInt(9, openingHoursParams.getVerticalId());
            stmt.setInt(10, openingHoursId);
            stmt.executeUpdate();
            auditTableDao.auditAction("opening_hours", "openingHoursId", openingHoursId, userName, ipAddress, AuditTableDao.UPDATE, dbSource.getConnection());
            // Commit these records to the DB before fetching them
            dbSource.getConnection().commit();
            openingHours = fetchSingleRecOpeningHours(openingHoursId);
        } catch (SQLException | NamingException | ParseException e) {
            logger.error("Failed to update Opening Hours {}, {}, {}", kv("openingHours", openingHoursParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
        return openingHours;
    }

    /**
     * This method will create new record in the table and also returns the
     * created record in the object
     *
     * @param openingHoursParams : OpeningHours object
     * @param userName           : userName of the user who has logged in during the session
     */
    public OpeningHours createOpeningHours(OpeningHours openingHoursParams, String userName, String ipAddress) throws DaoException {
        OpeningHours openingHours = new OpeningHours();
        SimpleDatabaseConnection dbSource;
        int openingHoursId = 0;
        dbSource = new SimpleDatabaseConnection();
        PreparedStatement stmt;
        try {
            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            stmt = dbSource.getConnection().prepareStatement(" INSERT INTO ctm.opening_hours " +
                    "(daySequence,startTime,endTime,hoursType,description,date,effectiveStart,effectiveEnd,verticalId)" +
                    " VALUES (?,?,?,?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);
            if (openingHoursParams.getDaySequence() != null && !openingHoursParams.getDaySequence().equals(""))
                stmt.setString(1, openingHoursParams.getDaySequence());
            else
                stmt.setNull(1, Types.NULL);
            if (openingHoursParams.getStartTime() != null && !openingHoursParams.getStartTime().equals(""))
                stmt.setString(2, openingHoursParams.getStartTime());
            else
                stmt.setNull(2, Types.NULL);
            if (openingHoursParams.getEndTime() != null && !openingHoursParams.getEndTime().equals(""))
                stmt.setString(3, openingHoursParams.getEndTime());
            else
                stmt.setNull(3, Types.NULL);
            stmt.setString(4, openingHoursParams.getHoursType());
            stmt.setString(5, openingHoursParams.getDescription());
            if (openingHoursParams.getDate() != null && !openingHoursParams.getDate().equals(""))
                stmt.setDate(6, new java.sql.Date(sdfUI.parse(openingHoursParams.getDate()).getTime()));
            else
                stmt.setNull(6, Types.NULL);
            stmt.setDate(7, new java.sql.Date(sdfUI.parse(openingHoursParams.getEffectiveStart()).getTime()));
            stmt.setDate(8, new java.sql.Date(sdfUI.parse(openingHoursParams.getEffectiveEnd()).getTime()));
            stmt.setInt(9, openingHoursParams.getVerticalId());
            stmt.executeUpdate();
            ResultSet rsKey = stmt.getGeneratedKeys();
            if (rsKey.next()) {
                openingHoursId = rsKey.getInt(1);
            }
            auditTableDao.auditAction("opening_hours", "openingHoursId", openingHoursId, userName, ipAddress, AuditTableDao.CREATE, dbSource.getConnection());
            // Commit these records to the DB before fetching them
            dbSource.getConnection().commit();
            openingHours = fetchSingleRecOpeningHours(openingHoursId);
        } catch (SQLException | NamingException | ParseException e) {
            logger.error("Failed to create Opening Hours {}, {}, {}", kv("openingHours", openingHoursParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
        return openingHours;
    }

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
            logger.error("Failed to get opening hours for display {}, {}, {}", kv("verticalId", verticalId), kv("effectiveDate", effectiveDate), kv("isSpecial", isSpecial), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
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
            logger.error("Failed while getting opening hours for display {}, {}, {}", kv("dayDescription", dayDescription), kv("effectiveDate", effectiveDate), kv("verticalId", verticalId));
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
            logger.error("Failed while executing getting current normal opening hours for email {}, {}", kv("verticalId", verticalId), kv("effectiveDate", effectiveDate), e);
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
     * This method will rollback the changes made via connection in supplied SimpleDatabaseConnection
     *
     * @param dbSource
     * @throws DaoException
     */
    private void rollbackTransaction(SimpleDatabaseConnection dbSource) throws DaoException {
        try {
            logger.debug("Transaction is being rolled back");
            dbSource.getConnection().rollback();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
    }

    /**
     * This method will reset autocommit option to the default value and also commit changes and close the connection
     *
     * @param dbSource
     * @throws DaoException
     */
    private void resetDefaultsAndCloseConnection(SimpleDatabaseConnection dbSource) throws DaoException {
        try {
            dbSource.getConnection().commit();
            dbSource.getConnection().setAutoCommit(autoCommit);
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        dbSource.closeConnection();
    }


    /**
     * Method gets list of records with same description and clashing date range
     * @param openingHours
     * @return
     * @throws DaoException
     */
    public List<OpeningHours> findClashingHoursCount(OpeningHours openingHours) throws DaoException {
        List<OpeningHours> openingHoursList = new ArrayList<>();
        ResultSet resultSet;
        SimpleDatabaseConnection dbSource =  new SimpleDatabaseConnection();
        try {
            String sql= "SELECT openingHoursId, daySequence, startTime, endTime, hoursType, description, date, effectiveStart, effectiveEnd, verticalId " +
                    "FROM ctm.opening_hours "+
                    "WHERE" +
                    "   ((? between effectiveStart and effectiveEnd) or (? between effectiveStart and effectiveEnd)) AND " ;
            if(openingHours.getHoursType().equalsIgnoreCase("N")){
                sql += " lower(description) = ? AND hoursType='N' AND ";
            }else{
                sql += " date = ?  AND hoursType='S' AND ";
            }
            sql += " verticalId = ?";
            if(openingHours.getOpeningHoursId()!=0){
                sql += "  AND  openingHoursId <> ?  ";
            }
            sql += "  ORDER BY date DESC  LIMIT 1;";
            PreparedStatement stmt;
            stmt = dbSource.getConnection().prepareStatement(sql);

            stmt.setString(1, openingHours.getEffectiveStart());
            stmt.setString(2, openingHours.getEffectiveEnd());
            if(openingHours.getHoursType().equalsIgnoreCase("N"))
                stmt.setString(3, openingHours.getDescription());
            else {
                if (openingHours.getDate() == null)
                    stmt.setNull(3, Types.NULL);
                else
                    stmt.setString(3, openingHours.getDate());
            }
            stmt.setInt(4, openingHours.getVerticalId());
            if(openingHours.getOpeningHoursId()!=0)
                stmt.setInt(5, openingHours.getOpeningHoursId());
            resultSet = stmt.executeQuery();

            while (resultSet.next()) {
                OpeningHours openingHoursRec = helper.createOpeningHoursObject(resultSet.getInt("openingHoursId"),
                        resultSet.getDate("date") != null ? sdfUI.format(resultSet.getDate("date")) : "", resultSet.getString("daySequence"),
                        resultSet.getString("description"),
                        resultSet.getDate("effectiveEnd") != null ? sdfUI.format(resultSet.getDate("effectiveEnd")) : "",
                        resultSet.getDate("effectiveStart") != null ? sdfUI.format(resultSet.getDate("effectiveStart")) : "",
                        resultSet.getString("endTime"), resultSet.getString("hoursType"), resultSet.getString("startTime"),
                        resultSet.getInt("verticalId"));
                openingHoursList.add(openingHoursRec);
            }
            return openingHoursList;
        } catch (SQLException | NamingException e) {
            logger.error("Failed finding clashing hours count {}", kv("openingHours", openingHours), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }
}