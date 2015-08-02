package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Provider;
import com.ctm.services.ApplicationService;

public class ProviderDao {

	public static enum GetMethod {
		BY_CODE, BY_ID
	};

	public ProviderDao(){
	}

	/**
	 * Returns a Provider model for the provider requested
	 *
	 * @param method
	 * @param parameter
	 * @param serverDate
	 * @return
	 * @throws DaoException
	 */
	private Provider get(GetMethod method, String parameter, Date serverDate) throws DaoException{

		SimpleDatabaseConnection dbSource = null;
		Provider provider = null;

		try{

			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt = null;

			if (method == GetMethod.BY_CODE) {
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT ProviderId, ProviderCode, Name " +
					"FROM ctm.provider_master " +
					"WHERE ProviderCode = ? " +
					"AND Status = '' " +
					"LIMIT 1 ;"
				);
				stmt.setString(1, parameter);
			}
			else {
				stmt = dbSource.getConnection().prepareStatement(
						"SELECT ProviderId, ProviderCode, Name " +
						"FROM ctm.provider_master " +
						"WHERE ProviderId = ? " +
						"AND Status = '' " +
						"LIMIT 1 ;"
				);
				stmt.setString(1, parameter);
			}

			ResultSet resultSet = stmt.executeQuery();

			if (resultSet.next()) {
				provider = new Provider(resultSet.getInt("ProviderId"), resultSet.getString("ProviderCode"), resultSet.getString("Name"));
			}
		}
		catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		}
		catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return provider;
	}

	/**
	 * Returns the provider by providerId.
	 *
	 * @param providerId
	 * @param serverDate
	 * @return
	 * @throws DaoException
	 */
	public Provider getById(Integer providerId, Date serverDate) throws DaoException{
		return get(GetMethod.BY_ID, providerId.toString(), serverDate);
	}

	/**
	 * Returns the provider by provider code eg BUDD.
	 *
	 * @param providerCode
	 * @param serverDate
	 * @return
	 * @throws DaoException
	 */
	public Provider getByCode(String providerCode, Date serverDate) throws DaoException{
		return get(GetMethod.BY_CODE, providerCode, serverDate);
	}

	/**
	 * Returns all providers for a specified vertical (active or inactive)
	 * @param verticalCode
	 * @param styleCodeId
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<Provider> getProviders(String verticalCode, int styleCodeId) throws DaoException {
		return getProviders(verticalCode, styleCodeId, false);
	}

	/**
	 * Returns all providers for a specified vertical
	 *
	 * TODO: We need to make use of the styleCodeId properly but our database structure doesn't currently support it
	 *
	 * @param verticalCode
	 * @param styleCodeId
	 * @param getOnlyActiveProviders
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<Provider> getProviders(String verticalCode, int styleCodeId, Boolean getOnlyActiveProviders) throws DaoException{
		SimpleDatabaseConnection dbSource = null;

		ArrayList<Provider> providers = new ArrayList<Provider>();

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			String statementSQL = "SELECT ProviderId, providerCode, Name " +
				"FROM ctm.provider_master " +
				"WHERE ProviderId IN (" +
					"SELECT DISTINCT providerId " +
					"FROM product_master " +
					"WHERE productCat = ? ";

			if(getOnlyActiveProviders)
				statementSQL += "AND EffectiveEnd > CURDATE() ORDER BY EffectiveEnd DESC ";

			statementSQL += ") ORDER BY Name ASC";

			stmt = dbSource.getConnection().prepareStatement(statementSQL);

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

	public Provider getProviderDetails(String providerCode, String propertyId) throws DaoException{
		SimpleDatabaseConnection dbSource = null;

		Provider provider = null;
		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT pm.providerId, Name, Text\n" +
					"FROM ctm.provider_master pm\n" +
							"JOIN ctm.provider_properties pp ON pp.providerid = pm.providerid\n" +
							"WHERE providerCode = ?\n" +
							"AND propertyId = ?;"
			);

			stmt.setString(1, providerCode);
			stmt.setString(2, propertyId);

			ResultSet providerResult = stmt.executeQuery();

			provider = new Provider();
			while (providerResult.next()) {
				provider.setId(providerResult.getInt("providerId"));
				provider.setPropertyDetail("mappingType", providerResult.getString("Text"));
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

		return provider;
	}
}
