package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailMaster;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.security.GeneralSecurityException;
import java.sql.*;
import java.sql.Date;
import java.util.*;

import static com.ctm.logging.LoggingArguments.kv;

/**
 * Created by voba on 13/08/2015.
 */
public class EmailTokenDao {
    private static final Logger LOGGER = LoggerFactory.getLogger(EmailTokenDao.class);

    private final SimpleDatabaseConnection dbSource;

    public EmailTokenDao() {
        this.dbSource = new SimpleDatabaseConnection();
    }

    public void addEmailToken(Long transactionId, Long emailId, String emailTokenType, String action) throws DaoException, GeneralSecurityException {
        try {
            PreparedStatement stmt;
            Connection conn = dbSource.getConnection();
            if(conn != null) {
                stmt = conn.prepareStatement(
                        "SELECT expiryDays FROM aggregator.email_token_type WHERE `emailTokenType` = ? AND `action` = ?"
                );
                int index = 1;
                stmt.setString(index++, emailTokenType);
                stmt.setString(index++, action);
                ResultSet resultSet = stmt.executeQuery();

                int expiryDays = -1;
                while (resultSet.next()) {
                    expiryDays = resultSet.getInt(1);
                }
                resultSet.close();

                stmt = conn.prepareStatement(
                        "INSERT INTO aggregator.email_token(`transactionId`, `emailId`, `emailTokenType`, `action`, `totalAttempts`, `effectiveStart`, `effectiveEnd`)" +
                        " VALUES (?,?,?,?,?,?,?)"
                );

                index = 1;
                stmt.setLong(index++, transactionId);
                stmt.setLong(index++, emailId);
                stmt.setString(index++, emailTokenType);
                stmt.setString(index++, action);
                stmt.setInt(index++, 0);
                stmt.setDate(index++, new Date(System.currentTimeMillis()));

                Calendar calendar = Calendar.getInstance();
                calendar.setTime(new java.util.Date());
                calendar.add(Calendar.DAY_OF_MONTH, expiryDays);
                stmt.setDate(index++, new Date(calendar.getTimeInMillis()));

                stmt.execute();
            }
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to get email details {},{},{},{},{}",
                    kv("emailId", emailId),
                    kv("transactionId", transactionId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", action));
            throw new DaoException(e.getMessage(), e);
        } finally {
            if(dbSource != null) {
                dbSource.closeConnection();
            }
        }
    }

    public EmailMaster getEmailDetails(Long transactionId, Long emailId, String emailTokenType, String action) {
        EmailMaster emailMaster = null;
        try {
            PreparedStatement stmt;
            Connection conn = dbSource.getConnection();
            if(conn != null) {
                incrementTotalAttempts(transactionId, emailId, emailTokenType, action);

                stmt = conn.prepareStatement(
                        "SELECT em.emailId, em.firstName , em.lastName, em.emailAddress, em.hashedEmail, h.ProductType\n" +
                                "FROM aggregator.email_token et \n" +
                                "JOIN aggregator.email_token_type ett ON et.emailTokenType=ett.emailTokenType AND et.totalAttempts <= ett.maxAttempts AND et.effectiveEnd >= CURDATE() \n" +
                                "JOIN aggregator.email_master em ON et.emailId=em.emailId \n" +
                                "JOIN aggregator.transaction_header h ON h.transactionID=et.transactionId\n" +
                                "WHERE et.transactionId = ? AND et.emailId = ? AND et.emailTokenType = ? AND et.action = ? " +
                                "LIMIT 1"
                );

                int index = 1;
                stmt.setLong(index++, transactionId);
                stmt.setLong(index++, emailId);
                stmt.setString(index++, emailTokenType);
                stmt.setString(index++, action);
                ResultSet resultSet = stmt.executeQuery();

                if(resultSet.next()) {
                    emailMaster = new EmailMaster();

                    index = 1;
                    emailMaster.setEmailId(resultSet.getInt(index++));
                    emailMaster.setFirstName(resultSet.getString(index++));
                    emailMaster.setLastName(resultSet.getString(index++));
                    emailMaster.setEmailAddress(resultSet.getString(index++));
                    emailMaster.setHashedEmail(resultSet.getString(index++));
                    emailMaster.setVertical(resultSet.getString(index++));
                    emailMaster.setValid(true);
                }
                resultSet.close();
            }
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to get email details {},{},{},{},{}",
                    kv("emailId", emailId),
                    kv("transactionId", transactionId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", action));
        } finally {
            if(dbSource != null) {
                dbSource.closeConnection();
            }
        }
        return emailMaster;
    }

    public void incrementTotalAttempts(Long transactionId, Long emailId, String emailTokenType, String action) {
        Connection conn = null;
        try {
            conn = dbSource.getConnection();

            if(conn != null) {
                PreparedStatement stmt;
                stmt = conn.prepareStatement(
                        "UPDATE aggregator.email_token et SET totalAttempts = totalAttempts + 1 " +
                                "WHERE et.transactionId = ? AND et.emailId = ? AND et.emailTokenType = ? AND et.action = ?"
                );

                int index = 1;
                stmt.setLong(index++, transactionId);
                stmt.setLong(index++, emailId);
                stmt.setString(index++, emailTokenType);
                stmt.setString(index++, action);
                stmt.executeUpdate();
            }
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to increment total attempts {},{},{},{},{}",
                    kv("emailId", emailId),
                    kv("transactionId", transactionId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", action));
        }
    }

    public boolean hasLogin(Long transactionId, Long emailId, String emailTokenType, String action) {
        EmailMaster emailMaster = null;
        try {
            PreparedStatement stmt;
            Connection conn = dbSource.getConnection();
            if(conn != null) {
                stmt = conn.prepareStatement(
                        "SELECT count(*)" +
                                "FROM aggregator.email_token et \n" +
                                "JOIN aggregator.email_master em ON et.emailId=em.emailId \n" +
                                "WHERE et.transactionId = ? AND et.emailId = ? AND et.emailTokenType = ? AND et.action = ? AND em.emailPword <> ''"
                );
                int index = 1;
                stmt.setLong(index++, transactionId);
                stmt.setLong(index++, emailId);
                stmt.setString(index++, emailTokenType);
                stmt.setString(index++, action);
                ResultSet resultSet = stmt.executeQuery();

                if(resultSet.next()) {
                    int count = resultSet.getInt(1);

                    return count > 0 ? true : false;
                }
                resultSet.close();
            }
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to get email details {},{},{},{},{}",
                    kv("emailId", emailId),
                    kv("transactionId", transactionId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", action));
        } finally {
            if(dbSource != null) {
                dbSource.closeConnection();
            }
        }
        return false;
    }
}
