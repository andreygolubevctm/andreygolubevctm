package com.ctm.web.simples.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.web.simples.dao.UserDao;
import com.ctm.web.simples.dao.UserStatsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.simples.model.User;
import com.ctm.web.simples.model.UserStats;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class SimplesUserService {
	private static final Logger LOGGER = LoggerFactory.getLogger(SimplesUserService.class);



	/**
	 * Get today's message statistics for a particular user.
	 * @param userId User ID
	 */
	public UserStats getUserStatsForToday(int userId) {
		UserStatsDao userStatsDao = new UserStatsDao();
		UserStats userStats = new UserStats();
		try {
			userStats = userStatsDao.getUserStats(userId);
		}
		catch (DaoException e) {
			LOGGER.error("Failed to getUserStatsForToday", kv("userId", userId), e);
		}
		return userStats;
	}

	/**
	 * Get list of users (operators) who are currently logged in.
	 * @param settings
	 */
	public String getUsersWhoAreLoggedIn(PageSettings settings) {
		UserDao userdao = new UserDao();

		JSONObject json = new JSONObject();
		JSONArray array = null;

		try {
			array = new JSONArray();
			for (User user : userdao.getUsers(settings, true)) {
				array.put(user.toJsonObject());
			}
			json.put("users", array);
		}
		catch (DaoException e) {
			LOGGER.error("Error getting logged in users", e);
		}
		catch (JSONException e) {
			LOGGER.error("Failed to produce JSON object", e);
		}

		return json.toString();
	}

	/**
	 * This method should be used after the user has authenticated with the Tomcat layer, then their details passed in here.
	 * The user will be registered into our database and flagged as being logged in.
	 *
	 * @param username The LDAP 'uid' e.g. lkauler
	 * @param extension User's phone extension e.g. 1234
	 * @param displayName User's full name e.g. Leto Kauler
	 *
	 * @return User user.
	 */
	public User loginUser(String username, String extension, String displayName) throws Exception {

		User user = new User();
		user.setId(0);
		user.setUsername(username);
		user.setExtension(extension);
		user.setDisplayName(displayName);

		UserDao userdao = new UserDao();
		user = userdao.loginUser(user);

		if (user.getId() == 0) {
			throw new Exception("loginUser() failed to produce a valid user ID (uid)");
		}

		return user;
	}

	/**
	 * Log out a user.
	 * @param userId
	 */
	public void logoutUser(int userId) {
		UserDao userdao = new UserDao();
		try {
			userdao.logoutUser(userId);
		}
		catch (DaoException e) {
			LOGGER.error("Failed to logout user {}", kv("userId", userId), e);
		}
	}

	/**
	 * Keep a user fresh in the user table.
	 * @param userId
	 */
	public void tickleUser(int userId) {
		UserDao userdao = new UserDao();
		try {
			userdao.tickleUser(userId);
		}
		catch (DaoException e) {
			LOGGER.error("Failed to tickle user {}", kv("userId", userId), e);
		}
	}

}
