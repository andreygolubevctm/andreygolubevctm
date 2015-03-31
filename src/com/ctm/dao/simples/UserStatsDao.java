package com.ctm.dao.simples;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.simples.MessageStatus;
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
			int completed = 0;
			int completedAsPM = 0;
			int postponed = 0;
			int unsuccessful = 0;
			int invalidLeads = 0;
			int sales = 0;
			double conversion = 0;
			double contact = 0;
			int hotLeads = 0;
			int remainingLeads = 0;
			int futureLeads = 0;

			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			/* get all statuses we are interested in from message audit */
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT statusId, reasonStatusId " +
				"FROM simples.message_audit WHERE userId=? AND DATE(created)=current_date() " +
				"AND ( " +
					"statusId IN (?, ?, ?, ?) " +
					"OR ( statusId=33 AND reasonStatusId IN (?, ?, ?, ?, ?) ) " +
				");"
			);

			stmt.setInt(1, userId);

			stmt.setInt(2, MessageStatus.STATUS_COMPLETED);
			stmt.setInt(3, MessageStatus.STATUS_COMPLETED_AS_PM);
			stmt.setInt(4, MessageStatus.STATUS_POSTPONED);
			stmt.setInt(5, MessageStatus.STATUS_UNSUCCESSFUL);

			stmt.setInt(6, MessageStatus.STATUS_INVALIDLEAD);
			stmt.setInt(7, MessageStatus.STATUS_WARMTRANSFER);
			stmt.setInt(8, MessageStatus.STATUS_ALREADYCUSTOMER);
			stmt.setInt(9, MessageStatus.STATUS_DUPLICATELEAD);
			stmt.setInt(10, MessageStatus.STATUS_OVERSEASCOVER);

			ResultSet results = stmt.executeQuery();

			List<Integer> invalidReasons = new ArrayList<Integer>();
			invalidReasons.add(MessageStatus.STATUS_INVALIDLEAD);
			invalidReasons.add(MessageStatus.STATUS_WARMTRANSFER);
			invalidReasons.add(MessageStatus.STATUS_ALREADYCUSTOMER);
			invalidReasons.add(MessageStatus.STATUS_DUPLICATELEAD);
			invalidReasons.add(MessageStatus.STATUS_OVERSEASCOVER);

			/* count number of messages for this user per status */
			while (results.next()) {

				switch(results.getInt("statusId")){
					case MessageStatus.STATUS_COMPLETED:
						completed++;
					case MessageStatus.STATUS_REMOVED_FROM_PM:
						if( invalidReasons.contains(results.getInt("reasonStatusId")) ){
							invalidLeads++;
						}
						break;

					case MessageStatus.STATUS_COMPLETED_AS_PM:
						completedAsPM++;
						break;

					case MessageStatus.STATUS_POSTPONED:
						postponed++;
						break;

					case MessageStatus.STATUS_UNSUCCESSFUL:
						unsuccessful++;
						break;
				}

			}

			/* getting sales */
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT COUNT(*) as sales " +
				"FROM ctm.touches " +
				"WHERE date=current_date() " +
				"AND type='C' " +
				"AND touches.operator_id=(SELECT ldapuid FROM simples.user WHERE id=?);"
			);

			stmt.setInt(1, userId);
			results = stmt.executeQuery();
			if (results != null && results.next()) {
				sales = results.getInt("sales");
			}

			/* getting hot leads */
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT COUNT(id) AS hotLeads FROM simples.message_queue_available WHERE statusId = ?"
			);

			stmt.setInt(1, MessageStatus.STATUS_NEW);
			results = stmt.executeQuery();
			if (results != null && results.next()) {
				hotLeads = results.getInt("hotLeads");
			}

			/* getting remaining leads */
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT COUNT(id) as remainingLeads FROM simples.message_queue_available WHERE userId IN (0,?) AND statusId NOT IN (?, ?, ? /*PMs are not active leads*/)"
			);

			stmt.setInt(1, userId);

			stmt.setInt(2, MessageStatus.STATUS_NEW);
			stmt.setInt(3, MessageStatus.STATUS_COMPLETED_AS_PM);
			stmt.setInt(4, MessageStatus.STATUS_CHANGED_TIME_FOR_PM);

			results = stmt.executeQuery();
			if (results != null && results.next()) {
				remainingLeads = results.getInt("remainingLeads");
			}

			/* getting future leads */
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT COUNT(id) as futureLeads FROM simples.message WHERE userId IN (0,?) AND whenToAction > NOW() AND statusId NOT IN (?, ?, ?, ? /*PMs and Completed*/)"
			);

			stmt.setInt(1, userId);

			stmt.setInt(2, MessageStatus.STATUS_COMPLETED);
			stmt.setInt(3, MessageStatus.STATUS_COMPLETED_AS_PM);
			stmt.setInt(4, MessageStatus.STATUS_REMOVED_FROM_PM);
			stmt.setInt(5, MessageStatus.STATUS_CHANGED_TIME_FOR_PM);

			results = stmt.executeQuery();
			if (results != null && results.next()) {
				futureLeads = results.getInt("futureLeads");
			}

			/* calculating conversion and contact rate */
			int validCompleted = completed + completedAsPM - invalidLeads;
			if(validCompleted != 0){
				/* conversion */
				conversion = (double) sales / validCompleted * 100.0;
				conversion = Math.round( conversion * 100.0 ) / 100.0; // rounded up to 2 decimals

				/* contact rate */
				int validMessages = completed + completedAsPM + postponed + unsuccessful - invalidLeads;
				if(validMessages != 0){
					contact = (double) validCompleted / validMessages * 100;
					contact = Math.round( contact * 100.0 ) / 100.0; // rounded up to 2 decimals\
				}
			}

			/* set model */
			userStats.setCompleted(completed);
			userStats.setCompletedAsPM(completedAsPM);
			userStats.setUnsuccessful(unsuccessful);
			userStats.setPostponed(postponed);
			userStats.setSales(sales);
			userStats.setConversion(conversion);
			userStats.setContact(contact);
			userStats.setHot(hotLeads);
			userStats.setRemaining(remainingLeads);
			userStats.setFuture(futureLeads);

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
