package com.ctm.services.confirmation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;

public class JoinService {

	private static Logger logger = Logger.getLogger(JoinService.class.getName());

	private SimpleDatabaseConnection dbSource;

	public JoinService() {
		try {
			this.dbSource = new SimpleDatabaseConnection();
		} catch (NamingException e) {
			logger.error("failed to get connection" , e);
		}
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
				"INSERT INTO `ctm`.`joins` " +
				"VALUES (?,?,CURDATE()) " +
				"ON DUPLICATE KEY UPDATE productId=?;"
			);

			stmt.setLong(1, rootid);
			stmt.setString(2, productId);
			stmt.setString(3, productId);
			stmt.executeUpdate();
		} catch (Exception e) {
			logger.error(transactionId + ": failed to write to join" , e);
		} finally {
			dbSource.closeConnection();
		}
	}

}
