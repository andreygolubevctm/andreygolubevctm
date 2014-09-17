package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.services.EnvironmentService;

public class ConfigSettingsDao {

	private static Logger logger = Logger.getLogger(ConfigSettingsDao.class.getName());

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
			stmt.setString(1, ConfigSetting.ALL_ENVIRONMENTS);
			stmt.setString(2, EnvironmentService.getEnvironmentAsString());

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

		} catch (SQLException | NamingException e) {
			logger.error("Failed to get configuration for environment:" + EnvironmentService.getEnvironmentAsString() , e);
			throw new DaoException(e.getMessage(), e);
		} catch (Exception e) {
			logger.error("Failed to get configuration for environment:" + EnvironmentService.getEnvironmentAsString() , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return settings;
	}
}
