package com.ctm.services.simples;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.dao.BlacklistDao;
import com.ctm.dao.CommentDao;
import com.ctm.dao.TouchDao;
import com.ctm.dao.TransactionDao;
import com.ctm.dao.UserDao;
import com.ctm.dao.simples.MessageAuditDao;
import com.ctm.dao.simples.MessageDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.Transaction;
import com.ctm.model.TransactionProperties;
import com.ctm.model.formatter.JsonUtils;
import com.ctm.model.simples.BlacklistChannel;
import com.ctm.model.simples.JsonResponse;
import com.ctm.model.simples.Message;
import com.ctm.model.simples.MessageAudit;
import com.ctm.model.simples.MessageStatus;
import com.ctm.model.simples.User;
import com.ctm.services.ApplicationService;

public class SimplesMessageService {
	private static final Logger logger = Logger.getLogger(SimplesMessageService.class.getName());



	public List<Message> postponedMessages(final int userId) throws DaoException {
		final MessageDao messageDao = new MessageDao();
		return messageDao.postponedMessages(userId);
	}

	public JSONObject getMessage(final int messageId) throws DaoException, JSONException {
		final MessageDao messageDao = new MessageDao();
		final Message message = messageDao.getMessage(messageId);
		return buildMessageWithDetails(message);
	}



	/**
	 * This is a smoosh of Messages + Transaction details.
	 * @param message
	 * @return
	 * @throws DaoException
	 * @throws JSONException
	 */
	public JSONObject buildMessageWithDetails(Message message) throws DaoException, JSONException {
		TransactionProperties details = new TransactionProperties();
		TransactionDao transactionDao = new TransactionDao();
		ArrayList<MessageAudit> audits = new ArrayList<MessageAudit>();
		MessageAuditDao messageAuditDao = new MessageAuditDao();

		//
		// Collect the extra details
		//
		details.setTransactionId(message.getTransactionId());
		transactionDao.getCoreInformation(details);

		CommentDao comments = new CommentDao();
		details.setComments( comments.getCommentsForTransactionId(message.getTransactionId()) );

		TouchDao touches = new TouchDao();
		details.setTouches( touches.getTouchesForTransactionId(message.getTransactionId()) );

		audits = messageAuditDao.getMessageAudits(message.getMessageId());

		//
		// Merge the objects (yikes...)
		//
		JSONObject json = details.toJsonObject(true);
		JSONObject messageJsonObj = message.toJsonObject();
		Iterator<?> it = messageJsonObj.keys();
		String tmp_key;

		while (it.hasNext()) {
			tmp_key = (String) it.next();
			json.put(tmp_key, messageJsonObj.get(tmp_key));
		}

		JsonUtils.addListToJsonObject(json, MessageAudit.JSON_COLLECTION_NAME, audits);

		return json;
	}


	/**
	 * Get a message from the message queue. The provided User ID may be used to target specific messages, and they will be assigned the message.
	 *
	 * @param userId ID of the user who is getting the message
	 * @return JSON string
	 */
	public String getNextMessageForUser(HttpServletRequest request, int userId) throws ConfigSettingException{
		Message message = new Message();
		MessageDao messageDao = new MessageDao();
		BlacklistDao blacklistDao = new BlacklistDao();
		JSONObject json = new JSONObject();

		try {
			message = messageDao.getNextMessage(userId);

			if (message.getMessageId() == 0) {
				// No message available
				json = message.toJsonObject();
			}
			else {
				int styleCodeId = ApplicationService.getBrandFromRequest(request).getId();

				if (blacklistDao.isBlacklisted(styleCodeId, BlacklistChannel.PHONE, message.getPhoneNumber1()) ||
					blacklistDao.isBlacklisted(styleCodeId, BlacklistChannel.PHONE, message.getPhoneNumber2())) {

					// if message's phone number is in the blacklist, set the message to complete with reasonId 9 (Do not Contact)
					setMessageToComplete(request, userId, message.getMessageId(), 9);

					return getNextMessageForUser(request, userId);
				}

				// If the message is new or is a different user, assign it to our user.
				// Do as last step in case anything above broke
				if (message.getStatusId() == MessageStatus.STATUS_NEW || message.getUserId() != userId) {
					messageDao.assignMessageToUser(message.getMessageId(), userId);
				}

				// Build the associated details
				json = buildMessageWithDetails(message);
			}
		}
		catch (DaoException | JSONException e) {
			logger.error("Could not get next message for user '"+userId+"'", e);

			JsonResponse jsonResponse = new JsonResponse();
			Error error = new Error(e.getMessage());
			jsonResponse.addError(error);
			json = jsonResponse.toJsonObject(true);
		}

		return json.toString();
	}



