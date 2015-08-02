package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.NamingException;
import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.simples.BlacklistChannel;

public class BlacklistDao {

	public BlacklistDao(){
	}

	/**
	 * Search to see if a contact (matching brand, channel and value) is in the blacklist table
	 *
	 * @param styleCodeId
	 * @param channel
	 * @param phoneNumber
	 * @return true if found the record, otherwise false
	 */
	public boolean isBlacklisted(int styleCodeId, BlacklistChannel channel, String value) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		boolean outcome = false;
		try {
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
						"SELECT marketingBlacklistId " +
						"FROM ctm.marketing_blacklist " +
						"WHERE styleCodeId = ? " +
						"AND channel = ? " +
						"AND value = ?;"
				);
				stmt.setInt(1, styleCodeId);
				stmt.setString(2, channel.getCode());
				stmt.setString(3, value);

				ResultSet results = stmt.executeQuery();

				while (results.next()) {
					outcome = true;
				}
			}
		} catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}

		return outcome;
	}

	/**
	 * Insert new blacklist record to ctm.marketing_blacklist table
	 *
	 * @param styleCodeId
	 * @param channel
	 * @param phoneNumber
	 * @return number of rows affected
	 */
	public int add(int styleCodeId, BlacklistChannel channel, String value) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		int outcome = 0;

		try {
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
						"INSERT INTO ctm.marketing_blacklist " +
						"(styleCodeId, channel, value) " +
						"VALUES " +
						"(?,?,?);"
				);
				stmt.setInt(1, styleCodeId);
				stmt.setString(2, channel.getCode());
				stmt.setString(3, value);

				outcome = stmt.executeUpdate();
			}
		} catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}

		return outcome;
	}

	/**
	 * Delete blacklist record to ctm.marketing_blacklist table
	 *
	 * @param styleCodeId
	 * @param channel
	 * @param phoneNumber
	 * @return number of rows affected
	 */
	public int delete(int styleCodeId, BlacklistChannel channel, String value) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		int outcome = 0;

		try {
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
						"DELETE FROM ctm.marketing_blacklist " +
						"WHERE styleCodeId = ? " +
						"AND channel = ? " +
						"AND value = ?;"
				);
				stmt.setInt(1, styleCodeId);
				stmt.setString(2, channel.getCode());
				stmt.setString(3, value);

				outcome = stmt.executeUpdate();
			}
		} catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}

		return outcome;
	}
}