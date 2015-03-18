package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProviderFilterDao {

	/**
	 * Get the provider's id and providerCode
	 */
	public String getProviderDetails(String key, String column) throws DaoException {
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
					code = results.getString(column);
				}
			}
		} catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return code;
	}

}