	/**
	 * Postpone a message
	 * @param actionIsPerformedByUserId User ID
	 * @param messageId
	 * @param reasonStatusId Reason status for the postpone
	 * @param postponeDate yyyy-MM-dd
	 * @param postponeTime hh:mm
	 * @param postponeAMPM "AM" or "PM"
	 * @param comment
	 * @param assignToUser
	 * @return
	 */
	public String postponeMessage(int actionIsPerformedByUserId, int messageId, int reasonStatusId, String postponeDate, String postponeTime, String postponeAMPM, String comment, boolean assignToUser) {
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {
			boolean unassign = false;
			if (assignToUser == false) unassign = true;

			Date postponeTo = new SimpleDateFormat("yyyy-MM-dd hh:mm a", Locale.ENGLISH).parse(postponeDate + " " + postponeTime + " " + postponeAMPM);

			messageDao.postponeMessage(actionIsPerformedByUserId, messageId, reasonStatusId, postponeTo, comment, unassign);

		}
		catch (DaoException e) {
			logger.error("Could not postpone message '"+messageId+"'", e);

			Error error = new Error(e.getMessage());
			details.addError(error);
		}
		catch (ParseException e) {
			logger.error("Could not postpone message '"+messageId+"'", e);

			Error error = new Error(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

	/**
	 *
	 */
	public String setMessageToComplete(HttpServletRequest request, int actionIsPerformedByUserId, int messageId, int reasonStatusId) throws ConfigSettingException{
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {

			Message message = messageDao.setMessageToCompleted(actionIsPerformedByUserId, messageId, reasonStatusId);

			// Check the reasonStatusId, if it equals 9 (Do not contact), add contact to Blacklist
			if (reasonStatusId == 9) {

				SimplesBlacklistService simplesBlacklistService = new SimplesBlacklistService();
				UserDao userDao = new UserDao();
				User user = userDao.getUser(actionIsPerformedByUserId);
				String comment = "added to blacklist by choosing (Do not Contact)";

				if (message.getPhoneNumber1() != null && message.getPhoneNumber1().length() > 0) {
					simplesBlacklistService.addToBlacklist(request, "phone", message.getPhoneNumber1(), user.getUsername(), comment);
				}

				if (message.getPhoneNumber2() != null && message.getPhoneNumber2().length() > 0) {
					simplesBlacklistService.addToBlacklist(request, "phone", message.getPhoneNumber2(), user.getUsername(), comment);
				}
			}

		}
		catch (DaoException e) {
			logger.error("Could not set message '"+messageId+"'", e);

			Error error = new Error(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

	/**
	 *
	 */
	public String setMessageToInProgress(int actionIsPerformedByUserId, int messageId) {
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {

			messageDao.setMessageToInProgress(actionIsPerformedByUserId, messageId);

		}
		catch (DaoException e) {
			logger.error("Could not set message '"+messageId+"'", e);

			Error error = new Error(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

	/**
	 *
	 */
	public String setMessageToUnsuccessful(int actionIsPerformedByUserId, int messageId, int reasonStatusId) {
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {

			messageDao.setMessageToUnsuccessful(actionIsPerformedByUserId, messageId, reasonStatusId);

		}
		catch (DaoException e) {
			logger.error("Could not set message '"+messageId+"'", e);

			Error error = new Error(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

}
