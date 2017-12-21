package com.ctm.web.simples.admin.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.dao.AuditTableDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.simples.admin.model.HelpBox;
import com.ctm.web.simples.helper.HelpBoxHelper;
import com.mysql.jdbc.Statement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HelpBoxDao {
    private static final Logger LOGGER = LoggerFactory.getLogger(HelpBoxDao.class);
    private final HelpBoxHelper helper = new HelpBoxHelper();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private final AuditTableDao auditTableDao = new AuditTableDao();
    private static boolean autoCommit = true;

    private HelpBox fetchSingleRecHelpBox(int helpBoxId) throws DaoException {
        HelpBox helpBox;
        List<HelpBox> helpBoxList = fetchHelpBox(helpBoxId, "", "", -1);
        helpBox = helpBoxList.isEmpty() ? null : helpBoxList.get(0);
        return helpBox;
    }

    public HelpBox fetchSingleRecHelpBox(String effectiveStart, String effectiveEnd, int styleCodeId) throws DaoException {
        HelpBox helpBox;
        List<HelpBox> helpBoxList = fetchHelpBox(0, effectiveStart, effectiveEnd, styleCodeId);
        helpBox = helpBoxList.isEmpty() ? null : helpBoxList.get(0);
        return helpBox;
    }

    public List<HelpBox> fetchHelpBox(int helpBoxId, String effectiveStart, String effectiveEnd, int styleCodeId) throws DaoException {
        SimpleDatabaseConnection dbSource;
        List<HelpBox> helpBoxList = new ArrayList<>();
        PreparedStatement stmt;
        dbSource = new SimpleDatabaseConnection();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT helpBoxId, content, operatorId, hb.styleCodeId, sc.styleCodeName, hb.effectiveStart, hb.effectiveEnd " +
                    "FROM ctm.helpbox_master hb " +
                    "INNER JOIN ctm.stylecodes sc on hb.styleCodeId = sc.styleCodeId"
            );

            if (helpBoxId != 0) {
                sql.append(" WHERE helpBoxId = ?");
            } else if (!effectiveStart.isEmpty()) {
                sql.append(" WHERE (? BETWEEN effectiveStart AND effectiveEnd");
                if (!effectiveEnd.isEmpty()) {
                    sql.append(" OR ? BETWEEN effectiveStart AND effectiveEnd");
                }
                sql.append(")");

                if (styleCodeId >= 0) {
                    sql.append(" AND (hb.styleCodeId = ? OR hb.styleCodeId = 0)");
                }
            }

//            sql.append(" ORDER BY providerName, so.styleCodeId, so.state, so.coverType, so.effectiveStart, so.effectiveEnd");

            stmt = dbSource.getConnection().prepareStatement(sql.toString());

            if (helpBoxId != 0) {
                stmt.setInt(1, helpBoxId);
            } else if (!effectiveStart.isEmpty()) {
                int styleCodeIdParameterIndex = 2;
                java.sql.Timestamp effectiveStartTS = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(effectiveStart), 0, 0, 1).getTime());
                stmt.setTimestamp(1, effectiveStartTS);

                if (!effectiveEnd.isEmpty()) {
                    styleCodeIdParameterIndex = 3;
                    java.sql.Timestamp effectiveEndTS = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(effectiveEnd), 23, 59, 59).getTime());
                    stmt.setTimestamp(2, effectiveEndTS);
                }

                if (styleCodeId >= 0) {
                    stmt.setInt(styleCodeIdParameterIndex, styleCodeId);
                }
            }

            ResultSet resultSet = stmt.executeQuery();
            while (resultSet.next()) {
                HelpBox helpBox = helper.createHelpBoxObject(
                        resultSet.getInt("helpBoxId"),
                        resultSet.getString("content"),
                        resultSet.getInt("operatorId"),
                        resultSet.getInt("styleCodeId"),
                        resultSet.getString("styleCodeName"),
                        resultSet.getDate("effectiveStart") != null ? sdf.format(resultSet.getDate("effectiveStart")) : "",
                        resultSet.getDate("effectiveEnd") != null ? sdf.format(resultSet.getDate("effectiveEnd")) : ""
                );
                helpBoxList.add(helpBox);
            }
            return helpBoxList;
        } catch (SQLException | NamingException | ParseException e) {
            LOGGER.error("Failed to retrieve Help Box {}", kv("helpBoxId", helpBoxId), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }

    /**
     *
     */
    public HelpBox createHelpBox(HelpBox helpBoxParams, String userName, String ipAddress) throws DaoException {
        HelpBox helpBox = new HelpBox();
        SimpleDatabaseConnection dbSource;
        int helpBoxId = 0;
        dbSource = new SimpleDatabaseConnection();
        PreparedStatement stmt;

        try {
            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(helpBoxParams.getEffectiveStart()), 0, 0, 1).getTime());
            java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(helpBoxParams.getEffectiveEnd()), 23, 59, 59).getTime());

            stmt = dbSource.getConnection().prepareStatement(
                    " INSERT INTO ctm.helpbox_master " +
                            "( content, operatorId, styleCodeId,  effectiveStart, effectiveEnd ) VALUES " +
                            "(?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);

            stmt.setString(1, helpBoxParams.getContent());
            stmt.setInt(2, helpBoxParams.getOperatorId());
            stmt.setInt(3, helpBoxParams.getStyleCodeId());
            stmt.setTimestamp(4, startDate);
            stmt.setTimestamp(5, endDate);
            stmt.executeUpdate();
            ResultSet rsKey = stmt.getGeneratedKeys();
            if (rsKey.next()) {
                helpBoxId = rsKey.getInt(1);
            }
            // auditTableDao.auditAction("helpbox_master", "helpBoxId", helpBoxId, userName, ipAddress, AuditTableDao.CREATE, dbSource.getConnection());
            // Commit these records to the DB before fetching them
            dbSource.getConnection().commit();
            helpBox = fetchSingleRecHelpBox(helpBoxId);
        } catch (SQLException | NamingException | ParseException e) {
            LOGGER.error("Failed to create Help Box {}, {}, {}", kv("helpBoxParams", helpBoxParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }

        return helpBox;
    }

    public HelpBox updateHelpBox(HelpBox helpBoxParams, String userName, String ipAddress) throws DaoException {
        HelpBox helpBox = new HelpBox();
        SimpleDatabaseConnection dbSource;
        int helpBoxId;
        PreparedStatement stmt = null;
        dbSource = new SimpleDatabaseConnection();
        try {
            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(helpBoxParams.getEffectiveStart()), 0, 0, 1).getTime());
            java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(helpBoxParams.getEffectiveEnd()), 23, 59, 59).getTime());
            helpBoxId = helpBoxParams.getHelpBoxId();
            if (helpBoxId == 0) {
                throw new DaoException("failed : helpBoxId is null");
            }
            stmt = dbSource.getConnection().prepareStatement(" UPDATE ctm.helpbox_master SET " +
                    "content = ?, operatorId = ?, styleCodeId = ?, effectiveStart = ?, effectiveEnd = ? " +
                    "WHERE helpBoxId = ?");

            stmt.setString(1, helpBoxParams.getContent());
            stmt.setInt(2, helpBoxParams.getOperatorId());
            stmt.setInt(3, helpBoxParams.getStyleCodeId());
            stmt.setTimestamp(4, startDate);
            stmt.setTimestamp(5, endDate);
            stmt.setInt(6, helpBoxId);
            stmt.executeUpdate();
