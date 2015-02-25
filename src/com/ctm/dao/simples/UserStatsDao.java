package com.ctm.dao.simples;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.simples.UserStats;

public class UserStatsDao {

	/**
	 * Get message statistics for a particular user.
	 * @param userId User ID
	 */
	public UserStats getUserStats(int userId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		UserStats userStats = new UserStats();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			//
			// Execute the stored procedure for message details
			//
			stmt = dbSource.getConnection().prepareStatement(
				"CALL simples.user_stats(?, NULL);"
			);
			stmt.setInt(1, userId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				userStats.setCompleted(results.getInt("Completed"));
				userStats.setCompletedAsPM(results.getInt("CompletedAsPM"));
				userStats.setUnsuccessful(results.getInt("Unsuccessful"));
				userStats.setPostponed(results.getInt("Postponed"));
				userStats.setContact(results.getInt("contact"));
				userStats.setSales(results.getInt("Sales"));
				userStats.setConversion(results.getFloat("Conversion"));
				userStats.setActive(results.getInt("Active"));
				userStats.setFuture(results.getInt("Future"));
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

		return userStats;
	}

}
