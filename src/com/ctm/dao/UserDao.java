package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.simples.CallInfo;
import com.ctm.model.simples.User;
import com.ctm.services.PhoneService;

public class UserDao {

	private static Logger logger = Logger.getLogger(UserDao.class.getName());


	/**
	 * Get a user
	 */
	public User getUser(int userId) throws DaoException {
		User user = new User();
		SimpleDatabaseConnection dbSource = null;

		try {

			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt = null;
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT id, displayName, extension, ldapuid, loggedIn, modified, available FROM simples.user WHERE id = ?"
			);
			stmt.setInt(1, userId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				user.setId(results.getInt("id"));
				user.setDisplayName(results.getString("displayName"));
				user.setExtension(results.getString("extension"));
				user.setUsername(results.getString("ldapuid"));
				user.setModified(results.getTimestamp("modified"));
				user.setLoggedIn(results.getBoolean("loggedIn"));

				// TODO:
				user.setAvailable(results.getBoolean("available"));
			}

		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return user;
	}

	/**
	 * Get a list of users and their phone status.
	 *
	 * @param settings Page settings required for collecting Call Info
	 * @param onlyLoggedInUsers False for all users, True for only the users who are currently logged in
	 *
	 * @return List of users
	 */
	public ArrayList<User> getUsers(PageSettings settings, boolean onlyLoggedInUsers) throws DaoException {
		ArrayList<User> users = new ArrayList<User>();
		SimpleDatabaseConnection dbSource = null;

		try {

			dbSource = new SimpleDatabaseConnection();

			String sql = "SELECT id, displayName, extension, ldapuid, loggedIn, modified, available FROM simples.user";

			// Restrict to logged in users and if they are 'fresh'. This is because they may have session-expired instead of logging out.
			if (onlyLoggedInUsers) {
				sql += " WHERE loggedIn = 1 AND modified >= DATE_SUB(NOW(), INTERVAL 6 MINUTE)";
			}

			PreparedStatement stmt = null;
			stmt = dbSource.getConnection().prepareStatement(sql);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				User user = new User();
				user.setId(results.getInt("id"));
				user.setDisplayName(results.getString("displayName"));
				user.setExtension(results.getString("extension"));
				user.setUsername(results.getString("ldapuid"));
				user.setModified(results.getTimestamp("modified"));
				user.setLoggedIn(results.getBoolean("loggedIn"));

				user.setAvailable(results.getBoolean("available"));

				// If they're "available" due to messaging double-check their phone status
				if (user.getAvailable()) {
					// Attempt to read the phone information to determine if user is on a call.
					try {
						if (user.getLoggedIn() == true) {
							// Firstly assume they're not available (in case an exception occurs)
							user.setAvailable(false);

							// If they have an extension, check their phone status
							if (user.getExtension().length() > 0) {

								CallInfo callInfo = PhoneService.getCallInfoByExtension(settings, user.getExtension());

								if (callInfo != null && callInfo.getState() == CallInfo.STATE_INACTIVE) {
									user.setAvailable(true);
								}
							}
						}
					}
					catch (Exception e) {
						logger.error(e);
					}
				}

				users.add(user);
			}

		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return users;
	}



	/**
	 * This method should be used after the user has authenticated with the Tomcat layer, then their details passed in here.
	 * The user will be registered into our database and flagged as being logged in.
	 *
	 * @param user User object with properties set: username, extension, displayName
	 *
	 * @return The ID of the user from our database.
	 */
	public User loginUser(User user) throws DaoException {

		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			ResultSet results;
			dbSource = new SimpleDatabaseConnection();
			Connection conn = dbSource.getConnection();

			//
			// Check if user already exists
			//
			stmt = conn.prepareStatement(
				"SELECT id FROM simples.user WHERE ldapuid = ?"
			);
			stmt.setString(1, user.getUsername());
			results = stmt.executeQuery();

			// Update the model with the row ID
			while (results != null && results.next()) {
				user.setId(results.getInt("id"));
			}

			results.close();
			stmt.close();

			//
			// Update user details
			//
			if (user.getId() > 0) {
				stmt = conn.prepareStatement(
					"UPDATE simples.user SET displayName = ?, extension = ?, loggedIn = 1, modified = NOW(), available = 1"
					+ " WHERE ldapuid = ?"
				);
				stmt.setString(1, user.getDisplayName());
				stmt.setString(2, user.getExtension());
				stmt.setString(3, user.getUsername());
				stmt.executeUpdate();
				stmt.close();
			}
			//
			// Insert new user
			//
			else {
				stmt = conn.prepareStatement(
					"INSERT INTO simples.user (displayName, extension, ldapuid, loggedIn, modified) VALUES (?, ?, ?, 1, NOW()) "
					, java.sql.Statement.RETURN_GENERATED_KEYS
				);
				stmt.setString(1, user.getDisplayName());
				stmt.setString(2, user.getExtension());
				stmt.setString(3, user.getUsername());
				stmt.executeUpdate();

				// Update the model with the row ID
				results = stmt.getGeneratedKeys();
				if (results != null && results.next()) {
					user.setId(results.getInt(1));
				}

				results.close();
				stmt.close();
			}

			logger.info("loginUser(): username:" + user.getUsername() + ", extension:" + user.getExtension() + ", displayName:" + user.getDisplayName() + " > uid:" + user.getId());
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return user;
	}

	/**
	 * Flag the user as having logged out.
	 * @param userId
	 */
	public void logoutUser(int userId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;

		try {
			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE simples.user SET loggedIn = 0, modified = NOW(), available = 0 " +
				"WHERE id = ?"
			);
			stmt.setInt(1, userId);
			stmt.executeUpdate();
			stmt.close();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	/**
	 * Mark this user as available. Remember that there may be other availability checks such as phone status.
	 * @param userId
	 */
	public void setToAvailable(int userId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;

		try {
			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE simples.user SET available = 1 WHERE id = ?"
			);
			stmt.setInt(1, userId);
			stmt.executeUpdate();
			stmt.close();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	/**
	 * Mark this user as not available. Remember that there may be other availability checks such as phone status.
	 * @param userId
	 */
	public void setToUnavailable(int userId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;

		try {
			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
					"UPDATE simples.user SET available = 0 WHERE id = ?"
					);
			stmt.setInt(1, userId);
			stmt.executeUpdate();
			stmt.close();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	/**
	 * Update the user's modified timestamp.
	 * @param userId
	 */
	public void tickleUser(int userId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;

		try {
			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE simples.user SET loggedIn = 1, modified = NOW() WHERE id = ?"
			);
			stmt.setInt(1, userId);
			stmt.executeUpdate();
			stmt.close();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

}
