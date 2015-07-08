package com.ctm.services.simples;

import com.ctm.dao.BlacklistDao;
import com.ctm.dao.UserDao;
import com.ctm.dao.simples.MessageAuditDao;
import com.ctm.dao.simples.MessageDao;
import com.ctm.dao.simples.MessageDaoOld;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.MessageConfig;
import com.ctm.model.Transaction;
import com.ctm.model.simples.*;
import com.ctm.services.TransactionService;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class SimplesMessageService {
	private static final Logger logger = Logger.getLogger(SimplesMessageService.class.getName());



	public List<Message> postponedMessages(final int userId) throws DaoException {
		final MessageDao messageDao = new MessageDao();
		return messageDao.postponedMessages(userId);
	}

	public MessageDetail getMessage(final HttpServletRequest request, final int messageId) throws DaoException {
		final MessageDao messageDao = new MessageDao();
		final Message message = messageDao.getMessage(messageId);

		if (message.getMessageId() == 0) {
			// No message available
			MessageDetail messageDetail = new MessageDetail();
			messageDetail.setMessage(message);
			return messageDetail;
		}
		else {
			final MessageDetailService messageDetailService = new MessageDetailService();
			return messageDetailService.getMessageDetail(message);
		}
	}


	/**
	 * Get a message from the message queue. The provided User ID may be used to target specific messages, and they will be assigned the message.
	 *
	 * @param userId ID of the user who is getting the message
	 * @throws ParseException
	 */
	public MessageDetail getNextMessageForUser(final HttpServletRequest request, final int userId, final List<Role> userRoles, final List<Rule> getNextMessageRules, final List<MessageConfig> hawkingHours) throws ConfigSettingException, DaoException, ParseException {
		MessageDetail messageDetail = new MessageDetail();
		Message message = null;

		final MessageDao messageDao = new MessageDao();
		final MessageDaoOld messageDaoOld = new MessageDaoOld();
		/* This is only for testing at DEV's machine to generate deadlock
		MessageDaoDeadLock daodd = new MessageDaoDeadLock();
		try {
			daodd.testGetNextMessage(logger);
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		// TODO: remove once new hawking solution is tested in PROD
		if (messageDao.useNewMethodToGetNexMessage()){
			message = MessageDao.getNextMessage(userId, getNextMessageRules);
		}else{
			MessageConfigService messageConfigService = new MessageConfigService();
			Map<String, List<String>> statesMapForHawkingTime = messageConfigService.getStatesMapForHawkingTime(request, hawkingHours);
			message = messageDaoOld.getNextMessage(userId, getNextMessageRules, statesMapForHawkingTime);
		}

		if (message.getMessageId() == 0) {
			// No message available
			messageDetail.setMessage(message);
		}
		else {
			// Build the associated details
			MessageDetailService messageDetailService = new MessageDetailService();
			TransactionService transactionService = new TransactionService();
			messageDetail = messageDetailService.getMessageDetail(message);

			// If message's phone number is in the blacklist, set the message to Complete + Do Not Contact
			int styleCodeId = messageDetail.getTransaction().getStyleCodeId();
			final BlacklistDao blacklistDao = new BlacklistDao();
			if (blacklistDao.isBlacklisted(styleCodeId, BlacklistChannel.PHONE, message.getPhoneNumber1()) ||
				blacklistDao.isBlacklisted(styleCodeId, BlacklistChannel.PHONE, message.getPhoneNumber2())) {

				setMessageToComplete(request, userId, message.getMessageId(), MessageStatus.STATUS_COMPLETED, MessageStatus.STATUS_DONOTCONTACT);

				return getNextMessageForUser(request, userId, userRoles, getNextMessageRules, hawkingHours);
			}

			// If any transaction in the chain is confirmed, set the message to Complete
			ConfirmationOperator confirmationOperator = transactionService.findConfirmationByRootId(message.getTransactionId());
			if (confirmationOperator != null) {
				UserDao userDao = new UserDao();
				User user = userDao.getUser(userId);

				// Decide what status to complete the message
				// based on if the user was the consultant that sold the transaction.
				if (user.getUsername().equals(confirmationOperator.getOperator())) {
					setMessageToComplete(request, userId, message.getMessageId(), MessageStatus.STATUS_COMPLETED, MessageStatus.STATUS_CONVERTEDTOSALE);
				} else {
					setMessageToComplete(request, userId, message.getMessageId(), MessageStatus.STATUS_COMPLETED, MessageStatus.STATUS_ALREADYCUSTOMER);
				}

				return getNextMessageForUser(request, userId, userRoles, getNextMessageRules, hawkingHours);
			}

			// If the message is new or is a different user, assign it to our user.
			// Do as last step in case anything above broke
			if (message.getStatusId() == MessageStatus.STATUS_NEW || message.getUserId() != userId) {
				messageDao.assignMessageToUser(message.getMessageId(), userId);
			}
		}

		return messageDetail;
	}

	/**
	 * Postpone a message
	 * @param actionIsPerformedByUserId User ID
	 * @param messageId
	 * @param statusId: Contains [postpone], [completed as pm], [change time for PM]
	 * @param reasonStatusId Reason status for the postpone
	 * @param postponeDate yyyy-MM-dd
	 * @param postponeTime hh:mm
	 * @param postponeAMPM "AM" or "PM"
	 * @param comment
	 * @param assignToUser
	 * @return
	 */
	public String postponeMessage(int actionIsPerformedByUserId, int messageId, int statusId, int reasonStatusId, String postponeDate, String postponeTime, String postponeAMPM, String comment, boolean assignToUser) {
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {
			boolean unassign = false;
			if (assignToUser == false) unassign = true;

			Date postponeTo = new SimpleDateFormat("yyyy-MM-dd hh:mm a", Locale.ENGLISH).parse(postponeDate + " " + postponeTime + " " + postponeAMPM);

			messageDao.postponeMessage(actionIsPerformedByUserId, messageId, statusId, reasonStatusId, postponeTo, comment, unassign);

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
	public String setMessageToComplete(HttpServletRequest request, int actionIsPerformedByUserId, int messageId, int statusId, int reasonStatusId) throws ConfigSettingException{
		MessageDao messageDao = new MessageDao();
		Transaction details = new Transaction();

		try {

			Message message = messageDao.setMessageToCompleted(actionIsPerformedByUserId, messageId, statusId, reasonStatusId);

			// Check the reasonStatusId, if it equals Do Not Contact, add contact to Blacklist
			if (reasonStatusId == MessageStatus.STATUS_DONOTCONTACT) {

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

	/**
	 * add message audit entry when user confirm and unlock hawking message, Personal message only
	 * @throws DaoException
	 */
	public void addHawkingConfirmationAudit(int messageId) throws DaoException{
		final MessageDao messageDao = new MessageDao();
		final MessageAuditDao messageAuditDao = new MessageAuditDao();
		final Message message = messageDao.getMessage(messageId);

		MessageAudit messageAudit = new MessageAudit();
		messageAudit.setMessageId(messageId);
		messageAudit.setUserId(message.getUserId());
		messageAudit.setStatusId(message.getStatusId());
		messageAudit.setReasonStatusId(MessageStatus.STATUS_HAWKING_UNLOCK);
		messageAudit.setComment("Hawking message confirmed and unlocked by userId '" + message.getUserId());

		messageAuditDao.addMessageAudit(messageAudit);
	}
}
