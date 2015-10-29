package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.HandoverConfirmation;

import javax.naming.NamingException;
import java.sql.*;
import java.util.Date;

public class HandoverConfirmationDao {

    public void recordConfirmation(final HandoverConfirmation handoverConfirmation) throws DaoException {
        final SimpleDatabaseConnection simpleDatabaseConnection = new SimpleDatabaseConnection();
        try {
            final Connection connection = simpleDatabaseConnection.getConnection();
            final PreparedStatement statement = connection.prepareStatement("" +
                    "INSERT INTO ctm.handover_confirmations" +
                    "(transactionId, verticalCode, policyNo, policyType, policyName, premium, productCode, providerId, cookieCreateTime, cookieUpdateTime, ip, sent, test)" +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, INET6_ATON(?), ?, ?)");
            statement.setLong(1, handoverConfirmation.transactionId);
            statement.setString(2, handoverConfirmation.vertical.getCode());
            statement.setString(3, handoverConfirmation.policyNo);
            statement.setString(4, handoverConfirmation.policyType);
            statement.setString(5, handoverConfirmation.policyName);
            statement.setBigDecimal(6, handoverConfirmation.premium);
            statement.setString(7, handoverConfirmation.productCode);
            statement.setInt(8, handoverConfirmation.providerId);
            statement.setTimestamp(9, timestamp(handoverConfirmation.cookieCreate));
            statement.setTimestamp(10, timestamp(handoverConfirmation.cookieUpdate));
            statement.setString(11, handoverConfirmation.ip);
            statement.setString(12, handoverConfirmation.sent);
            statement.setBoolean(13, handoverConfirmation.test);
            statement.execute();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            simpleDatabaseConnection.closeConnection();
        }
    }

    private Timestamp timestamp(final Date date) {
        return date == null ? null : new Timestamp(date.getTime());
    }

    public boolean hasExistingConfirmationWithPolicy(final HandoverConfirmation handoverConfirmation) throws DaoException {
        final SimpleDatabaseConnection simpleDatabaseConnection = new SimpleDatabaseConnection();
        try {
            final Connection connection = simpleDatabaseConnection.getConnection();
            final PreparedStatement statement = connection.prepareStatement(
                    "SELECT count(transactionId) FROM ctm.handover_confirmations " +
                    "WHERE transactionId=? AND policyNo=?");
            statement.setLong(1, handoverConfirmation.transactionId);
            statement.setString(2, handoverConfirmation.policyNo);
            final ResultSet resultSet = statement.executeQuery();
            resultSet.first();
            return resultSet.getInt(1) == 1;
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            simpleDatabaseConnection.closeConnection();
        }
    }
}
