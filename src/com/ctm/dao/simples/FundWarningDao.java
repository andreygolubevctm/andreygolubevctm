package com.ctm.dao.simples;

import com.ctm.dao.AuditTableDao;
import com.ctm.dao.DatabaseQueryMapping;
import com.ctm.dao.DatabaseUpdateMapping;
import com.ctm.dao.SqlDao;
import com.ctm.exceptions.DaoException;
import com.ctm.helper.simples.FundWarningHelper;
import com.ctm.model.FundWarningMessage;
import com.ctm.utils.common.utils.DateUtils;
import org.apache.log4j.Logger;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class FundWarningDao {
    private final static Logger logger = Logger.getLogger(FundWarningDao.class.getName());
    private final FundWarningHelper helper = new FundWarningHelper();
    private final SqlDao sqlDao = new SqlDao();

    /**
     * This function finds fund warning message from database based on parameters passed.
     * The function uses the ctm.provider_warning_message which doesn't mean that it stores all the warning messages.Right now
     * there can be only one message per provider during same period of the time if multiple found it will only return first one
     *
     * @param providerId   must not be blank or 0
     * @param verticalCode must not be blank or 0
     * @param currentDate  must not be null
     * @return String
     * @throws DaoException
     */
    @SuppressWarnings("unchecked")
    public String getFundWarningMessage(final int providerId, final String verticalCode, final Date currentDate) throws DaoException {
        DatabaseQueryMapping mapping = new DatabaseQueryMapping() {
            @Override
            public void mapParams() throws SQLException {
                set( providerId);
                set(verticalCode);
                set(currentDate);
            }

            @Override
            public Object handleResult(ResultSet rs) throws SQLException {
                return rs.getString(1);
            }
        };
        String sql = "SELECT messageContent " +
                        "FROM       ctm.provider_warning_message msg " +
                        "INNER JOIN ctm.vertical_master vm  ON   msg.verticalId = vm.verticalId " +
                        "WHERE " +
                        "msg.providerId=? AND  " +
                        "vm.verticalCode =? AND " +
                        "? between effectiveStart AND effectiveEnd " +
                        "limit 1";
        //noinspection unchecked
        return (String) sqlDao.get(mapping, sql);
    }

    /**
     * this method will return single record if ID exist else return null
     *
     * @param messageId : Unique identifier of opening hours record
     * @return FundWarningMessage
     * @throws DaoException
     */
    public FundWarningMessage fetchSingleRecFundWarningMessage(int messageId) throws DaoException {
        FundWarningMessage openingHours;
        List<FundWarningMessage> openingHoursList = fetchFundWarningMessage(messageId);
        openingHours = openingHoursList.isEmpty() ? null : openingHoursList.get(0);
        return openingHours;
    }

    /**
     * this method will fetch all the opening hours record from database
     *
     * @param messageId : if 0 return all results else return the  specific one
     * @return List<FundWarningMessage>
     * @throws DaoException
     */
    public List<FundWarningMessage> fetchFundWarningMessage(final int messageId) throws DaoException {
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT     messageId,      messageContent,     providerId, " +
                    "           verticalId,     effectiveStart,     effectiveEnd " +
                    "FROM ctm.provider_warning_message ");
            if (messageId != 0) {
                sql.append(" where  messageId = ?  ");
            }
            DatabaseQueryMapping mapping = new DatabaseQueryMapping() {
                @Override
                public void mapParams() throws SQLException {
                    if (messageId != 0) {
                        set(messageId);
                    }
                }

                @Override
                public Object handleResult(ResultSet resultSet) throws SQLException {
                    List<FundWarningMessage> list = new ArrayList<>();
                    while (resultSet.next()) {
                        FundWarningMessage openingHours = helper.createFundWarningMessageObject(resultSet.getInt("messageId"), resultSet.getString("messageContent"),
                                resultSet.getDate("effectiveStart"), resultSet.getDate("effectiveEnd"), resultSet.getInt("providerID"), resultSet.getInt("verticalId"));
                        list.add(openingHours);
                    }
                    return list;
                }
            };
            //noinspection unchecked
            return (List<FundWarningMessage>) sqlDao.getAll(mapping, sql.toString());
        } catch (DaoException e) {
            logger.error("Failed to retrieve Fund Warning Message Record", e);
            throw e;
        }
    }

    /**
     * This method will delete record associated with supplied ID
     *
     * @param messageId : Unique identifier of opening hours
     * @param userName  : userName of the user who has logged in during the session
     * @param ipAddress : IP address of user's machine
     * @return String : with success of failure message
     * @throws DaoException
     */
    public String deleteFundWarningMessage(final int messageId, String userName, String ipAddress) throws DaoException {
        if (messageId == 0) {
            return "Fund Warning Message Record Id is 0";
        }
        try {
            String sql = "DELETE FROM provider_warning_message WHERE messageId = ?";
            DatabaseUpdateMapping mapping = new DatabaseUpdateMapping() {
                @Override
                public String getStatement() {
                    return null;
                }

                @Override
                public void mapParams() throws SQLException {
                    set(messageId);
                }
            };
            sqlDao.executeUpdateAudit(mapping, sql, userName, ipAddress, AuditTableDao.DELETE, "provider_warning_message", "messageId", messageId);
            return "success";
        } catch (DaoException e) {
            logger.error("Failed to delete Fund Warning Message Record", e);
            throw new DaoException(e.getMessage(), e);
        }
    }

    /**
     * This method will update record as per data in "fundWarningMessageParam"
     *
     * @param fundWarningMessageParam : FundWarningMessage object
     * @param userName                : userName of the user who has logged in during the session
     * @param ipAddress               : IP address of user's machine
     * @return FundWarningMessage
     * @throws DaoException
     */
    public FundWarningMessage updateFundWarningMessage(final FundWarningMessage fundWarningMessageParam, String userName, String ipAddress) throws DaoException {
        int messageId;
        final java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(fundWarningMessageParam.getEffectiveStart(), 0, 0, 1).getTime());
        final java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(fundWarningMessageParam.getEffectiveEnd(), 23, 59, 59).getTime());
        try {
            messageId = fundWarningMessageParam.getMessageId();
            if (messageId == 0) {
                throw new DaoException("failed : messageId is null");
            }
            String sql = " UPDATE provider_warning_message SET  " +
                        "messageContent = ?," +
                        "providerId = ?, " +
                        "verticalId = ?, " +
                        "effectiveStart = ?, " +
                        "effectiveEnd = ? " +
                        "WHERE messageId= ?";
            final int finalMessageId = messageId;
            DatabaseUpdateMapping mapping = new DatabaseUpdateMapping() {
                @Override
                public String getStatement() {
                    return null;
                }

                @Override
                public void mapParams() throws SQLException {
                    set(fundWarningMessageParam.getMessageContent());
                    set(fundWarningMessageParam.getProviderId());
                    set(fundWarningMessageParam.getVerticalId());
                    set(startDate);
                    set(endDate);
                    set(finalMessageId);
                }
            };
            sqlDao.executeUpdateAudit(mapping, sql, userName, ipAddress, AuditTableDao.UPDATE, "provider_warning_message", "messageId", messageId);
            return fetchSingleRecFundWarningMessage(messageId);
        } catch (DaoException e) {
            logger.error("Failed to update Fund Warning Message Record", e);
            throw e;
        }
    }

    /**
     * This method will create new record in the table and also returns the
     * created record in the object
     *
     * @param fundWarningMessageParam : FundWarningMessage object
     * @param userName                : userName of the user who has logged in during the session
     * @param ipAddress               : IP address of user's machine
     * @return FundWarningMessage
     * @throws DaoException
     */
    public FundWarningMessage createFundWarningMessage(final FundWarningMessage fundWarningMessageParam, String userName, String ipAddress) throws DaoException {
        try {

            final java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(fundWarningMessageParam.getEffectiveStart(), 0, 0, 1).getTime());
            final java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(fundWarningMessageParam.getEffectiveEnd(), 23, 59, 59).getTime());
            String sql = " INSERT INTO ctm.provider_warning_message " +
                         "( messageContent,   providerId, verticalId, effectiveStart, effectiveEnd)" +
                         " VALUES " +
                         "( ?,                ?,          ?,          ?,              ?)";
            DatabaseUpdateMapping mapping = new DatabaseUpdateMapping() {
                @Override
                public String getStatement() {
                    return null;
                }

                @Override
                public void mapParams() throws SQLException {
                    set(fundWarningMessageParam.getMessageContent());
                    set(fundWarningMessageParam.getProviderId());
                    set(fundWarningMessageParam.getVerticalId());
                    set(startDate);
                    set(endDate);
                }
            };
            int id = sqlDao.executeUpdateAudit(mapping, sql, userName, ipAddress, AuditTableDao.CREATE, "provider_warning_message", "messageId", 0);
            return fetchSingleRecFundWarningMessage(id);
        } catch (DaoException e) {
            logger.error("Failed to create Fund Warning Message Record", e);
            throw new DaoException(e.getMessage(), e);
        }
    }

}
