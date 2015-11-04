package com.ctm.web.simples.admin.openinghours.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.dao.AuditTableDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.openinghours.helper.OpeningHoursHelper;
import com.mysql.jdbc.Statement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class OpeningHoursAdminDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(OpeningHoursAdminDao.class);
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
            LOGGER.error("Failed to retrieve Opening Hours {}, {}", kv("isSpecial", isSpecial), kv("openingHoursId", openingHoursId), e);
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
            LOGGER.error("Failed to delete Opening Hours {}, {}, {}", kv("openingHoursId", openingHoursId), kv("userName", userName), kv("ipAddress", ipAddress), e);
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
            LOGGER.error("Failed to update Opening Hours {}, {}, {}", kv("openingHours", openingHoursParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
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
            LOGGER.error("Failed to create Opening Hours {}, {}, {}", kv("openingHours", openingHoursParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
        return openingHours;
    }

    /**
     * This method will rollback the changes made via connection in supplied SimpleDatabaseConnection
     *
     * @param dbSource
     * @throws DaoException
     */
    private void rollbackTransaction(SimpleDatabaseConnection dbSource) throws DaoException {
        try {
            LOGGER.debug("Transaction is being rolled back");
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
            LOGGER.error("Failed finding clashing hours count {}", kv("openingHours", openingHours), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }
}