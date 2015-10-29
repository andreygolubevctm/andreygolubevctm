package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.ConfigSetting;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import static com.ctm.logging.LoggingArguments.kv;
import static com.ctm.model.settings.ConfigSetting.ALL_ENVIRONMENTS;
import static com.ctm.services.EnvironmentService.getEnvironmentAsString;

public class ConfigSettingsDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(ConfigSettingsDao.class);

	/**
	 * Returns all config settings for the current environment (handled automatically inside the function)
	 *
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<ConfigSetting> getConfigSettings() throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<ConfigSetting> settings = new ArrayList<ConfigSetting>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT configCode, configValue, styleCodeId, verticalId, environmentCode " +
				"FROM ctm.configuration c " +
				"WHERE c.environmentCode = ? or c.environmentCode = ? " +
				"ORDER BY c.configCode;"
			);
			stmt.setString(1, ALL_ENVIRONMENTS);
			stmt.setString(2, getEnvironmentAsString());

			ResultSet result = stmt.executeQuery();

			while (result.next()) {

				ConfigSetting item = new ConfigSetting();
				item.setName(result.getString("configCode"));
				item.setValue(result.getString("configValue"));
				item.setStyleCodeId(result.getInt("styleCodeId"));
				item.setVerticalId(result.getInt("verticalId"));
				item.setEnvironment(result.getString("environmentCode"));
				settings.add(item);

			}

		} catch (Exception e) {
			LOGGER.error("Failed to get config settings {}", kv("environment", getEnvironmentAsString()), e);
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return settings;
	}
}
