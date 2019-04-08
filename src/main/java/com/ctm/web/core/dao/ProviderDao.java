package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.model.ProviderName;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Repository
public class ProviderDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(ProviderDao.class);
	private SimpleDatabaseConnection dbSource;
	private int providerNamesSize = 0;
	private ArrayList<ProviderName> providerNames;

	public static enum GetMethod {
		BY_CODE, BY_ID, BY_NAME
	};

	public ProviderDao() {
		dbSource = new SimpleDatabaseConnection();
		providerNames = new ArrayList<ProviderName>();
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
			else if (method == GetMethod.BY_NAME) {
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT ProviderId, ProviderCode, Name " +
						"FROM ctm.provider_master " +
						"WHERE Name = ? " +
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
			throw new DaoException(e);
		}
		catch (NamingException e) {
			throw new DaoException(e);
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
	 * Returns the provider by provider code eg BUDD.
	 *
	 * @param providerName
	 * @param serverDate
	 * @return
	 * @throws DaoException
	 */
	public Provider getByName(String providerName, Date serverDate) throws DaoException{
		return get(GetMethod.BY_NAME, providerName, serverDate);
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

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve providers for vertical {}, {}, {}, {}", kv("verticalCode", verticalCode),
				kv("styleCodeId", styleCodeId), kv("onlyActiveProviders", getOnlyActiveProviders));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return providers;
	}

	/**
	 * Set names of all providers
	 * @param verticalType
	 * @param styleCodeId
	 * @throws DaoException
	 */
	public void setProviderNames (String verticalType, int styleCodeId) throws DaoException {
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			JSONObject namesObj = new JSONObject();

			if (conn != null) {
				stmt = dbSource.getConnection().prepareStatement(
						"SELECT * FROM ctm.stylecode_providers WHERE verticalCode = ? AND stylecodeId = ? AND Status != 'X' AND providerId IN (SELECT DISTINCT (ProviderId) AS providerids FROM ctm.stylecode_products WHERE productCat = ?) AND CURRENT_DATE BETWEEN EffectiveStart AND EffectiveEnd ORDER BY `Name`"
				);

				stmt.setString(1, verticalType);
				stmt.setInt(2, styleCodeId);
				stmt.setString(3, verticalType);

				ResultSet results = stmt.executeQuery();

				while (results.next()) {
					ProviderName providerName = new ProviderName();
					String name = results.getString("Name");
					String code = results.getString("providerCode");
					if (StringUtils.isNotBlank(name) && StringUtils.isNotBlank(code)) {
						providerName.setName(name);
						providerName.setCode(code);
						providerName.setDashedName(name.toLowerCase().replaceAll("\\s+", "_"));
						providerNames.add(providerName);
					}

				}

				providerNamesSize = providerNames.size();
			}
		} catch (SQLException e) {
			throw new DaoException(e);
		} catch (NamingException e) {
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}
	}

	/**
	 * Get provider names
	 * @return provider names
	 */
	public ArrayList<ProviderName> getProviderNames() {
		return providerNames;
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

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve provider details {}, {}", kv("providerCode", providerCode), kv("propertyId", propertyId));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return provider;
	}

	public Provider applyProviderProperties(Provider provider, Date serverDate) throws DaoException{
		SimpleDatabaseConnection dbSource = null;

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT pp.PropertyId, pp.Text\n" +
							"FROM ctm.provider_properties AS pp\n" +
							"WHERE providerId = ? AND ? BETWEEN EffectiveStart AND EffectiveEnd;"
			);

			stmt.setInt(1, provider.getId());
			stmt.setDate(2, new java.sql.Date(serverDate.getTime()));

			ResultSet providerResult = stmt.executeQuery();

			while (providerResult.next()) {
				provider.setPropertyDetail(providerResult.getString("PropertyId"), providerResult.getString("Text"));
			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to apply provider properties {}, {}", kv("providerId", provider.getId()), kv("Name", provider.getName()));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return provider;
	}
}
