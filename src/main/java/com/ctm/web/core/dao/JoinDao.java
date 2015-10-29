package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.services.confirmation.JoinService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class JoinDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(JoinService.class);

	private SimpleDatabaseConnection dbSource;

	public JoinDao() {
		this.dbSource = new SimpleDatabaseConnection();
	}

	/**
	 * Write join details to `ctm`.`joins`
	 * @param transactionId
	 * @param productId
	 * @return joinDate
	 * @throws SQLException
	 **/
	public void writeJoin(long transactionId, String productId) {
		try {
			LOGGER.debug("writing join {}, {}", kv("transactionId", transactionId), kv("productId", productId));
			Connection conn = dbSource.getConnection();
			PreparedStatement stmt = conn.prepareStatement(
				"SELECT rootid FROM aggregator.transaction_header " +
				"WHERE transactionid = ?;"
			);

			stmt.setLong(1, transactionId);
			ResultSet results = stmt.executeQuery();
			long rootid = 0;
			if(results.next()) {
				rootid  = results.getLong("rootid");
			}

			stmt = conn.prepareStatement(
				"INSERT INTO `ctm`.`joins` (rootId, productId, joinDate) " +
				"VALUES (?,?,CURDATE())" +
				"ON DUPLICATE KEY UPDATE rootId=rootId,productId=productId ;"
			);

			stmt.setLong(1, rootid);
			stmt.setString(2, productId);
			stmt.executeUpdate();
		}catch (NamingException e) {
			LOGGER.error("failed to get db connection", e);
		} catch (Exception e) {
			LOGGER.error("failed to write join {}, {}", kv("transactionId", transactionId), kv("productId", productId), e);
		} finally {
			dbSource.closeConnection();
		}
	}

}
