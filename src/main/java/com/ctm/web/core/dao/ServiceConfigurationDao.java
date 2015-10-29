package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.services.EnvironmentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;

import static com.ctm.web.core.logging.LoggingArguments.kv;


public class ServiceConfigurationDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(ServiceConfigurationDao.class);

	/**
	 * Get the service configuration data and their properties from the database.
	 *
	 * @param effectiveDateTime Get the configurations that are effective at the provided datetime
	 * @return An array of service configuration items with their properties
	 * @throws DaoException
	 */
	public ArrayList<ServiceConfiguration> getAllConfigurations(Date effectiveDateTime) throws DaoException {

		SimpleDatabaseConnection dbSource = null;

		ArrayList<ServiceConfiguration> services = new ArrayList<ServiceConfiguration>();

		try{

			// First - get the list of services

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT serviceMasterId, verticalId, serviceCode, description " +
				"FROM ctm.service_master sm " +
				"ORDER BY sm.serviceCode;"
			);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {

				ServiceConfiguration service = new ServiceConfiguration();
				service.setId(result.getInt("serviceMasterId"));
				service.setVerticalId(result.getInt("verticalId"));
				service.setCode(result.getString("serviceCode"));
				service.setDescription(result.getString("description"));
				services.add(service);

			}


			// Second, get the list of properties

			PreparedStatement settingsStmt = dbSource.getConnection().prepareStatement(
				"SELECT servicePropertiesId, serviceMasterId, styleCodeId, providerId, servicePropertyKey, servicePropertyValue, effectiveStart, effectiveEnd, environmentCode, scope " +
				"FROM ctm.service_properties sp " +
				"WHERE sp.environmentCode = ? or sp.environmentCode = ? " +
					"AND ? BETWEEN sp.effectiveStart AND sp.effectiveEnd " +
				"ORDER BY sp.servicePropertyKey;"
			);

			settingsStmt.setString(1, ConfigSetting.ALL_ENVIRONMENTS);
			settingsStmt.setString(2, EnvironmentService.getEnvironmentAsString());
			settingsStmt.setTimestamp(3, new java.sql.Timestamp(effectiveDateTime.getTime()));

			ResultSet settingsResult = settingsStmt.executeQuery();

			while (settingsResult.next()) {

				ServiceConfigurationProperty property = new ServiceConfigurationProperty();
				property.setId(settingsResult.getInt("servicePropertiesId"));
				property.setServiceId(settingsResult.getInt("serviceMasterId"));
				property.setStyleCodeId(settingsResult.getInt("styleCodeId"));
				property.setProviderId(settingsResult.getInt("providerId"));
				property.setKey(settingsResult.getString("servicePropertyKey"));
				property.setValue(settingsResult.getString("servicePropertyValue"));
				property.setEffectiveEnd(settingsResult.getTimestamp("effectiveEnd"));
				property.setEffectiveStart(settingsResult.getTimestamp("effectiveStart"));
				property.setEnvironmentCode(settingsResult.getString("environmentCode"));
				property.setScope(settingsResult.getString("scope"));

				for(ServiceConfiguration service : services){

					if(service.getId() == settingsResult.getInt("serviceMasterId") || settingsResult.getInt("serviceMasterId") == 0 ){
						service.addProperty(property);
					}

				}

			}

		} catch (Exception e) {
			LOGGER.error("Failed to retrieve service configuration data {}", kv("effectiveDateTime", effectiveDateTime));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return services;
	}
}
