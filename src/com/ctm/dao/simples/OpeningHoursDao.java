package com.ctm.dao.simples;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.dao.AuditTableDao;
import com.ctm.exceptions.DaoException;
import com.ctm.helper.simples.OpeningHoursHelper;
import com.ctm.model.OpeningHours;
import com.ctm.utils.common.utils.DateUtils;
import com.mysql.jdbc.Statement;
import org.apache.log4j.Logger;

import javax.naming.NamingException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

public class OpeningHoursDao {
    private final static Logger logger = Logger.getLogger(OpeningHoursDao.class.getName());
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
            logger.error("Failed to retrieve Opening Hours", e);
            throw new DaoException(e.getMessage(), e);
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
            logger.error("Failed to delete Opening Hours", e);
            rollbackTransaction(dbSource);
            throw new DaoException(e.getMessage(), e);
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
            logger.error("Failed to update Opening Hours", e);
            rollbackTransaction(dbSource);
            throw new DaoException(e.getMessage(), e);
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
            logger.error("Failed to create Opening Hours", e);
            rollbackTransaction(dbSource);
            throw new DaoException(e.getMessage(), e);
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
        SimpleDatabaseConnection dbSource = null;
        List<OpeningHours> mapOpeningHoursDetails = new ArrayList<>();
        try {
            dbSource = new SimpleDatabaseConnection();
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
            logger.error("Failed to delete Opening Hours", e);
            throw new DaoException(e.getMessage(), e);
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
    public String getOpeningHoursForDisplay(String dayDescription, Date effectiveDate) throws DaoException {
        String openingHours = null;
        ResultSet resultSet;
        try {
            resultSet = searchOpeningHoursOfTheDay(dayDescription, effectiveDate);

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
        } catch (SQLException e) {
            logger.error("Failed while getting Opening Hours For Website display", e);
            throw new DaoException(e.getMessage(), e);
        }
    }

    /**
     * This method will return current status of the call center
     *
     * @param effectiveDate
     * @return String
     * @throws DaoException
     */
    public String getCurrentStatusOfCallCenter(Date effectiveDate) throws DaoException {
        String status = null;
        ResultSet resultSet;
        try {
            resultSet = searchOpeningHoursOfTheDay("today", effectiveDate);
            SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
            while (resultSet.next()) {
                String startTime, endTime;
                startTime = resultSet.getString("startTime");
                endTime = resultSet.getString("endTime");
                if (startTime != null
                        && endTime != null
                        && DateUtils.isDateInRange(DateUtils.timeToDateTime(dateFormat.format(effectiveDate)), DateUtils.timeToDateTime(startTime),
                        DateUtils.timeToDateTime(endTime))) {
                    return "Open";
                } else {
                    return "Closed";
                }
            }
        } catch (SQLException e) {
            logger.error("Failed while getting current status of call center", e);
            throw new DaoException(e.getMessage(), e);
        }
        return status;
    }

    /**
     * This method will return result set of records based on parameters
     *
     * @param dayType       : can only be either "today" or "tomorrow",if not set it will return blank
     * @param effectiveDate : server date
     * @return ResultSet
     * @throws DaoException
     */
    private ResultSet searchOpeningHoursOfTheDay(String dayType, Date effectiveDate) throws DaoException {
        SimpleDatabaseConnection dbSource = null;
        try {
            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt;
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT startTime,endTime,description, date FROM ctm.opening_hours "
                            + "WHERE lower(description) = ? OR date = ? AND hoursType IN ('N','S') ORDER BY date DESC  LIMIT 1;");
            String day = new SimpleDateFormat("EEEE").format(
                    dayType.equalsIgnoreCase("tomorrow") ? DateUtils.addDays(effectiveDate, 1) : effectiveDate).toLowerCase();
            java.sql.Date sqlEffectiveDate = new java.sql.Date((dayType.equalsIgnoreCase("tomorrow") ? DateUtils.addDays(effectiveDate, 1)
                    : effectiveDate).getTime());
            stmt.setString(1, day);
            stmt.setDate(2, sqlEffectiveDate);
            return stmt.executeQuery();
        } catch (SQLException | NamingException e) {
            logger.error("Failed while calling searchOpeningHoursOfTheDay()", e);
            throw new DaoException(e.getMessage(), e);
        } finally {
            dbSource.closeConnection();
        }
    }

    /**
     * This method will roleback the changes made via connection in supplied SimpleDatabaseConnection
     * @param dbSource
     * @throws DaoException
     */
    private void rollbackTransaction(SimpleDatabaseConnection dbSource) throws DaoException {
        try {
            logger.error("Transaction is being rolled back");
            dbSource.getConnection().rollback();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }
    }

    /**
     * This method will reset autocommit option to the default value and also commit changes and close the connection
     * @param dbSource
     * @throws DaoException
     */
    private void resetDefaultsAndCloseConnection(SimpleDatabaseConnection dbSource) throws DaoException {
        try {
            dbSource.getConnection().commit();
            dbSource.getConnection().setAutoCommit(autoCommit);
        } catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }
        dbSource.closeConnection();
    }

}
