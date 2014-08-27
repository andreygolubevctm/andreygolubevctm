package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Comment;
import com.ctm.model.simples.Message;
import com.ctm.model.simples.MessageAudit;
import com.ctm.model.simples.MessageStatus;
import com.ctm.model.simples.User;

public class MessageDao {
	private static Logger logger = Logger.getLogger(MessageDao.class.getName());

	/**
	 * Get a message. Currently not public method due to being incomplete.
	 */
	protected Message getMessage(int messageId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		Message message = new Message();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT msg.id, transactionId, userId, msg.statusId, stat.status, contactName, phoneNumber1, phoneNumber2, state " +
				"FROM simples.message msg " +
				"LEFT JOIN simples.message_status stat ON stat.id = msg.statusId " +
				"WHERE msg.id = ?;"
			);
			stmt.setInt(1, messageId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				mapFieldsFromResultsToMessage(results, message);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return message;
	}

	/**
	 * Get a message from the message queue. The provided User ID may be used to target specific messages.
	 *
	 * @param userId ID of the user who is getting the message
	 * @return Message model
	 * @throws DaoException
	 */
	public Message getNextMessage(int userId) throws DaoException {

		if (userId <= 0) {
			throw new DaoException("userId must be greater than zero.");
		}

		SimpleDatabaseConnection dbSource = null;
		Message message = new Message();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			//
			// Execute the stored procedure for message details
			//
			stmt = dbSource.getConnection().prepareStatement(
				"CALL simples.message_get_next(?);"
			);
			stmt.setInt(1, userId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				mapFieldsFromResultsToMessage(results, message);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return message;
	}

	/**
	 * Get a list of message statuses.
	 */
	public ArrayList<MessageStatus> getStatuses(int parentStatusId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<MessageStatus> list = new ArrayList<MessageStatus>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT id, status " +
				"FROM simples.message_status " +
				"WHERE parentId = ?;"
			);
			stmt.setInt(1, parentStatusId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				MessageStatus status = new MessageStatus();
				status.setId(results.getInt("id"));
				status.setStatus(results.getString("status"));
				list.add(status);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return list;
	}

	/**
	 * Assign a message to a user
	 * @param messageId Message to assign
	 * @param userId User to assign to
	 */
	public void assignMessageToUser(int messageId, int userId) throws DaoException {
		// Audit this action
		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(userId);
		messageAudit.setStatusId(MessageStatus.STATUS_ASSIGNED);

		MessageAuditDao messageAuditDao = new MessageAuditDao();
		messageAuditDao.addMessageAudit(messageAudit);

		// Perform the action
		updateUserAndStatus(messageId, userId, MessageStatus.STATUS_ASSIGNED);

		logger.debug("Message " + messageId + " ASSIGNED to user " + userId);
	}

	/**
	 * Postpone a message.
	 *
	 * @param actionIsPerformedByUserId User ID of user performing this action
	 * @param messageId ID of message
	 * @param reasonStatusId Reason for the action
	 * @param postponeTo
	 * @param unassign Set to true to assign the message to nobody
	 * @param comment
	 */
	public void postponeMessage(int actionIsPerformedByUserId, int messageId, int reasonStatusId, Date postponeTo, String comment, boolean unassign) throws DaoException {
		// Get the message so we can use some of its details
		Message message = getMessage(messageId);

		// Audit this action
		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(actionIsPerformedByUserId);
		messageAudit.setStatusId(MessageStatus.STATUS_POSTPONED);
		messageAudit.setReasonStatusId(reasonStatusId);
		messageAudit.setComment("Postponed by userId '" + actionIsPerformedByUserId + "' (message.userId=" + message.getUserId() + ") until " + postponeTo.toString() + ", unassign=" + unassign);

		MessageAuditDao messageAuditDao = new MessageAuditDao();
		messageAuditDao.addMessageAudit(messageAudit);

		UserDao userDao = new UserDao();

		// Add a comment?
		if (comment.length() > 0) {
			// Get the user
			User user = userDao.getUser(actionIsPerformedByUserId);

			Comment commentObj = new Comment();
			commentObj.setTransactionId(message.getTransactionId());
			commentObj.setOperator(user.getUsername());
			commentObj.setComment(comment);

			CommentDao commentDao = new CommentDao();
			commentDao.addComment(commentObj);
		}

		// Perform the action
		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			int userId = actionIsPerformedByUserId;
			if (unassign) userId = 0;

			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE simples.message " +
				"SET userId = ?, statusId = ?, whenToAction = ?, postponeCount = postponeCount+1 " +
				"WHERE id = ?;"
			);
			stmt.setInt(1, userId);
			stmt.setInt(2, MessageStatus.STATUS_POSTPONED);
			stmt.setTimestamp(3, new java.sql.Timestamp(postponeTo.getTime()));
			stmt.setInt(4, messageId);

			stmt.executeUpdate();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		// User is done with this message
		userDao.setToAvailable(actionIsPerformedByUserId);

		logger.debug("Message " + messageId + " POSTPONED by user " + actionIsPerformedByUserId);
	}

