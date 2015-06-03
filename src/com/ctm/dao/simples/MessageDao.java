package com.ctm.dao.simples;

import static com.ctm.model.simples.MessageStatus.STATUS_CHANGED_TIME_FOR_PM;
import static com.ctm.model.simples.MessageStatus.STATUS_COMPLETED_AS_PM;
import static com.ctm.model.simples.MessageStatus.STATUS_POSTPONED;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

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
import com.ctm.model.simples.Rule;
import com.ctm.model.simples.User;

public class MessageDao {
	private static final Logger logger = Logger.getLogger(MessageDao.class.getName());

	private final String MESSAGE_AVAILABLE_UPDATE = "UPDATE simples.message m, (";
	private final String MESSAGE_AVAILABLE_UPDATE_SET = ") as t set m.userId = ? WHERE m.id = t.id ";

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

	public Message getMessageByRootId(final long rootId) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT msg.id " +
					"FROM  simples.message msg " +
					"WHERE msg.transactionId = ? " +
					"LIMIT 1;"
			);
			stmt.setLong(1, rootId);

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
	public Message getNextMessage(int userId, List<Rule> getNextMessageRules) throws DaoException {

		if (userId <= 0) {
			throw new DaoException("userId must be greater than zero.");
		}

		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		PreparedStatement stmtUpdate = null;
		PreparedStatement stmtSelect = null;
		ResultSet resultSet = null;

		try {
			for(Rule rule : getNextMessageRules) {

				// - rule_0 and rule_3 only need to select as they have already been assigned
				// - regular expression to match userid=?, userid = ?, userid   =? (zero or more space before and after = sign with x number of characters before it)
				if(Pattern.matches(".* userid\\s*=\\s*\\?\\s*.*", rule.getValue().toLowerCase())) {
					stmtSelect = dbSource.getConnection().prepareStatement(rule.getValue());
					stmtSelect.setInt(1, userId);

					resultSet = stmtSelect.executeQuery();
					List<Message> messages = mapFieldsFromResultsToMessage(resultSet);

					if(!messages.isEmpty()) {
						Message message = messages.get(0);
						message.setUserId(userId);

						return message;
					}
				} else {
					stmtUpdate = dbSource.getConnection().prepareStatement(MESSAGE_AVAILABLE_UPDATE + rule.getValue() + MESSAGE_AVAILABLE_UPDATE_SET);

					stmtUpdate.setInt(1, userId);

					int numberOfRows = stmtUpdate.executeUpdate();
					if(numberOfRows > 0) {
						// - regular expression to match userid=0, userid = 0, userid   =0 (zero or more space before and after = sign)
						// We run an update on select before, so changing userId = 0 to userId = ? to get what was assigned.
						stmtSelect = dbSource.getConnection().prepareStatement(rule.getValue().toLowerCase().replaceAll("userid\\s*=\\s*0", "userId = ?"));
						stmtSelect.setInt(1, userId);

						resultSet = stmtSelect.executeQuery();
						Message message = mapFieldsFromResultsToMessage(resultSet).get(0);
						message.setUserId(userId);

						return message;
					}
				}
			}

			return new Message();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			try {
				if(resultSet != null) {
					resultSet.close();
				}
				if(stmtUpdate != null) {
					stmtUpdate.close();
				}
				if(stmtSelect != null) {
					stmtSelect.close();
				}
			} catch (SQLException e) {
				throw new DaoException(e.getMessage(), e);
			}
			dbSource.closeConnection();
		}
	}

	/**
	 * get next mssage flag, if true, use the new method
	 * TODO: remove when we tested on production
	 */
	public boolean useNewMethodToGetNexMessage() throws DaoException {

		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		PreparedStatement stmt = null;
		ResultSet results = null;

		try {
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT value FROM simples.settings WHERE `key` = 'oldGetNextMessage';"
			);

			results = stmt.executeQuery();

			while (results.next()) {
				return !results.getBoolean("value");
			}
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
		// Make sure we perform the increase to callAttempts as well as the whenToAction BEFORE the userid/status change which causes issues due to database deadlocking
		incrementCallAttempts(messageId);
		updateUserAndStatus(messageId, 0, MessageStatus.STATUS_UNSUCCESSFUL);

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

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		PreparedStatement stmtSelectMessage = null;
		PreparedStatement stmtSelectMessageSource = null;
		PreparedStatement stmtUpdate = null;

		ResultSet resultSetSelectMessage = null;
		ResultSet resultSetSelectMessageSource = null;
		int outcome = 0;

		boolean autoCommit = true;
		try {
			autoCommit = dbSource.getConnection().getAutoCommit();
			dbSource.getConnection().setAutoCommit(false);

			stmtSelectMessage = dbSource.getConnection().prepareStatement(
					"SELECT sourceId, callAttempts " +
					"FROM simples.message " +
					"WHERE id = ? FOR UPDATE"
			);
			stmtSelectMessage.setInt(1, messageId);

			// Lock the message
			resultSetSelectMessage = stmtSelectMessage.executeQuery();
			resultSetSelectMessage.next();
			int sourceId = resultSetSelectMessage.getInt("sourceId");
			int callAttempts = resultSetSelectMessage.getInt("callAttempts");

			stmtSelectMessageSource = dbSource.getConnection().prepareStatement(
					"SELECT attemptDelay1, attemptDelay2, attemptDelay3 " +
					"FROM simples.message_source " +
					"WHERE id = ? "
			);
			stmtSelectMessageSource.setInt(1, sourceId);

			resultSetSelectMessageSource = stmtSelectMessageSource.executeQuery();
			resultSetSelectMessageSource.next();
			long attemptDelay1 = resultSetSelectMessageSource.getLong(1);
			long attemptDelay2 = resultSetSelectMessageSource.getLong(2);
			long attemptDelay3 = resultSetSelectMessageSource.getLong(3);

			long delay = -1;
			switch ((callAttempts + 1)) {
				case 1:
					delay = attemptDelay1;
					break;
				case 2:
					delay = attemptDelay2;
					break;
				default:
					delay = attemptDelay3;
					break;
			}

			stmtUpdate = dbSource.getConnection().prepareStatement(
				"UPDATE simples.message " +
				"SET callAttempts = callAttempts + 1, whenToAction = ADDTIME(NOW(), SEC_TO_TIME(? * 60)) " +
				"WHERE id = ?"
			);
			stmtUpdate.setLong(1, delay);
			stmtUpdate.setInt(2, messageId);

			outcome = stmtUpdate.executeUpdate();

			dbSource.getConnection().commit();
		}
		catch (SQLException | NamingException e) {
			try {
				dbSource.getConnection().rollback();
			} catch (SQLException | NamingException e1) {
				throw new DaoException(e.getMessage(), e1);
			}
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			try {
				dbSource.getConnection().setAutoCommit(autoCommit);
				if(stmtSelectMessage != null) {
					stmtSelectMessage.close();
				}
				if(stmtSelectMessageSource != null) {
					stmtSelectMessageSource.close();
				}
				if(stmtUpdate != null) {
					stmtUpdate.close();
				}

				if(resultSetSelectMessage != null) {
					resultSetSelectMessage.close();
				}
				if(resultSetSelectMessageSource != null) {
					resultSetSelectMessageSource.close();
				}
			} catch (SQLException | NamingException e) {
				throw new DaoException(e.getMessage(), e);
			}
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
}
