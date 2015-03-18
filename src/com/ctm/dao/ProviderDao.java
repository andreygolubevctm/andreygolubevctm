package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Provider;

public class ProviderDao {
	// TODO: Add styleCodeId and isActive and combine with ProviderCodes DAO in e.g. a get query string method.
	// add to router as well
	public ArrayList<Provider> getProviders(String verticalCode, int styleCodeId) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<Provider> providers = new ArrayList<Provider>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT ProviderId, providerCode, Name " +
				"FROM ctm.provider_master " +
				"WHERE ProviderId IN (SELECT DISTINCT providerId FROM product_master WHERE productCat= ?)"
			);

			/*
			 * when isActive = 1
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT providerCode FROM ctm.stylecode_providers WHERE verticalCode = ? AND stylecodeId = ? AND providerId IN (SELECT DISTINCT (ProviderId) AS providerids FROM ctm.stylecode_products WHERE productCat = ?)"
				);
			 */

			stmt.setString(1, verticalCode);

			ResultSet providerResult = stmt.executeQuery();

			while (providerResult.next()) {

				Provider provider = new Provider();
				provider.setId(providerResult.getInt("providerId"));
				provider.setName(providerResult.getString("Name"));
				provider.setCode(providerResult.getString("providerCode"));
				providers.add(provider);

			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return providers;
	}
}
