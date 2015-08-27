package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.simples.CallInfo;
import com.ctm.model.simples.Role;
import com.ctm.model.simples.Rule;
import com.ctm.model.simples.User;
import com.ctm.services.PhoneService;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

	private static final Logger logger = LoggerFactory.getLogger(UserDao.class.getName());


	/**
	 * Get a user
	 */
	public User getUser(int userId) throws DaoException {
		User user = new User();
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
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
		ArrayList<User> users = new ArrayList<>();
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			String sql = "SELECT id, displayName, extension, ldapuid, loggedIn, modified, available FROM simples.user";

			// Restrict to logged in users and if they are 'fresh'. This is because they may have session-expired instead of logging out.
			if (onlyLoggedInUsers) {
				sql += " WHERE loggedIn = 1 AND modified >= DATE_SUB(NOW(), INTERVAL 6 MINUTE)";
			}

			PreparedStatement stmt = dbSource.getConnection().prepareStatement(sql);

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
						if (user.getLoggedIn()) {
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
						logger.error("",e);
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

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			PreparedStatement stmt;
			PreparedStatement simplesUserStatement;
			Connection conn = dbSource.getConnection();

			//
			// Check if user already exists
			//
			stmt = conn.prepareStatement(
				"SELECT id FROM simples.user WHERE ldapuid = ?"
			);
			stmt.setString(1, user.getUsername());
			ResultSet results = stmt.executeQuery();

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
				simplesUserStatement = conn.prepareStatement(
					"INSERT INTO simples.user (displayName, extension, ldapuid, loggedIn, modified) VALUES (?, ?, ?, 1, NOW()) "
					, java.sql.Statement.RETURN_GENERATED_KEYS
				);
				simplesUserStatement.setString(1, user.getDisplayName());
				simplesUserStatement.setString(2, user.getExtension());
				simplesUserStatement.setString(3, user.getUsername());
				simplesUserStatement.executeUpdate();

				// Update the model with the row ID
				results = simplesUserStatement.getGeneratedKeys();
				if (results != null) {
					if (results.next()) {
						user.setId(results.getInt(1));
					}
					results.close();
				}
				simplesUserStatement.close();
			}

			//set user roles
			setRolesForUser(user);

			setRulesForUser(user);

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
	 * @param userId that matcher username in simples.user
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

	/*** Mark this user as not available. Remember that there may be other availability checks such as phone status.
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
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE simples.user SET loggedIn = 1, modified = NOW() WHERE id = ?"
			);
			stmt.setInt(1, userId);
			stmt.executeUpdate();
			stmt.close();
		} catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	private void setRolesForUser(User user) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		ResultSet results = null;
		PreparedStatement stmt = null;

		try {
			dbSource = new SimpleDatabaseConnection();
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT r.id, r.admin, r.messageQueue, r.developer " +
				"FROM simples.role r " +
				"INNER JOIN simples.user_role ur " +
				"ON ur.roleId = r.id " +
				"WHERE userId = ? " +
				"AND CURDATE() BETWEEN effectiveStart AND effectiveEnd"
			);
			stmt.setInt(1, user.getId());
			results = stmt.executeQuery();
            List<Role> userRoles = new ArrayList<>();
            while (results.next()) {
                Role role = new Role();
                role.setId(results.getInt("id"));
                role.setAdmin(results.getBoolean("admin"));
                role.setCanSeeMessageQueue(results.getBoolean("messageQueue"));
                role.setDeveloper(results.getBoolean("developer"));
                userRoles.add(role);
            }
            stmt.close();
            // if no role found then set it to default role
            if (userRoles.isEmpty()) {
                stmt = dbSource.getConnection().prepareStatement(
                        "SELECT r.id, r.admin, r.messageQueue, r.developer \n" +
                                "FROM simples.role r \n" +
                                "WHERE id = (SELECT s.value \n" +
                                "			 FROM simples.settings s \n" +
                                "			 WHERE s.key='defaultRoleId')"
                );
                results = stmt.executeQuery();
                while (results.next()) {
                    Role role = new Role();
                    role.setId(results.getInt("id"));
                    role.setAdmin(results.getBoolean("admin"));
                    role.setCanSeeMessageQueue(results.getBoolean("messageQueue"));
                    role.setDeveloper(results.getBoolean("developer"));
                    userRoles.add(role);
                }
            }
            user.setRoles(userRoles);
        } catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
		}
		finally {
			try {
				if(results != null) {
					results.close();
				}
				if(stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw new DaoException(e.getMessage(), e);
			}
			dbSource.closeConnection();
		}
	}

	private void setRulesForUser(User user) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		ResultSet results = null;
		PreparedStatement stmt = null;

		try {
			dbSource = new SimpleDatabaseConnection();
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT rule.id AS id, rule.description, rule.value\n" +
                            "FROM  simples.role r  \n" +
                            "INNER JOIN simples.role_rule_set rrs ON rrs.roleId = r.id \n" +
                            "INNER JOIN simples.rule_set rs ON rs.id = rrs.ruleSetId\n" +
                            "INNER JOIN simples.rule_rule_set rule_rs ON rule_rs.ruleSetId = rs.id\n" +
                            "INNER JOIN simples.rule rule ON rule.id = rule_rs.ruleId\n" +
                            "WHERE r.id IN  (?)\n" +
                            "AND CURDATE() BETWEEN rule_rs.effectiveStart AND rule_rs.effectiveEnd \n" +
                            "ORDER BY rrs.priority, rule_rs.priority"
            );
			String[] roles = new String[user.getRoles().size()];
			int i =0 ;
			for (Role role : user.getRoles()) {
				roles[i++] = role.getId()+"";
			}
			String rolesStr = StringUtils.join(roles, ",");
			stmt.setString(1, rolesStr);
			results = stmt.executeQuery();

			List<Rule> rules = new ArrayList<Rule>();

			while (results.next()) {
				Rule rule = new Rule();
				rule.setId(results.getInt("id"));
				rule.setDescription(results.getString("description"));
				rule.setValue(results.getString("value"));
				rules.add(rule);
			}

			user.setRules(rules);
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			try {
				if(results != null) {
					results.close();
				}
				if(stmt != null) {
					stmt.close();
				}
			} catch (SQLException e) {
				throw new DaoException(e.getMessage(), e);
			}
			dbSource.closeConnection();
		}
	}
}
