package com.ctm.web.simples.admin.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.dao.AuditTableDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.DatabaseUtils;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.core.utils.common.utils.StringUtils;
import com.ctm.web.simples.admin.model.UserEditableText;
import com.ctm.web.simples.admin.model.UserEditableTextType;
import com.ctm.web.simples.helper.UserEditableTextHelper;
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

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class UserEditableTextDao {
    private static final Logger LOGGER = LoggerFactory.getLogger(UserEditableTextDao.class);
    private final UserEditableTextHelper helper = new UserEditableTextHelper();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private final AuditTableDao auditTableDao = new AuditTableDao();
    private static boolean autoCommit = true;

    private UserEditableText fetchSingleRecUserEditableText(int textId) throws DaoException {
        UserEditableText userEditableText;
        List<UserEditableText> userEditableTextList = fetchUserEditableText(textId, null, "", "", -1);
        userEditableText = userEditableTextList.isEmpty() ? null : userEditableTextList.get(0);
        return userEditableText;
    }

    public UserEditableText fetchSingleRecUserEditableText(UserEditableTextType userEditableTextType, String effectiveStart, int styleCodeId) throws DaoException {
        UserEditableText userEditableText;
        List<UserEditableText> helpBoxList = fetchUserEditableText(0, userEditableTextType, effectiveStart, "", styleCodeId);
        userEditableText = helpBoxList.isEmpty() ? null : helpBoxList.get(0);
        return userEditableText;
    }

    public List<UserEditableText> fetchUserEditableText(int textId, UserEditableTextType userEditableTextType, String effectiveStart, String effectiveEnd, int styleCodeId) throws DaoException {
        SimpleDatabaseConnection dbSource;
        List<UserEditableText> userEditableTextList = new ArrayList<>();
        PreparedStatement stmt = null;
        dbSource = new SimpleDatabaseConnection();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT helpBoxId, content, operatorId, hb.styleCodeId, sc.styleCodeName, hb.effectiveStart, hb.effectiveEnd, hb.textType " +
                    "FROM ctm.helpbox_master hb " +
                    "INNER JOIN ctm.stylecodes sc on hb.styleCodeId = sc.styleCodeId"
            );

            if (textId != 0) {
                sql.append(" WHERE helpBoxId = ?");
            } else {
                if (!effectiveStart.isEmpty()) {
                    sql.append(" WHERE hb.textType = ? AND (? BETWEEN effectiveStart AND effectiveEnd");
                    if (!effectiveEnd.isEmpty()) {
                        sql.append(" OR ? BETWEEN effectiveStart AND effectiveEnd");
                    }
                    sql.append(")");
                    if (styleCodeId >= 0) {
                        sql.append(" AND (hb.styleCodeId = ? OR hb.styleCodeId = 0)");
                    }
                } else {
                    sql.append(" WHERE hb.textType = ?");
                }
            }

            sql.append(" ORDER BY hb.content, hb.styleCodeId, hb.effectiveStart, hb.effectiveEnd");

            stmt = dbSource.getConnection().prepareStatement(sql.toString());

            if (textId != 0) {
                stmt.setInt(1, textId);
            } else {
                stmt.setString(1, userEditableTextType.getType());
                if (!effectiveStart.isEmpty()) {
                    int styleCodeIdParameterIndex = 3;
                    java.sql.Timestamp effectiveStartTS = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(effectiveStart), 0, 0, 1).getTime());
                    stmt.setTimestamp(2, effectiveStartTS);

                    if (!effectiveEnd.isEmpty()) {
                        styleCodeIdParameterIndex = 4;
                        java.sql.Timestamp effectiveEndTS = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(effectiveEnd), 23, 59, 59).getTime());
                        stmt.setTimestamp(3, effectiveEndTS);
                    }
                    if (styleCodeId >= 0) {
                        stmt.setInt(styleCodeIdParameterIndex, styleCodeId);
                    }
                }
            }

            ResultSet resultSet = stmt.executeQuery();
            while (resultSet.next()) {
                UserEditableText userEditableText = helper.createUserEditableTextObject(
                        resultSet.getString("textType"),
                        resultSet.getInt("helpBoxId"),
                        resultSet.getString("content"),
                        resultSet.getInt("operatorId"),
                        resultSet.getInt("styleCodeId"),
                        resultSet.getString("styleCodeName"),
                        resultSet.getDate("effectiveStart") != null ? sdf.format(resultSet.getDate("effectiveStart")) : "",
                        resultSet.getDate("effectiveEnd") != null ? sdf.format(resultSet.getDate("effectiveEnd")) : ""
                );
                userEditableTextList.add(userEditableText);
            }
            return userEditableTextList;
        } catch (SQLException | NamingException | ParseException e) {
            LOGGER.error("Failed to retrieve User Editable Text (helpbox_master) {}", kv("textId", textId), e);
            throw new DaoException(e);
        } finally {
            closePreparedStatement(stmt);
            dbSource.closeConnection();
        }
    }

    /**
     *
     */
    public UserEditableText createUserEditableText(UserEditableText textParams, String userName, String ipAddress) throws DaoException {
        UserEditableText editableText;
        SimpleDatabaseConnection databaseConnection;
        int textId = 0;
        databaseConnection = new SimpleDatabaseConnection();
        PreparedStatement stmt = null;

        try {
            autoCommit = databaseConnection.getConnection().getAutoCommit();
            databaseConnection.getConnection().setAutoCommit(false);
            java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(textParams.getEffectiveStart()), 0, 0, 1).getTime());
            java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(textParams.getEffectiveEnd()), 23, 59, 59).getTime());

            stmt = databaseConnection.getConnection().prepareStatement(
                    " INSERT INTO ctm.helpbox_master " +
                            "( content, operatorId, styleCodeId,  effectiveStart, effectiveEnd, textType ) VALUES " +
                            "(?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);

            stmt.setString(1, textParams.getContent());
            stmt.setInt(2, textParams.getOperatorId());
            stmt.setInt(3, textParams.getStyleCodeId());
            stmt.setTimestamp(4, startDate);
            stmt.setTimestamp(5, endDate);
            stmt.setString(6, textParams.getTextType());
            stmt.executeUpdate();
            ResultSet rsKey = stmt.getGeneratedKeys();
            if (rsKey.next()) {
                textId = rsKey.getInt(1);
            }
            // Commit these records to the DB before fetching them
            databaseConnection.getConnection().commit();
            editableText = fetchSingleRecUserEditableText(textId);
            auditTableDao.auditAction("helpbox_master", "helpBoxId", textId, userName, ipAddress, AuditTableDao.CREATE, databaseConnection.getConnection());
        } catch (ParseException | NamingException | SQLException e) {
            DatabaseUtils.rollbackTransaction(databaseConnection, LOGGER);
            LOGGER.error("Failed to create User Editable Text (helpbox_master) {}, {}, {}", kv("textParams", textParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            throw new DaoException(e);
        } finally {
            closePreparedStatement(stmt);
            DatabaseUtils.resetDefaultsAndCloseConnection(databaseConnection, autoCommit);
        }

        return editableText;
    }

    public UserEditableText updateUserEditableText(UserEditableText textParams, String userName, String ipAddress) throws DaoException {
        UserEditableText userEditableText;
        SimpleDatabaseConnection dbSource;
        int textId;
        PreparedStatement stmt = null;
        dbSource = new SimpleDatabaseConnection();
        try {
            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(textParams.getEffectiveStart()), 0, 0, 1).getTime());
            java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(textParams.getEffectiveEnd()), 23, 59, 59).getTime());
            textId = textParams.getTextId();
            if (textId == 0) {
                throw new DaoException("failed : textId is null");
            }
            stmt = dbSource.getConnection().prepareStatement(" UPDATE ctm.helpbox_master SET " +
                    "content = ?, operatorId = ?, styleCodeId = ?, effectiveStart = ?, effectiveEnd = ? " +
                    "WHERE helpBoxId = ?");

            stmt.setString(1, textParams.getContent());
            stmt.setInt(2, textParams.getOperatorId());
            stmt.setInt(3, textParams.getStyleCodeId());
            stmt.setTimestamp(4, startDate);
            stmt.setTimestamp(5, endDate);
            stmt.setInt(6, textId);
            stmt.executeUpdate();
            auditTableDao.auditAction("helpbox_master", "helpBoxId", textId, userName, ipAddress, AuditTableDao.UPDATE, dbSource.getConnection());
            // Commit these records to the DB before fetching them
            dbSource.getConnection().commit();
            userEditableText = fetchSingleRecUserEditableText(textId);
        } catch (SQLException | NamingException | ParseException e) {
            LOGGER.error("Failed to update User Editable Text (helpbox_master) {}, {}, {}", kv("textParams", textParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            DatabaseUtils.rollbackTransaction(dbSource, LOGGER);
            throw new DaoException(e);
        } finally {
            closePreparedStatement(stmt);
            DatabaseUtils.resetDefaultsAndCloseConnection(dbSource, autoCommit);
        }
        return userEditableText;
    }

    public String deleteUserEditableText(String textIdString, String userName, String ipAddress) throws DaoException {
        SimpleDatabaseConnection dbSource;
        PreparedStatement stmt = null;
        dbSource = new SimpleDatabaseConnection();
        try {

            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            if (StringUtils.isBlank(textIdString)) {
                return "textId is blank";
            }
            int textId = Integer.parseInt(textIdString.trim());
            UserEditableText userEditableText = fetchSingleRecUserEditableText(textId);
            if (userEditableText == null) {
                return "User Editable Text(helpbox_master) doesn't exist with id : " + textId;
            }
            auditTableDao.auditAction("helpbox_master", "helpBoxId", textId, userName, ipAddress, AuditTableDao.DELETE, dbSource.getConnection());

            stmt = dbSource.getConnection().prepareStatement("DELETE FROM ctm.helpbox_master WHERE helpBoxId = ? LIMIT 1");
            stmt.setInt(1, textId);
            stmt.executeUpdate();
            dbSource.getConnection().commit();
            return "success";
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to delete User Editable Text (helpbox_master) {}, {}, {}", kv("textId", textIdString), kv("userName", userName), kv("ipAddress", ipAddress), e);
            DatabaseUtils.rollbackTransaction(dbSource, LOGGER);
            throw new DaoException(e);
        } finally {
            closePreparedStatement(stmt);
            DatabaseUtils.resetDefaultsAndCloseConnection(dbSource, autoCommit);
        }
    }


    private void closePreparedStatement(PreparedStatement stmt){
        try {
            if (stmt != null && !stmt.isClosed()) {
                stmt.close();
            }
        } catch (SQLException e) {
            LOGGER.error("Failed to close db connection", e);
        }
    }
}
