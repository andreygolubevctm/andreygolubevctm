package com.ctm.web.core.email.dao;

import com.ctm.web.core.dao.DatabaseQueryMapping;
import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;

import java.sql.ResultSet;
import java.sql.SQLException;

public class EmailTokenDao {

    public void addEmailToken(Long transactionId, Long emailId, String emailTokenType, String action) throws DaoException {
            int expiryDays[] = new int[]{-1};

            SqlDao<Integer> sqlDao = new SqlDao<>();
            expiryDays[0] = sqlDao.get(new DatabaseQueryMapping<Integer>() {
                @Override
                protected void mapParams() throws SQLException {
                    set(emailTokenType);
                    set(action);
                }

                @Override
                public Integer handleResult(ResultSet rs) throws SQLException {
                    return rs.getInt("expiryDays");
                }
            }, "SELECT expiryDays FROM aggregator.email_token_type WHERE `emailTokenType` = ? AND `action` = ?");

            sqlDao.insert(new DatabaseQueryMapping<Integer>() {
                @Override
                protected void mapParams() throws SQLException {
                    set(transactionId);
                    set(emailId);
                    set(emailTokenType);
                    set(action);
                    set(expiryDays[0]);
                }

                @Override
                public Integer handleResult(ResultSet rs) throws SQLException {
                    return null;
                }
            }, "INSERT IGNORE INTO aggregator.email_token(`transactionId`, `emailId`, `emailTokenType`, `action`, `totalAttempts`, `effectiveStart`, `effectiveEnd`)" +
                    " VALUES (?,?,?,?, 0, CURDATE(), DATE_ADD(CURDATE(), INTERVAL ? DAY))" +
                    " ON DUPLICATE KEY UPDATE totalAttempts=0, effectiveEnd=VALUES(effectiveEnd);"
                    // When existing token found reset attempts and increase the expiry.
            );
    }

    public EmailMaster getEmailDetails(Long transactionId, Long emailId, String emailTokenType, String action) throws DaoException {
        incrementTotalAttempts(transactionId, emailId, emailTokenType, action);

        SqlDao<EmailMaster> sqlDao = new SqlDao<>();
        return sqlDao.get(new DatabaseQueryMapping<EmailMaster>() {
            @Override
            protected void mapParams() throws SQLException {
                set(transactionId);
                set(emailId);
                set(emailTokenType);
                set(action);
                set(transactionId);
                set(emailId);
                set(emailTokenType);
                set(action);
            }

            @Override
            public EmailMaster handleResult(ResultSet rs) throws SQLException {
                EmailMaster emailMaster = new EmailMaster();

                emailMaster.setEmailId(rs.getInt("emailId"));
                emailMaster.setFirstName(rs.getString("firstName"));
                emailMaster.setLastName(rs.getString("lastName"));
                emailMaster.setEmailAddress(rs.getString("emailAddress"));
                emailMaster.setHashedEmail(rs.getString("hashedEmail"));
                emailMaster.setVertical(rs.getString("vertical"));
                emailMaster.setValid(true);

                return emailMaster;
            }
        }, "SELECT em.emailId as emailId, em.firstName as firstName, em.lastName as lastName, em.emailAddress as emailAddress, em.hashedEmail as hashedEmail, h.ProductType as vertical\n" +
                "FROM aggregator.email_token et " +
                "JOIN aggregator.email_token_type ett ON et.emailTokenType=ett.emailTokenType AND et.totalAttempts <= ett.maxAttempts AND et.effectiveEnd >= CURDATE() " +
                "JOIN aggregator.email_master em ON et.emailId=em.emailId " +
                "JOIN aggregator.transaction_header h ON h.transactionID=et.transactionId " +
                "WHERE et.transactionId = ? AND et.emailId = ? AND et.emailTokenType = ? AND et.action = ? " +
                "UNION " +
                "SELECT em.emailId as emailId, em.firstName as firstName, em.lastName as lastName, em.emailAddress as emailAddress, em.hashedEmail as hashedEmail, (select verticalCode from ctm.vertical_master where verticalId = h.verticalId) as vertical " +
                "FROM aggregator.email_token et " +
                "JOIN aggregator.email_token_type ett ON et.emailTokenType=ett.emailTokenType AND et.totalAttempts <= ett.maxAttempts AND et.effectiveEnd >= CURDATE() " +
                "JOIN aggregator.email_master em ON et.emailId=em.emailId " +
                "JOIN aggregator.transaction_header2_cold h ON h.transactionID=et.transactionId " +
                "WHERE et.transactionId = ? AND et.emailId = ? AND et.emailTokenType = ? AND et.action = ? ");
    }

    public EmailMaster getEmailDetails(Long emailId) throws DaoException {

        return new SqlDao<EmailMaster>().get(new DatabaseQueryMapping<EmailMaster>() {
            @Override
            protected void mapParams() throws SQLException {
                set(emailId);
            }

            @Override
            public EmailMaster handleResult(ResultSet rs) throws SQLException {
                final EmailMaster emailMaster = new EmailMaster();
                emailMaster.setVertical(rs.getString("vertical"));
                emailMaster.setEmailId(rs.getInt("emailId"));
                emailMaster.setHashedEmail(rs.getString("hashedEmail"));
                emailMaster.setEmailAddress(rs.getString("emailAddress"));
                emailMaster.setFirstName(rs.getString("firstName"));
                emailMaster.setLastName(rs.getString("lastName"));
                emailMaster.setValid(true);
                return emailMaster;
            }
        }, "SELECT DISTINCT\n" +
                "  em.emailId      AS emailId,\n" +
                "  em.firstName    AS firstName,\n" +
                "  em.lastName     AS lastName,\n" +
                "  em.emailAddress AS emailAddress,\n" +
                "  em.hashedEmail  AS hashedEmail,\n" +
                "  em.vertical     AS vertical\n" +
                "FROM aggregator.email_master em\n" +
                "WHERE em.emailId = ?");
    }

    public void incrementTotalAttempts(Long transactionId, Long emailId, String emailTokenType, String action) throws DaoException {
        SqlDao sqlDao = new SqlDao();
        sqlDao.update(new DatabaseUpdateMapping() {
            @Override
            protected void mapParams() throws SQLException {
                set(transactionId);
                set(emailId);
                set(emailTokenType);
                set(action);
            }

            @Override
            public String getStatement() {
                return "UPDATE aggregator.email_token et SET totalAttempts = totalAttempts + 1 " +
                        "WHERE et.transactionId = ? AND et.emailId = ? AND et.emailTokenType = ? AND et.action = ?";
            }
        });
    }

    public boolean hasLogin(Long transactionId, Long emailId, String emailTokenType, String action) throws DaoException {
        SqlDao<Boolean> sqlDao = new SqlDao<>();
        return sqlDao.get(new DatabaseQueryMapping<Boolean>() {
            @Override
            protected void mapParams() throws SQLException {
                set(transactionId);
                set(emailId);
                set(emailTokenType);
                set(action);
            }

            @Override
            public Boolean handleResult(ResultSet rs) throws SQLException {
                int count = rs.getInt(1);

                return count > 0 ? true : false;
            }
        }, "SELECT count(*)" +
                "FROM aggregator.email_token et \n" +
                "JOIN aggregator.email_master em ON et.emailId=em.emailId \n" +
                "WHERE et.transactionId = ? AND et.emailId = ? AND et.emailTokenType = ? AND et.action = ? AND em.emailPword <> ''");
    }

}
