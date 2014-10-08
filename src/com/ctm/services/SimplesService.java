package com.ctm.services;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.dao.CommentDao;
import com.ctm.dao.MessageAuditDao;
import com.ctm.dao.MessageDao;
import com.ctm.dao.TouchDao;
import com.ctm.dao.TransactionDao;
import com.ctm.dao.UserDao;
import com.ctm.dao.BlacklistDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.model.Comment;
import com.ctm.model.Error;
import com.ctm.model.Transaction;
import com.ctm.model.TransactionProperties;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.simples.Message;
import com.ctm.model.simples.MessageAudit;
import com.ctm.model.simples.MessageStatus;
import com.ctm.model.simples.User;
import com.ctm.model.simples.BlacklistChannel;

public class SimplesService {
	private static Logger logger = Logger.getLogger(SimplesService.class.getName());

	/**
	 * Add a comment to a transaction ID.
	 *
	 * @param transactionId
	 * @param operator
	 * @param comment
	 * @return Success true, otherwise false
	 */
	public static boolean addComment(long transactionId, String operator, String comment) {
		if (operator == "") {
			operator = "ONLINE";
		}

		Comment commentObj = new Comment();
		commentObj.setOperator(operator);
		commentObj.setComment(comment);
		commentObj.setTransactionId(transactionId);

		CommentDao commentDao = new CommentDao();
		try {
			commentDao.addComment(commentObj);
		}
		catch (DaoException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}


	/**
	 * Get a message from the message queue. The provided User ID may be used to target specific messages, and they will be assigned the message.
	 *
	 * @param userId ID of the user who is getting the message
	 * @return JSON string
	 */
	public static String getNextMessageForUser(HttpServletRequest request, int userId) throws ConfigSettingException{
		Message message = new Message();
		ArrayList<MessageAudit> audits = new ArrayList<MessageAudit>();
		MessageDao messageDao = new MessageDao();
		MessageAuditDao messageAuditDao = new MessageAuditDao();
		TransactionProperties details = new TransactionProperties();
		BlacklistDao blacklistDao = new BlacklistDao();

		try {

			message = messageDao.getNextMessage(userId);

			if (message.getMessageId() == 0) {
				throw new DaoException("No message available.");
			}

			int styleCodeId = ApplicationService.getBrandFromRequest(request).getId();

			if (blacklistDao.isBlacklisted(styleCodeId, BlacklistChannel.PHONE, message.getPhoneNumber1()) ||
				blacklistDao.isBlacklisted(styleCodeId, BlacklistChannel.PHONE, message.getPhoneNumber2())) {

				// if message's phone number is in the blacklist, set the message to complete with reasonId 9 (Do not Contact)
				setMessageToComplete(request, userId, message.getMessageId(), 9);
				return getNextMessageForUser(request, userId);
				//throw new DaoException(": This message's phone number is in the blacklist, please get next message.");
			}

			try {
				TransactionDao transactionDao = new TransactionDao();
				details.setTransactionId(message.getTransactionId());
				transactionDao.getCoreInformation(details);

				CommentDao comments = new CommentDao();
				details.setComments( comments.getCommentsForTransactionId(message.getTransactionId()) );

				TouchDao touches = new TouchDao();
				details.setTouches( touches.getTouchesForTransactionId(message.getTransactionId()) );

				audits = messageAuditDao.getMessageAudits(message.getMessageId());

				// If the message is new or is a different user, assign it to our user.
				// Do as last step in case anything above broke
				if (message.getStatusId() == MessageStatus.STATUS_NEW || message.getUserId() != userId) {

					messageDao.assignMessageToUser(message.getMessageId(), userId);

				}
			}
			catch (DaoException e) {
				logger.error("Could not get next message for user '"+userId+"'", e);

				Error error = new Error();
				error.setMessage(e.getMessage());
				details.addError(error);
			}
		}
		catch (DaoException e) {
			Error error = new Error();
			error.setMessage(e.getMessage());
			details.addError(error);
		}

		// Merge the objects (yikes...)
		JSONObject json = details.toJsonObject(true);
		JSONObject messageJsonObj = message.toJsonObject();
		Iterator it = messageJsonObj.keys();
		String tmp_key;
		try {
			while(it.hasNext()) {
				tmp_key = (String) it.next();
				json.put(tmp_key, messageJsonObj.get(tmp_key));
			}

			JSONArray array = new JSONArray();
			for (MessageAudit audit : audits) {
				array.put(audit.toJsonObject());
			}
			json.put("messageaudits", array);

		}
		catch (JSONException e) {
			logger.error("Failed to produce JSON object", e);
		}

		return json.toString();
	}


	/**
	 * Get list of users (operators) who are currently logged in.
	 */
	public static String getUsersWhoAreLoggedIn(PageSettings settings) {
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
			logger.error(e.getMessage(), e);
		}
		catch (JSONException e) {
			logger.error("Failed to produce JSON object", e);
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
	 * @return The 'uid' of the user from our database.
	 */
	public static int loginUser(String username, String extension, String displayName) throws Exception {

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

		return user.getId();
	}

	/**
	 * Log out a user.
	 * @param userId
	 */
	public static void logoutUser(int userId) {
		UserDao userdao = new UserDao();
		try {
			userdao.logoutUser(userId);
		}
		catch (DaoException e) {
			logger.error("Failed to logout user '"+userId+"'", e);
		}
	}

	/**
	 * Keep a user fresh in the user table.
	 * @param userId
	 */
	public static void tickleUser(int userId) {
		UserDao userdao = new UserDao();
		try {
			userdao.tickleUser(userId);
		}
		catch (DaoException e) {
			logger.error("Failed to tickle user '"+userId+"'", e);
		}
	}

	/**
	 *
	 */
	public static String postponeMessage(int actionIsPerformedByUserId, int messageId, int reasonStatusId, String postponeDate, String postponeTime, String comment, boolean assignToUser) {
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {
			boolean unassign = false;
			if (assignToUser == false) unassign = true;

			Date postponeTo = new SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.ENGLISH).parse(postponeDate + " " + postponeTime);

			messageDao.postponeMessage(actionIsPerformedByUserId, messageId, reasonStatusId, postponeTo, comment, unassign);

		}
		catch (DaoException e) {
			logger.error("Could not postpone message '"+messageId+"'", e);

			Error error = new Error();
			error.setMessage(e.getMessage());
			details.addError(error);
		}
		catch (ParseException e) {
			logger.error("Could not postpone message '"+messageId+"'", e);

			Error error = new Error();
			error.setMessage(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

	/**
	 *
	 */
	public static String setMessageToComplete(HttpServletRequest request, int actionIsPerformedByUserId, int messageId, int reasonStatusId) throws ConfigSettingException{
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {

			Message message = messageDao.setMessageToCompleted(actionIsPerformedByUserId, messageId, reasonStatusId);

			// Check the reasonStatusId, if it equals 9 (Do not contact), add contact to Blacklist
			if (reasonStatusId == 9) {

				UserDao userDao = new UserDao();
				User user = userDao.getUser(actionIsPerformedByUserId);
				String comment = "added to blacklist by choosing (Do not Contact)";

				if (message.getPhoneNumber1() != null && message.getPhoneNumber1() != "") {
					addToBlacklist(request, "phone", message.getPhoneNumber1(), user.getUsername(), comment);
				}

				if (message.getPhoneNumber2() != null && message.getPhoneNumber2() != "") {
					addToBlacklist(request, "phone", message.getPhoneNumber2(), user.getUsername(), comment);
				}
			}

		}
		catch (DaoException e) {
			logger.error("Could not set message '"+messageId+"'", e);

			Error error = new Error();
			error.setMessage(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

	/**
	 *
	 */
	public static String setMessageToInProgress(int actionIsPerformedByUserId, int messageId) {
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {

			messageDao.setMessageToInProgress(actionIsPerformedByUserId, messageId);

		}
		catch (DaoException e) {
			logger.error("Could not set message '"+messageId+"'", e);

			Error error = new Error();
			error.setMessage(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

	/**
	 *
	 */
	public static String setMessageToUnsuccessful(int actionIsPerformedByUserId, int messageId, int reasonStatusId) {
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {

			messageDao.setMessageToUnsuccessful(actionIsPerformedByUserId, messageId, reasonStatusId);

		}
		catch (DaoException e) {
			logger.error("Could not set message '"+messageId+"'", e);

			Error error = new Error();
			error.setMessage(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

	/**
	 * Add a value(phone number) to the blacklist against certain channel (phone, sms) and brand.
	 *
	 * @param pageContext
	 * @param channel
	 * @param value
	 * @param operator
	 * @param comment
	 * @throws DaoException
	 * @throws ConfigSettingException
	 * @return Success true, otherwise false
	 */
	public static boolean addToBlacklist(HttpServletRequest request, String channel, String value, String operator, String comment) throws DaoException, ConfigSettingException{
		BlacklistDao blacklistDao = new BlacklistDao();
		int styleCodeId = ApplicationService.getBrandFromRequest(request).getId();

		try {
			int outcome = blacklistDao.add(styleCodeId, BlacklistChannel.findByCode(channel), value);
			if (outcome > 0) {
				writeBlacklistStamp(request, channel, value, "on", operator, comment);
			}else{
				return false;
			}
		} catch (DaoException e) {
			logger.error("Could not add to blacklist" , e);
			return false;
		}
		return true;
	}

	/**
	 * Delete a value(phone number) from the blacklist against certain channel (phone, sms) and brand.
	 *
	 * @param pageContext
	 * @param channel
	 * @param value
	 * @param operator
	 * @param comment
	 * @throws DaoException
	 * @throws ConfigSettingException
	 * @return Success true, otherwise false
	 */
	public static boolean deleteFromBlacklist(HttpServletRequest request, String channel, String value, String operator, String comment) throws DaoException, ConfigSettingException{
		BlacklistDao blacklistDao = new BlacklistDao();
		int styleCodeId = ApplicationService.getBrandFromRequest(request).getId();

		try {
			int outcome = blacklistDao.delete(styleCodeId, BlacklistChannel.findByCode(channel), value);
			if (outcome > 0) {
				writeBlacklistStamp(request, channel, value, "off", operator, comment);
			}else{
				return false;
			}
		} catch (DaoException e) {
			logger.error("Could not delete from blacklist" , e);
			return false;
		}
		return true;
	}

	/**
	 * Internal method to write stamp when successful insert or delete has been done to blacklist table
	 *
	 * @param pageContext
	 * @param channel
	 * @param target
	 * @param operator
	 * @param comment
	 * @throws DaoException
	 * @throws ConfigSettingException
	 */
	private static void writeBlacklistStamp(HttpServletRequest request, String channel, String target, String value, String operator, String comment) throws DaoException, ConfigSettingException{
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
		int styleCodeId = pageSettings.getBrandId();
		String brand = pageSettings.getBrandCode();
		String ipAddress = request.getRemoteAddr();
		String action = BlacklistChannel.findByCode(channel).getAction();
		StampingService stampingService = new StampingService();
		stampingService.writeStamp(styleCodeId, action, brand, "simples", target, value, operator, comment, ipAddress);
	}

}
