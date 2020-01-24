package com.ctm.web.core.dao;

import com.ctm.web.core.confirmation.services.JoinService;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import com.fasterxml.uuid.Generators;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class JoinDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(JoinService.class);

    private SimpleDatabaseConnection dbSource;

    public JoinDao() {
        this.dbSource = new SimpleDatabaseConnection();
    }

    /**
     * Write join details to `ctm`.`joins`
     *
     * @param transactionId
     * @param productId
     * @return boolean
     * @throws SQLException
     **/
    public boolean writeJoin(long transactionId, String productId, String productCode, String providerId) throws WriteJoinException {
        try {
			Instant now = Instant.now();
			LOGGER.info("writing join {}, {}, {}", kv("transactionId", transactionId), kv("productId", productId), kv("productCode", productCode));
            Connection conn = dbSource.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                    "SELECT rootid FROM aggregator.transaction_header " +
                            "WHERE transactionid = ?;"
            );

            stmt.setLong(1, transactionId);
            ResultSet results = stmt.executeQuery();
            long rootid = 0;
            if (results.next()) {
                rootid = results.getLong("rootid");
            }

            String foundProductId = productId;

			//Only check for productId if the ID is not already a number (Atlas is a UUID)
			if(isNumeric(productId) == false) {
				stmt = conn.prepareStatement(
					"SELECT productId FROM ctm.product_master " +
					"WHERE ProductCode = ? AND NOW() BETWEEN effectiveStart AND effectiveEnd AND Status != 'X';"
				);

				stmt.setString(1, productCode);
				ResultSet productResults = stmt.executeQuery();
				if(productResults.next()) {
					foundProductId  = productResults.getString("productId");
				}
			}

			stmt = conn.prepareStatement(
				"INSERT INTO `ctm`.`joins` (rootId, productId, joinDate, providerId) " +
				"VALUES (?,?,CURDATE(),?)" +
				"ON DUPLICATE KEY UPDATE rootId=rootId,productId=productId,providerId=providerId;"
			);

			stmt.setLong(1, rootid);
			stmt.setString(2, foundProductId);
			stmt.setString(3, providerId);

			stmt.executeUpdate();
            return true;
        } catch (NamingException e) {
            throw new WriteJoinException(transactionId, productId, "Failed to obtain DB connection to record join", e);
        } catch (Exception e) {
            throw new WriteJoinException(transactionId, productId, "An exception occurred recording the join.", e);
        } finally {
            dbSource.closeConnection();
        }
    }


    public static class WriteJoinException extends Exception {
        private static final long serialVersionUID = 1L;
        private final long transactionId;
        private final String productId;

        public WriteJoinException(long transactionId, String productId, String message, Throwable cause) {
            super(message, cause);
            this.transactionId = transactionId;
            this.productId = productId;
        }

        public long getTransactionId() {
            return transactionId;
        }

        public String getProductId() {
            return productId;
        }
    }

	public boolean isNumeric(String strNum) {
    if (strNum == null) {
        return false;
    }
    try {
        double d = Double.parseDouble(strNum);
    } catch (NumberFormatException nfe) {
        return false;
    }
    return true;
}

}
