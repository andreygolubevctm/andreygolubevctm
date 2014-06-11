package com.ctm.services.results;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;

public class ProviderRestrictionsService {

	private static Logger logger = Logger.getLogger(ProviderRestrictionsService.class.getName());

	private SimpleDatabaseConnection dbSource;

	public ProviderRestrictionsService() {
		try {
			this.dbSource = new SimpleDatabaseConnection();
		} catch (NamingException e) {
			logger.error("failed to get connection" , e);
		}
	}

	public List<Integer> getProvidersThatHaveExceededLimit(String state, String vertical, long transactionid) {
		String selectStatement =
				"SELECT providerId " +
				"FROM ctm.dailySalesCount " +
				"WHERE ( " +
				"(limitValue = ? AND limitType = 'STATE') " +
				"OR " +
				"limitType = 'GENERAL' " +
				") " +
				"AND currentJoinCount >= maxJoins "+
				"AND vertical = ? "+
				"AND providerId NOT IN ( " +
					"SELECT providerId FROM `ctm`.`joins` " +
					"WHERE rootid in ( " +
						"SELECT rootid FROM aggregator.transaction_header th " +
						"WHERE th.transactionid = ? " +
					")" +
				") " +
				"UNION "+
				"SELECT providerId FROM ctm.monthlySalesCount " +
				"WHERE ( " +
				"(limitValue = ? AND limitType = 'STATE') " +
				"OR " +
				"limitType = 'GENERAL' " +
				") " +
				"AND currentJoinCount >= maxJoins "+
				"AND vertical = ? "+
				"AND providerId NOT IN ( " +
					"SELECT providerId FROM `ctm`.`joins` " +
					"WHERE rootid in ( " +
						"SELECT rootid FROM aggregator.transaction_header th " +
						"WHERE th.transactionid = ? " +
					") " +
				");";

		List<Integer> restrictedProviders = new ArrayList<Integer>();
		try {
			Connection conn = dbSource.getConnection();

			PreparedStatement stmt;
			ResultSet results;
			stmt = conn.prepareStatement(selectStatement);
			stmt.setString(1, state);
			stmt.setString(2, vertical);
			stmt.setLong(3, transactionid);
			stmt.setString(4, state);
			stmt.setString(5, vertical);
			stmt.setLong(6, transactionid);
			results = stmt.executeQuery();
			while(results.next()) {
					restrictedProviders.add(results.getInt("providerId"));
			}
		} catch (Exception e) {
			logger.error(transactionid + ": failed to get filtered brands" , e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return restrictedProviders;
	}


	/**
	 *  Get provider ids of what has exceeded the monthly limit
	 * @param state
	 * @param vertical
	 * @param transactionid
	 * @return
	 */
	public List<Integer> getProvidersThatHaveExceededMonthlyLimit(String state, String vertical, long transactionid) {
		String selectStatement =
				"SELECT providerId " +
				"FROM ctm.monthlySalesCount " +
				"WHERE ( " +
				"(limitValue = ? AND limitType = 'STATE') " +
				"OR " +
				"limitType = 'GENERAL' " +
				") " +
				"AND currentJoinCount >= maxJoins "+
				"AND vertical = ? "+
				"AND providerId NOT IN ( " +
					"SELECT providerId FROM `ctm`.`joins` " +
					"WHERE rootid in ( " +
						"SELECT rootid FROM aggregator.transaction_header th " +
						"WHERE th.transactionid = ? " +
					") " +
				");";


		List<Integer> restrictedProviders = new ArrayList<Integer>();
		try {
			Connection conn = dbSource.getConnection();

			PreparedStatement stmt;
			ResultSet results;
			stmt = conn.prepareStatement(selectStatement);
			stmt.setString(1, state);
			stmt.setString(2, vertical);
			stmt.setLong(3, transactionid);
			results = stmt.executeQuery();
			while(results.next()) {
				restrictedProviders.add(results.getInt("providerId"));
			}
		} catch (Exception e) {
			logger.error(transactionid + "failed to get filtered brands" , e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return restrictedProviders;
	}
}