	/**
	 * Set a message to complete.
	 *
	 * @param actionIsPerformedByUserId User ID of user performing this action
	 * @param messageId ID of message
	 * @param reasonStatusId ID of the reason status
	 * @return message
	 */
	public Message setMessageToCompleted(int actionIsPerformedByUserId, int messageId, int reasonStatusId) throws DaoException {
		// Get the message so we can use some of its details
		Message message = getMessage(messageId);

		// Audit this action
		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(actionIsPerformedByUserId);
		messageAudit.setStatusId(MessageStatus.STATUS_COMPLETED);
		messageAudit.setReasonStatusId(reasonStatusId);

		if (actionIsPerformedByUserId != message.getUserId()) {
			messageAudit.setComment("Completed by userId '" + actionIsPerformedByUserId + "' (message.userId=" + message.getUserId() + ")");
		}

		MessageAuditDao messageAuditDao = new MessageAuditDao();
		messageAuditDao.addMessageAudit(messageAudit);

		// Perform the action
		updateUserAndStatus(messageId, message.getUserId(), MessageStatus.STATUS_COMPLETED);

		// User is done with this message
		UserDao userDao = new UserDao();
		userDao.setToAvailable(actionIsPerformedByUserId);

		logger.debug("Message " + messageId + " COMPLETED by user " + actionIsPerformedByUserId);

		return message;
	}

	/**
	 * Set a message to in progress.
	 *
	 * @param actionIsPerformedByUserId User ID of user performing this action
	 * @param messageId ID of message
	 */
	public void setMessageToInProgress(int actionIsPerformedByUserId, int messageId) throws DaoException {
		// Get the message so we can use some of its details
		Message message = getMessage(messageId);

		// Audit this action
		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(actionIsPerformedByUserId);
		messageAudit.setStatusId(MessageStatus.STATUS_INPROGRESS);

		if (actionIsPerformedByUserId != message.getUserId()) {
			messageAudit.setComment("In Progress by userId '" + actionIsPerformedByUserId + "' (message.userId=" + message.getUserId() + ")");
		}

		MessageAuditDao messageAuditDao = new MessageAuditDao();
		messageAuditDao.addMessageAudit(messageAudit);

		// Change the status
		if (message.getStatusId() == MessageStatus.STATUS_POSTPONED) {
			// Do not change the status if the message is postponed, because it could be past the
			// configured expiry time (postponed is a special status that will always keep the message available).
		}
		else {
			updateUserAndStatus(messageId, message.getUserId(), MessageStatus.STATUS_INPROGRESS);
		}

		// User is now busy with this message
		UserDao userDao = new UserDao();
		userDao.setToUnavailable(message.getUserId());

		logger.debug("Message " + messageId + " IN PROGRESS by user " + actionIsPerformedByUserId);
	}

