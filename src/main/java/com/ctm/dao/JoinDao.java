package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.services.confirmation.JoinService;
import org.slf4j.Logger; import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class JoinDao {

	private static final Logger logger = LoggerFactory.getLogger(JoinService.class.getName());

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
			logger.debug(transactionId + ": writing join");
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
			logger.error("failed to get connection" , e);
		} catch (Exception e) {
			logger.error(transactionId + ": failed to write to join" , e);
		} finally {
			dbSource.closeConnection();
		}
	}

}
