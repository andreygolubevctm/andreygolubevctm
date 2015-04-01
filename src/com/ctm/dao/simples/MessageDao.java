package com.ctm.dao.simples;

import static com.ctm.model.simples.MessageStatus.STATUS_POSTPONED;
import static com.ctm.model.simples.MessageStatus.STATUS_COMPLETED_AS_PM;
import static com.ctm.model.simples.MessageStatus.STATUS_CHANGED_TIME_FOR_PM;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.dao.CommentDao;
import com.ctm.dao.UserDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Comment;
import com.ctm.model.simples.Message;
import com.ctm.model.simples.MessageAudit;
import com.ctm.model.simples.MessageStatus;
import com.ctm.model.simples.User;

public class MessageDao {
	private static final Logger logger = Logger.getLogger(MessageDao.class.getName());

	private static final String MESSAGE_AVAILABLE_SELECT = "SELECT id, transactionId, userId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, canPostpone, whenToAction, created " +
			"FROM simples.message_queue_available avail ";

	// -- Rule 0: Messages assigned to users, (InProgress, Postponed, Assigned, Unsuccessful), deal with your current message
	private static final String MESSAGE_AVAILABLE_RULE_0 = MESSAGE_AVAILABLE_SELECT +
			"WHERE userId = ? AND statusId IN (1, 3, 4, 5, 6) " +
			"ORDER BY whenToAction ASC " +
			"LIMIT 1 FOR UPDATE";
	// -- Rule 1: CTM fail joins, last in first out
	private static final String MESSAGE_AVAILABLE_RULE_1 = MESSAGE_AVAILABLE_SELECT +
			"WHERE avail.sourceId = 5 " +
			"AND userId = 0 " +
			"ORDER BY avail.created DESC, avail.id DESC " +
			"LIMIT 1 FOR UPDATE";
	// -- Rule 2: WHITELABLE fail joins, last in first out
	private static final String MESSAGE_AVAILABLE_RULE_2 = MESSAGE_AVAILABLE_SELECT +
			"WHERE avail.sourceId = 8 " +
			"AND userId = 0 " +
			"ORDER BY avail.created DESC, avail.id DESC " +
			"LIMIT 1 FOR UPDATE";
	// -- Rule 3: Messages assigned to users, (Personal Messages)
	private static final String MESSAGE_AVAILABLE_RULE_3 = MESSAGE_AVAILABLE_SELECT +
			"WHERE userId = ? AND statusId IN (31, 32) " +
			"ORDER BY whenToAction ASC " +
			"LIMIT 1 FOR UPDATE";
	// -- Rule 4: Any new messages created, sorted by source priority then last in first out
	private static final String MESSAGE_AVAILABLE_RULE_4 = MESSAGE_AVAILABLE_SELECT +
			"WHERE statusId = 1 " +
			"AND userId = 0 " +
			"ORDER BY avail.created DESC, avail.id DESC " +
			"LIMIT 1 FOR UPDATE";
	// -- Rule 5: All first time postponements and call attempt, last in first out
	private static final String MESSAGE_AVAILABLE_RULE_5 = MESSAGE_AVAILABLE_SELECT +
			"WHERE postponeCount <= 1 AND callAttempts <= 1 " +
			"AND userId = 0 " +
			"ORDER BY avail.created DESC, avail.id DESC " +
			"LIMIT 1 FOR UPDATE";
	// -- Rule 6: All second time postponements and call attempt, last in first out
	private static final String MESSAGE_AVAILABLE_RULE_6 = MESSAGE_AVAILABLE_SELECT +
			"WHERE postponeCount <= 2 AND callAttempts <= 2 " +
			"AND userId = 0 " +
			"ORDER BY avail.created DESC, avail.id DESC " +
			"LIMIT 1 FOR UPDATE";
	// -- Rule 7: All other postponed or unseccussful messages, last in first out
	private static final String MESSAGE_AVAILABLE_RULE_7 = MESSAGE_AVAILABLE_SELECT +
			"WHERE (postponeCount > 2 OR callAttempts > 2) " +
			"AND userId = 0 " +
			"ORDER BY avail.created DESC, avail.id DESC " +
			"LIMIT 1 FOR UPDATE";
	private static final String MESSAGE_AVAILABLE_RULES[] = new String[]{
			MESSAGE_AVAILABLE_RULE_0,
			MESSAGE_AVAILABLE_RULE_1,
			MESSAGE_AVAILABLE_RULE_2,
			MESSAGE_AVAILABLE_RULE_3,
			MESSAGE_AVAILABLE_RULE_4,
			MESSAGE_AVAILABLE_RULE_5,
			MESSAGE_AVAILABLE_RULE_6,
			MESSAGE_AVAILABLE_RULE_7
	};


