package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ProviderFilterDao {

	private final static String PROVIDER_DETAILS_QUERY_BY_AUTHTOKEN =
			"SELECT " +
			"  pm.providerId, " +
			"  providerCode  " +
			"FROM " +
			"  ctm.provider_master pm  " +
			"  JOIN ctm.provider_properties pp  " +
			"    ON pm.providerId = pp.providerId  " +
			"WHERE " +
			"  PropertyId in 'authToken' " +
			"  AND Text = ?";

	private final static String PROVIDER_DETAILS_QUERY_BY_KEY =
			"SELECT " +
			"  pm.providerId, providerCode  " +
			"FROM " +
			"  ctm.provider_master pm  " +
			"  JOIN ctm.provider_properties pp  " +
			"    ON pm.providerId = pp.providerId  " +
			"WHERE PropertyId = 'providerKey' " +
			"  AND Text = ? " +
			"LIMIT 0,1;";

	public ArrayList<String> getProviderDetailsByAuthToken(String key) throws Exception {
		final ArrayList<String> code = new ArrayList<>();

		try (SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection()) {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(PROVIDER_DETAILS_QUERY_BY_AUTHTOKEN);
				stmt.setString(1, key);

				ResultSet results = stmt.executeQuery();

				while (results.next()) {
					code.add(results.getString("providerCode"));
				}
			}
		}

		return code;
	}

	/**
	 * Get the provider's id and providerCode
	 */
	public String getProviderDetails(String key) throws Exception {
		try (SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection()) {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(PROVIDER_DETAILS_QUERY_BY_KEY);
				stmt.setString(1, key);

				ResultSet results = stmt.executeQuery();

				if (results.next()) {
					return results.getString("providerCode");
				}
			}
		}

		return "invalid";
	}
}
