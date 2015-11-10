package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProviderFilterDao {

	public List<String> getProviderDetailsByAuthToken(String key) throws DaoException {
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		ArrayList<String> code = new ArrayList<String>();

		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement("SELECT pm.providerId, providerCode  FROM ctm.provider_master pm  JOIN ctm.provider_properties pp  ON pm.providerId = pp.providerId  WHERE PropertyId = 'authToken' AND Text = ?;");
				stmt.setString(1, key);

				ResultSet results = stmt.executeQuery();

				while (results.next()) {
					code.add(results.getString("providerCode"));
				}
			}
		} catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return code;
	}

	/**
	 * Get the provider's id and providerCode
	 */
	public String getProviderDetails(String key) throws DaoException {
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		String code = "invalid";

		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement("SELECT pm.providerId, providerCode  FROM ctm.provider_master pm  JOIN ctm.provider_properties pp  ON pm.providerId = pp.providerId  WHERE PropertyId = 'providerKey' AND Text = ? LIMIT 0,1;");
				stmt.setString(1, key);

				ResultSet results = stmt.executeQuery();

				while (results.next()) {
					code = results.getString("providerCode");
				}
			}
		} catch (SQLException | NamingException e) {
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return code;
	}
}