	public Message getMessage(final int messageId) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT msg.id, transactionId, userId, msg.statusId, stat.status, contactName, phoneNumber1, phoneNumber2, state, whenToAction, created " +
				", IF(msg.postponeCount < src.maxPostpones, 1, 0) AS canPostpone " +
				"FROM simples.message msg " +
				"INNER JOIN simples.message_source src ON src.id = msg.sourceId " +
				"LEFT JOIN simples.message_status stat ON stat.id = msg.statusId " +
				"WHERE msg.id = ?;"
			);
			stmt.setInt(1, messageId);
			final List<Message> messages = mapFieldsFromResultsToMessage(stmt.executeQuery());
			if (messages.isEmpty()) {
				throw new DaoException("Unable to find message id=" + messageId);
			}
			return messages.get(0);
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	public Message getMessageByTransactionId(final long transactionId) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT msg.id FROM aggregator.transaction_header th " +
					"INNER JOIN simples.message msg ON msg.transactionId = th.rootId " +
					"WHERE th.transactionId = ? LIMIT 1;"
			);
			stmt.setLong(1, transactionId);

			final ResultSet results = stmt.executeQuery();
			if (results.next()) {
				return getMessage(results.getInt("id"));
			}
			else {
				return null;
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
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

		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		boolean autoCommit = true;
		PreparedStatement stmt = null;

		try {
			Message message = null;
			autoCommit = dbSource.getConnection().getAutoCommit();
			dbSource.getConnection().setAutoCommit(false);

			for(String rule : MESSAGE_AVAILABLE_RULES) {
				ExecuteMessageQueueRule executeMessageQueueRule = new ExecuteMessageQueueRule(dbSource, rule, userId).invoke();
				if (executeMessageQueueRule.is()) {
					message = executeMessageQueueRule.getMessage();
					break;
				}
			}

			if (message != null) {
				stmt = dbSource.getConnection().prepareStatement(
						"UPDATE simples.message " +
						"SET userId = ? " +
						"WHERE id = ?");

				stmt.setInt(1, userId);
				stmt.setInt(2, message.getMessageId());

				stmt.executeUpdate();
				message.setUserId(userId);

				dbSource.getConnection().commit();
				return message;
			}

			dbSource.getConnection().commit();
			return new Message();
		}
		catch (SQLException | NamingException e) {
			try {
				logger.error("Simple getNextMessage transaction is being rolled back");
				dbSource.getConnection().rollback();
			} catch (SQLException | NamingException e1) {
				throw new DaoException(e.getMessage(), e);
			}
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			try {
				dbSource.getConnection().setAutoCommit(autoCommit);
				if(stmt != null) {
					stmt.close();
				}
			} catch (SQLException | NamingException e) {
				throw new DaoException(e.getMessage(), e);
			}
			dbSource.closeConnection();
		}
	}


	/**
	 * Get a message from the message queue. The provided User ID may be used to target specific messages.
	 *
	 * @param userId ID of the user who is getting the message
	 * @return Message model
	 * @throws DaoException
	 */
	public Message getNextMessageOld(int userId) throws DaoException {

		if (userId <= 0) {
			throw new DaoException("userId must be greater than zero.");
		}

		SimpleDatabaseConnection dbSource = null;

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

			final ResultSet results = stmt.executeQuery();
			List<Message> messages = mapFieldsFromResultsToMessage(results);
			if (messages.size() > 0) {
				return messages.get(0);
			}

			return new Message();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	/**
	 * get next mssage flag, if true, use the new method
	 * TODO: remove when we tested on production
	 */
	public boolean useNewMethodToGetNexMessage() throws DaoException {

		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT isNew, isNew2 FROM simples.next_message_flag;"
			);

			final ResultSet results = stmt.executeQuery();

			while (results.next()) {
				return results.getBoolean("isNew") || results.getBoolean("isNew2");
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return false;
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
				"SELECT ms.id, ms.status " +
				"FROM simples.message_status ms " +
				"INNER JOIN simples.message_status_mapping msp " +
				"ON msp.statusId = ms.id " +
				"WHERE msp.parentId = ? " +
				"AND ms.active = 1;"
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
	 * @param statusId: Contains [postpone], [completed as pm], [change time for PM]
	 * @param reasonStatusId Reason for the action
	 * @param postponeTo
	 * @param unassign Set to true to assign the message to nobody
	 * @param comment
	 */
	public void postponeMessage(int actionIsPerformedByUserId, int messageId, int statusId, int reasonStatusId, Date postponeTo, String comment, boolean unassign) throws DaoException {
		// Get the message so we can use some of its details
		Message message = getMessage(messageId);

		// Audit this action
		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(actionIsPerformedByUserId);
		messageAudit.setStatusId(statusId);
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
			stmt.setInt(2, statusId);
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
	 * @param statusId Contains [Completed], [Removed from PM]
	 * @param reasonStatusId ID of the reason status
	 * @return message
	 */
	public Message setMessageToCompleted(int actionIsPerformedByUserId, int messageId, int statusId, int reasonStatusId) throws DaoException {
		// Get the message so we can use some of its details
		Message message = getMessage(messageId);

		// Audit this action
		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(actionIsPerformedByUserId);
		messageAudit.setStatusId(statusId);
		messageAudit.setReasonStatusId(reasonStatusId);

		if (actionIsPerformedByUserId != message.getUserId()) {
			messageAudit.setComment("Completed by userId '" + actionIsPerformedByUserId + "' (message.userId=" + message.getUserId() + ")");
		}

		MessageAuditDao messageAuditDao = new MessageAuditDao();
		messageAuditDao.addMessageAudit(messageAudit);

		// Perform the action
		updateUserAndStatus(messageId, message.getUserId(), statusId);

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
		if (message.getStatusId() == STATUS_POSTPONED) {
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
		// 0 for user ID because we're un-assigning it.
		updateUserAndStatus(messageId, 0, MessageStatus.STATUS_UNSUCCESSFUL);
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
	 */
	private List<Message> mapFieldsFromResultsToMessage(final ResultSet results) throws SQLException {
		final List<Message> messages = new ArrayList<>();
		while (results.next()) {
			messages.add(message(results));
		}
		return messages;
	}

	private Message message(final ResultSet results) throws SQLException {
		final Message message = new Message();
		message.setMessageId(results.getInt("id"));
		message.setTransactionId(results.getLong("transactionId"));
		message.setUserId(results.getInt("userId"));
		message.setStatusId(results.getInt("statusId"));
		message.setStatus(results.getString("status"));
		message.setContactName(results.getString("contactName"));
		message.setPhoneNumber1(results.getString("phoneNumber1"));
		message.setPhoneNumber2(results.getString("phoneNumber2"));
		message.setState(results.getString("state"));
		message.setWhenToAction(results.getTimestamp("whenToAction"));
		message.setCreated(results.getTimestamp("created"));

		// Fields that may not exist depending on method that is calling this.
		try {
			message.setCanPostpone(results.getBoolean("canPostpone"));
		}
		catch (final SQLException ignored) {}
		return message;
	}

	public List<Message> postponedMessages(final int userId) throws DaoException {
		final SimpleDatabaseConnection simpleDatabaseConnection = new SimpleDatabaseConnection();
		try {
			final Connection connection = simpleDatabaseConnection.getConnection();
			final PreparedStatement statement = connection.prepareStatement(
				"SELECT msg.id, transactionId, userId, statusId, status, contactName, phoneNumber1, phoneNumber2, state, whenToAction, created " +
				"FROM simples.message msg " +
				"LEFT JOIN simples.message_status stat ON stat.id = msg.statusId " +
				"WHERE statusId IN (?, ?, ?) AND userId = ? " +
				"ORDER BY whenToAction ASC");
			statement.setInt(1, STATUS_POSTPONED);
			statement.setInt(2, STATUS_COMPLETED_AS_PM);
			statement.setInt(3, STATUS_CHANGED_TIME_FOR_PM);
			statement.setInt(4, userId);
			final ResultSet results = statement.executeQuery();
			return mapFieldsFromResultsToMessage(results);
		} catch (SQLException | NamingException e) {
			logger.error("unable to retrieve postponed messages for userId = " + userId, e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			simpleDatabaseConnection.closeConnection();
		}
	}

	/**
	 * Defer a new message, just to get the message out of the queue
	 *
	 * @param actionIsPerformedByUserId User ID of user performing this action
	 * @param messageId ID of message
	 * @param statusId ID of status
	 * @param deferTo
	 * @param unassign Set to true to assign the message to nobody
	 */
	public void deferMessage(int actionIsPerformedByUserId, int messageId, int statusId, Date deferTo, boolean unassign) throws DaoException {

		// Get the message so we can use some of its details
		Message message = getMessage(messageId);

		// Audit this action
		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(actionIsPerformedByUserId);
		messageAudit.setStatusId(statusId);
		messageAudit.setReasonStatusId(MessageStatus.STATUS_SKIP_AND_DEFER);
		messageAudit.setComment("Skipped and deferred by userId '" + actionIsPerformedByUserId + "' (message.userId=" + message.getUserId() + ") until " + deferTo.toString() + ", unassign=" + unassign);

		MessageAuditDao messageAuditDao = new MessageAuditDao();
		messageAuditDao.addMessageAudit(messageAudit);

		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		int userId = actionIsPerformedByUserId;
		if (unassign) userId = 0;

		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"UPDATE simples.message " +
				"SET userId = ?, whenToAction = ? " +
				"WHERE id = ?;"
			);
			stmt.setInt(1, userId);
			stmt.setTimestamp(2, new java.sql.Timestamp(deferTo.getTime()));
			stmt.setInt(3, messageId);

			stmt.executeUpdate();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	private class ExecuteMessageQueueRule {
		private boolean myResult;
		private SimpleDatabaseConnection dbSource;
		private String rule0;
		private Message message;
		private int userId;

		public ExecuteMessageQueueRule(SimpleDatabaseConnection dbSource, String rule0, int userId) {
			this.dbSource = dbSource;
			this.rule0 = rule0;
			this.userId = userId;
		}

		boolean is() {
			return myResult;
		}

		public Message getMessage() {
			return message;
		}

		public ExecuteMessageQueueRule invoke() throws DaoException, SQLException {
			PreparedStatement stmt = null;

			try {
				stmt = dbSource.getConnection().prepareStatement(rule0);

				if (rule0.equals(MESSAGE_AVAILABLE_RULE_0) || rule0.equals(MESSAGE_AVAILABLE_RULE_3)) {
					stmt.setInt(1, userId);
				}

				final ResultSet results = stmt.executeQuery();
				List<Message> messages = mapFieldsFromResultsToMessage(results);

				if (messages.size() > 0) {
					message = messages.get(0);
					myResult = true;
					return this;
				}
				myResult = false;
				return this;
			} catch (SQLException | NamingException e) {
				throw new DaoException(e.getMessage(), e);
			} finally {
				if(stmt != null) {
					stmt.close();
				}
			}
		}
	}
}
