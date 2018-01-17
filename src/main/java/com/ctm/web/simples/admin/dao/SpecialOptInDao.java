package com.ctm.web.simples.admin.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.admin.model.SpecialOptIn;
import com.ctm.web.simples.helper.SpecialOptInHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class SpecialOptInDao {
    private static final Logger LOGGER = LoggerFactory.getLogger(SpecialOptInDao.class);
    private final SpecialOptInHelper helper = new SpecialOptInHelper();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static boolean autoCommit = true;

    public SpecialOptIn fetchSingleRecSpecialOptIn(int specialOptInId) throws DaoException {
        SpecialOptIn specialOptIn;
        List<SpecialOptIn> specialOptInList = fetchSpecialOptIn(specialOptInId, "","", -1);
        specialOptIn = specialOptInList.isEmpty() ? null : specialOptInList.get(0);
        return specialOptIn;
    }

    public List<SpecialOptIn> fetchSpecialOptIn(int specialOptInId, String effectiveStart, String effectiveEnd, int styleCodeId) throws DaoException {
        SimpleDatabaseConnection dbSource;
        List<SpecialOptIn> specialOptInList = new ArrayList<>();
        PreparedStatement stmt;
        dbSource = new SimpleDatabaseConnection();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT contentControlId, contentValue AS content, cc.verticalId, vm.verticalCode, cc.styleCodeId, sc.styleCodeName, cc.effectiveStart, cc.effectiveEnd " +
                    "FROM ctm.content_control cc " +
                    "INNER JOIN ctm.vertical_master vm on cc.verticalId = vm.verticalId " +
                    "INNER JOIN ctm.stylecodes sc on cc.styleCodeId = sc.styleCodeId " +
                    "WHERE contentKey = 'specialOptInText'"
            );

            if (specialOptInId != 0) {
                sql.append(" AND cc.contentControlId = ?");
            } else if (!effectiveStart.isEmpty()) {
                sql.append(" AND (? BETWEEN cc.effectiveStart AND cc.effectiveEnd");
                if (!effectiveEnd.isEmpty()) {
                    sql.append(" OR ? BETWEEN cc.effectiveStart AND cc.effectiveEnd");
                }
                sql.append(")");

                if (styleCodeId >= 0) {
                    sql.append(" AND (cc.styleCodeId = ? OR cc.styleCodeId = 0)");
                }
            }

            sql.append(" ORDER BY cc.contentValue, cc.styleCodeId, cc.effectiveStart, cc.effectiveEnd");

            stmt = dbSource.getConnection().prepareStatement(sql.toString());

            if (specialOptInId != 0) {
                stmt.setInt(1, specialOptInId);
            } else if (!effectiveStart.isEmpty()) {
                int styleCodeIdParameterIndex = 2;
                java.sql.Timestamp effectiveStartTS = new java.sql.Timestamp(Long.parseLong(effectiveStart));
                stmt.setTimestamp(1, effectiveStartTS);

                if (!effectiveEnd.isEmpty()) {
                    styleCodeIdParameterIndex = 3;
                    java.sql.Timestamp effectiveEndTS = new java.sql.Timestamp(Long.parseLong(effectiveEnd));
                    stmt.setTimestamp(2, effectiveEndTS);
                }

                if (styleCodeId >= 0) {
                    stmt.setInt(styleCodeIdParameterIndex, styleCodeId);
                }
            }

            ResultSet resultSet = stmt.executeQuery();
            while (resultSet.next()) {
                SpecialOptIn specialOptIn = helper.createSpecialOptInObject(
                        resultSet.getInt("contentControlId"),
                        resultSet.getString("content"),
                        resultSet.getInt("verticalId"),
                        resultSet.getString("verticalCode"),
                        resultSet.getInt("styleCodeId"),
                        resultSet.getString("styleCodeName"),
                        resultSet.getDate("effectiveStart") != null ? sdf.format(resultSet.getTimestamp("effectiveStart")) : "",
                        resultSet.getDate("effectiveEnd") != null ? sdf.format(resultSet.getTimestamp("effectiveEnd")) : ""
                );
                specialOptInList.add(specialOptIn);
            }
            return specialOptInList;
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to retrieve Special opt in {}", kv("specialOptInId", specialOptInId), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }

    public SpecialOptIn updateSpecialOptIn(SpecialOptIn specialOptInParams, String userName, String ipAddress) throws DaoException {
        SpecialOptIn specialOptIn = new SpecialOptIn();
        SimpleDatabaseConnection dbSource;
        int specialOptInId;
        PreparedStatement stmt = null;
        dbSource = new SimpleDatabaseConnection();
        try {
            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            java.sql.Timestamp startDate = new java.sql.Timestamp(Long.parseLong(specialOptInParams.getEffectiveStart()));
            java.sql.Timestamp endDate = new java.sql.Timestamp(Long.parseLong(specialOptInParams.getEffectiveEnd()));
            specialOptInId = specialOptInParams.getSpecialOptInId();
            if (specialOptInId == 0) {
                throw new DaoException("failed : specialOptInId is null");
            }
            stmt = dbSource.getConnection().prepareStatement(" UPDATE ctm.content_control SET " +
                    "effectiveStart = ?, effectiveEnd = ? " +
                    "WHERE contentControlId = ?");

            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);
            stmt.setInt(3, specialOptInId);
            stmt.executeUpdate();

            dbSource.getConnection().commit();
            specialOptIn = fetchSingleRecSpecialOptIn(specialOptInId);
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to update Help Box {}, {}, {}", kv("specialOptInParams", specialOptInParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
        return specialOptIn;
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