//            auditTableDao.auditAction("helpbox_master", "helpBoxId", helpBoxId, userName, ipAddress, AuditTableDao.UPDATE, dbSource.getConnection());
            // Commit these records to the DB before fetching them
            dbSource.getConnection().commit();
            helpBox = fetchSingleRecHelpBox(helpBoxId);
        } catch (SQLException | NamingException | ParseException e) {
            LOGGER.error("Failed to update Help Box {}, {}, {}", kv("helpBoxParams", helpBoxParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
        return helpBox;
    }

    public String deleteHelpBox(String helpBoxId, String userName, String ipAddress) throws DaoException {
        SimpleDatabaseConnection dbSource;
        PreparedStatement stmt;
        dbSource = new SimpleDatabaseConnection();
        try {

            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            if (helpBoxId == null || helpBoxId.trim().equalsIgnoreCase("")) {
                return "HelpBoxId is blank";
            }
            HelpBox helpBox = fetchSingleRecHelpBox(Integer.parseInt(helpBoxId.trim()));
            if (helpBox == null) {
                return "Help Box doesn't exist with id : " + helpBoxId;
            }
//            auditTableDao.auditAction("helpbox_master", "helpBoxId", Integer.parseInt(helpBoxId.trim()), userName, ipAddress, AuditTableDao.DELETE, dbSource.getConnection());

            stmt = dbSource.getConnection().prepareStatement("DELETE FROM ctm.helpbox_master WHERE helpBoxId = ? LIMIT 1");
            stmt.setInt(1, Integer.parseInt(helpBoxId.trim()));
            stmt.executeUpdate();
            dbSource.getConnection().commit();
            return "success";
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to delete Help Box {}, {}, {}", kv("helpBoxId", helpBoxId), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
    }

    /**
     * This method will roleback the changes made via connection in supplied SimpleDatabaseConnection
     * @param dbSource
     * @throws DaoException
     */
    private void rollbackTransaction(SimpleDatabaseConnection dbSource) throws DaoException {
        try {
            LOGGER.error("Transaction is being rolled back");
            dbSource.getConnection().rollback();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
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
            throw new DaoException(e);
        }
        dbSource.closeConnection();
    }
}