	/**
	 * Set a message to unsuccessful.
	 *
	 * @param actionIsPerformedByUserId User ID of user performing this action
	 * @param messageId ID of message
	 * @param reasonStatusId Reason for the action
	 */
	public void setMessageToUnsuccessful(int actionIsPerformedByUserId, int messageId, int reasonStatusId) throws DaoException {
		// Get the message so we can use some of its details
		Message message = getMessage(messageId);

		// Audit this action
		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(actionIsPerformedByUserId);
		messageAudit.setStatusId(MessageStatus.STATUS_UNSUCCESSFUL);
		messageAudit.setReasonStatusId(reasonStatusId);

		if (actionIsPerformedByUserId != message.getUserId()) {
			messageAudit.setComment("Unsuccessful by userId '" + actionIsPerformedByUserId + "' (message.userId=" + message.getUserId() + ")");
		}

		MessageAuditDao messageAuditDao = new MessageAuditDao();
		messageAuditDao.addMessageAudit(messageAudit);

		// Perform the action
		updateUserAndStatus(messageId, message.getUserId(), MessageStatus.STATUS_UNSUCCESSFUL);
		incrementCallAttempts(messageId);

		// User is done with this message
		UserDao userDao = new UserDao();
		userDao.setToAvailable(actionIsPerformedByUserId);

		logger.debug("Message " + messageId + " UNSUCCESSFUL by user " + actionIsPerformedByUserId);
	}



	/**
	 * Increment call attempts on a Message, and delay it taking into account the Message Source delay configuration.
	 * @return 0 if no update occurred, otherwise 1
	 */
	private int incrementCallAttempts(int messageId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		int outcome = 0;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			/*
Hey are you trying to debug this? Here is a handy SQL I prepared earlier.
It looks complicated because there are multiple attempt delay table columns, so we have to use the right one for the delay amount depending on how many attempts have already been made.

SELECT msg.id, atmpt.*, ADDTIME(NOW(), SEC_TO_TIME(atmpt.delay * 60)) AS newTime
FROM simples.message msg
INNER JOIN simples.message_source src ON src.id = msg.sourceId
INNER JOIN (
	SELECT id, 1 AS attempt, attemptDelay1 AS delay FROM simples.message_source
	UNION SELECT id, 2, attemptDelay2 FROM simples.message_source
	UNION SELECT id, 3, attemptDelay3 FROM simples.message_source
) AS atmpt ON atmpt.id = msg.sourceId AND (atmpt.attempt = callAttempts+1 OR (callAttempts+1 > 3 AND atmpt.attempt = 3))
WHERE msg.id = 53
			 */
			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE simples.message msg " +
				"INNER JOIN simples.message_source src ON src.id = msg.sourceId " +
				"INNER JOIN (" +
				"	      SELECT id, 1 AS attempt, attemptDelay1 AS delay FROM simples.message_source " +
				"	UNION SELECT id, 2, attemptDelay2 FROM simples.message_source " +
				"	UNION SELECT id, 3, attemptDelay3 FROM simples.message_source " +
				") AS atmpt ON atmpt.id = msg.sourceId AND (atmpt.attempt = callAttempts+1 OR (callAttempts+1 > 3 AND atmpt.attempt = 3)) " +
				"SET callAttempts = callAttempts + 1, whenToAction = ADDTIME(NOW(), SEC_TO_TIME(atmpt.delay * 60)) " +
				"WHERE msg.id = ?;"
			);
			stmt.setInt(1, messageId);

			outcome = stmt.executeUpdate();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return outcome;
	}

	/**
	 * Internal method to update details on a message
	 * @return 0 if no update occurred, otherwise 1
	 */
	private int updateUserAndStatus(int messageId, int userId, int statusId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		int outcome = 0;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE simples.message " +
				"SET userId = ?, statusId = ? " +
				"WHERE id = ?;"
			);
			stmt.setInt(1, userId);
			stmt.setInt(2, statusId);
			stmt.setInt(3, messageId);

			outcome = stmt.executeUpdate();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return outcome;
	}

	/**
	 * Internal method to pull the fields from a resultset and put into a Message model.
	 * @param results Result set
	 * @param message Message to map the fields onto
	 */
	private void mapFieldsFromResultsToMessage(ResultSet results, Message message) throws SQLException {
		message.setMessageId(results.getInt("id"));
		message.setTransactionId(results.getLong("transactionId"));
		message.setUserId(results.getInt("userId"));
		message.setStatusId(results.getInt("statusId"));
		message.setStatus(results.getString("status"));
		message.setContactName(results.getString("contactName"));
		message.setPhoneNumber1(results.getString("phoneNumber1"));
		message.setPhoneNumber2(results.getString("phoneNumber2"));
		message.setState(results.getString("state"));

		// Fields that may not exist depending on method that is calling this.
		try {
			message.setCanPostpone(results.getBoolean("canPostpone"));
		}
		catch (SQLException e) {}
	}
}
