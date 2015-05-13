package com.ctm.services.results;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.model.health.HealthPriceRequest;
import com.ctm.model.settings.Vertical.VerticalType;
import org.apache.log4j.Logger;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProviderRestrictionsService {

	private static Logger logger = Logger.getLogger(ProviderRestrictionsService.class.getName());

	private SimpleDatabaseConnection dbSource;

	public ProviderRestrictionsService() {
		this.dbSource = new SimpleDatabaseConnection();
	}

	public List<Integer> getProvidersWithExceededSoftLimit(String state, String vertical, long transactionid) {
		String selectStatement =
				"SELECT providerId " +
				"FROM ctm.vw_dailySalesCount " +
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
				"SELECT providerId FROM ctm.vw_monthlySalesCount " +
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
		} catch (NamingException e) {
			logger.error("failed to get connection" , e);
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
	public List<Integer> getProvidersWithExceededHardLimit(String state, String vertical, long transactionid) {
		String selectStatement =
				"SELECT providerId " +
				"FROM ctm.vw_monthlySalesCount " +
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
				")" +
				"UNION "+
				"SELECT providerId FROM ctm.vw_dailySalesCount " +
				"WHERE ( " +
				"(limitValue = ? AND limitType = 'STATE') " +
				"OR " +
				"limitType = 'GENERAL' " +
				") " +
				"AND currentJoinCount >= maxJoins "+
				"AND vertical = ? " +
				"AND limitCategory = 'H' "+ //consider daily limits only when it has been marked as Hard Limit
				"AND providerId NOT IN ( " +
					"SELECT pm.providerId FROM `ctm`.`joins`  j " +
							"INNER JOIN ctm.product_master pm " +
							"on pm.productid = j.productid " +
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
			logger.error(transactionid + "failed to get filtered brands" , e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return restrictedProviders;
	}
	

	/**
	 * Set the provider exclusion from both the request and the restrictions in the database
	 * @param transactionId 
	 */
	public List<Integer> setUpExcludedProviders(HealthPriceRequest healthPriceRequest, long transactionId) {
		List<Integer> excludedProviders = new ArrayList<Integer>();

		// Add providers that have been excluded in the request
		for (String providerId : healthPriceRequest.getBrandFilter().split(",")) {
			if (!providerId.isEmpty()) {
				excludedProviders.add(Integer.parseInt(providerId));
			}
		}

		List<Integer> providersThatHaveExceededLimit;

		if (healthPriceRequest.isOnResultsPage()) {
			// Check for soft limits
			providersThatHaveExceededLimit = getProvidersWithExceededSoftLimit(healthPriceRequest.getState(), VerticalType.HEALTH.getCode(), transactionId);
		} else {
			// Check for hard limits
			providersThatHaveExceededLimit = getProvidersWithExceededHardLimit(healthPriceRequest.getState(), VerticalType.HEALTH.getCode(), transactionId);
		}

		// Add providers that have been excluded in the database
		for (Integer providerId : new ArrayList<>(providersThatHaveExceededLimit)) {
			if (excludedProviders.contains(providerId)) {
				providersThatHaveExceededLimit.remove(providerId);
			}
		}

		healthPriceRequest.setProvidersThatHaveExceededLimit(providersThatHaveExceededLimit);
		healthPriceRequest.setExcludedProviders(excludedProviders);
		return excludedProviders;
	}

}
