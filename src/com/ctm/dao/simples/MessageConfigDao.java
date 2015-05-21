package com.ctm.dao.simples;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.dao.DatabaseQueryMapping;
import com.ctm.dao.SqlDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.MessageConfig;

public class MessageConfigDao {
	private static final Logger logger = Logger.getLogger(MessageConfigDao.class.getName());

	/**
	 * Check if user is in Anti Hawking Time Frame, Time zones has been considered
	 */
	public boolean isInAntiHawkingTimeframe(java.util.Date date, String state) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT simples.isInAntiHawkingTimeframe(?, ?);"
			);

			stmt.setTimestamp(1, new java.sql.Timestamp(date.getTime()));
			stmt.setString(2, state);

			ResultSet resultSet = stmt.executeQuery();

			while (resultSet.next()) {
				return resultSet.getBoolean(1);
			}
		} catch (SQLException | NamingException e) {
			logger.error("unable to check hawking status.", e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return false;
	}

	/**
	 * Turn on or off of the flag
	 *
	 * @return 0 if no update occurred, otherwise the number of rows updated
	 */
	public int setStatus(int status) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		int outcome = 0;

		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"UPDATE simples.message_config SET status = ? WHERE name = 'hawking'"
			);
			stmt.setInt(1, status);
			outcome = stmt.executeUpdate();
		} catch (SQLException | NamingException e) {
			logger.error("unable to set Hawking flag status.", e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}
		return outcome;
	}

	/**
	 * Check the Hawking flag
	 *
	 * @return 0 or 1 | OFF or ON
	 */
	public int getStatus() throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		int status = 0;
		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT status FROM simples.message_config WHERE name = 'hawking' LIMIT 1;"
			);
			ResultSet results = stmt.executeQuery();
			while (results.next()) {
				status = results.getInt("status");
			}
		} catch (SQLException | NamingException e) {
			logger.error("Unable to get Hawking flag status.", e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}
		return status;
	}

	/**
	 * Get list of all records in message config
	 *
	 * @return
	 * @throws DaoException
	 */
	public List<MessageConfig> getCurrentMessageConfigList() throws DaoException {
		List<MessageConfig> messageConfigList = new ArrayList<>();
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		SqlDao<List<MessageConfig>> sqlDao = new SqlDao<List<MessageConfig>>();
		try {
			DatabaseQueryMapping<List<MessageConfig>> mapping = new DatabaseQueryMapping<List<MessageConfig>>() {
				@Override
				protected void mapParams() throws SQLException {
				}

				@Override
				public List<MessageConfig> handleResult(ResultSet rs) throws SQLException {
					List<MessageConfig> messageConfigList = new ArrayList<>();
					while (rs.next()) {
						MessageConfig messageConfig = new MessageConfig();
						messageConfig.setDayOfWeek(rs.getInt("dayOfWeek"));
						messageConfig.setEndTIme(rs.getString("endTime"));
						messageConfig.setId(rs.getInt("id"));
						messageConfig.setName(rs.getString("name"));
						messageConfig.setStartTime(rs.getString("startTime"));
						messageConfig.setStatus(rs.getString("status"));
						messageConfigList.add(messageConfig);
					}
					return messageConfigList;
				}
			};
			final String sql = " SELECT id, name, dayOfWeek, startTime, endTime, status " +
					" FROM simples.message_config " +
					" WHERE name = 'hawking' and status='1';";
			messageConfigList = (List<MessageConfig>) sqlDao.getAll(mapping, sql);
		} catch (DaoException e) {
			logger.error("Unable to get list of Hawking records.", e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}
		return messageConfigList;
	}
}
