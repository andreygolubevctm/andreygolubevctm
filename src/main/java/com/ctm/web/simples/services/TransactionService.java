package com.ctm.web.simples.services;

import com.ctm.web.core.dao.CommentDao;
import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Error;
import com.ctm.web.core.model.TransactionProperties;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.Transaction;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.health.dao.HealthTransactionDao;
import com.ctm.web.health.model.HealthTransaction;
import com.ctm.web.simples.dao.MessageAuditDao;
import com.ctm.web.simples.dao.MessageDao;
import com.ctm.web.simples.model.ConfirmationOperator;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.model.MessageDetail;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class TransactionService {

	private static final Logger LOGGER = LoggerFactory.getLogger(TransactionService.class);

	/**
	 * Get all comments for a transaction ID and related (based on root ID).
	 *
	 * @param transactionId
	 * @return JSON string
	 */
	public static String getCommentsForTransactionId(long transactionId) {
		TransactionProperties details = new TransactionProperties();
		details.setTransactionId(transactionId);

		try {
			CommentDao comments = new CommentDao();
			details.setComments( comments.getCommentsForTransactionId(transactionId) );
		}
		catch (DaoException e) {
			Error error = new Error();
			error.setMessage(e.getMessage());
			details.addError(error);
		}

		return details.toJson();
	}

	/**
	 *
	 */
	public static HealthTransaction getMoreDetailsOfTransaction(final long transactionId) {

		// TODO: This would be extended to support other verticals, to collect vertical-specific details
		// Would have to retrieve the vertical of the transaction first probably.

		HealthTransaction details = new HealthTransaction();
		details.setTransactionId(transactionId);

		try {
			TransactionDao transactionDao = new TransactionDao();
			long rootId = transactionDao.getRootIdOfTransactionId(transactionId);

			final HealthTransactionDao transactionHealthDao = new HealthTransactionDao();
			transactionHealthDao.getHealthDetails(details);

			final CommentDao commentDao = new CommentDao();
			details.setComments( commentDao.getCommentsForRootId(rootId) );

			final TouchDao touchDao = new TouchDao();
			details.setTouches( touchDao.getTouchesForRootId(rootId));

			final MessageDao messageDao = new MessageDao();
			final Message message = messageDao.getMessageByRootId(rootId);

			if (message != null) {
				final MessageAuditDao messageAuditDao = new MessageAuditDao();
				details.setAudits(messageAuditDao.getMessageAudits(message.getMessageId()));
			}
		}
		catch (DaoException e) {
			LOGGER.error("Error getting transaction details {}", kv("transactionId", transactionId), e);
			Error error = new Error(e.getMessage());
			details.addError(error);
		}

		return details;
	}

	public static void writeAllowableErrors(Long transactionId, String allowedErrors) throws DaoException {
		if (StringUtils.isNotBlank(allowedErrors)) {
			try {
				final HealthTransactionDao transactionHealthDao = new HealthTransactionDao();
				transactionHealthDao.writeAllowableErrors(transactionId, allowedErrors);
			} catch (DaoException e) {
				LOGGER.warn("Exception thrown writing allowable errors. {}", kv("allowedErrors", allowedErrors), e);
			}
		}
	}

	public static void writeTransactionDetail(final Long transactionId,
											final HealthTransactionDao.HealthTransactionSequenceNoEnum transactionSeqNo,
											final String value) throws DaoException {
		if (StringUtils.isNotBlank(value)) {
			try {
				final HealthTransactionDao transactionHealthDao = new HealthTransactionDao();
				transactionHealthDao.writeTransactionDetail(transactionId, transactionSeqNo, value);
			} catch (DaoException e) {
				LOGGER.warn("Exception thrown writing transaction detail.", e);
			}
		}
	}

	/**
	 * Find if any transaction chained from the provided Root ID is confirmed (sold).
	 * @param rootIds
	 * @return Not null if confirmed
	 */
	public ConfirmationOperator findConfirmationByRootId(List<Long> rootIds) throws DaoException {
		TransactionDao transactionDao = new TransactionDao();
		return transactionDao.getConfirmationFromTransactionChain(rootIds);
	}

	/**
	 * Used by Simples with InIn integration, to look up tranId and make a 'fake' message.
	 */
	public static MessageDetail getTransaction(final long transactionId) throws DaoException {
		final TransactionDao transactionDao = new TransactionDao();
		final TransactionDetailsDao transactionDetailsDao = new TransactionDetailsDao();
		final MessageDetailService detailService = new MessageDetailService();
		Message message = getTransactionMessage(transactionId, transactionDao, transactionDetailsDao);
		return detailService.getMessageDetail(message);
	}

	protected static Message getTransactionMessage(final long transactionId, final TransactionDao transactionDao,
												   final TransactionDetailsDao transactionDetailsDao) throws DaoException {
		final Transaction transaction = new Transaction();
		final Message message = new Message();
		final long rootId = transactionDao.getRootIdOfTransactionId(transactionId);

		transaction.setTransactionId(transactionId);
		transactionDao.getCoreInformation(transaction);

		message.setTransactionId(rootId);
		message.setMessageId(-1);
		message.setCanPostpone(true); // So that we can hook into the InIn services

		Map<String, String> transactionDetails = transactionDetailsDao.getTransactionDetails(transaction.getNewestTransactionId(), null)
				.stream()
				.collect(Collectors.toMap(TransactionDetail::getXPath, TransactionDetail::getTextValue));

		final Optional<String> state = Optional.ofNullable(transactionDetails.get("health/situation/state"));
		message.setState(state.orElse(""));

		final Optional<String> primaryFirstName = Optional.ofNullable(transactionDetails.get("health/application/primary/firstname"));
		final Optional<String> primaryLastName = Optional.ofNullable(transactionDetails.get("health/application/primary/surname"));
		if(primaryFirstName.isPresent() || primaryLastName.isPresent()) {
			message.setContactName(StringUtils.trim(primaryFirstName.orElse("BLANK") + " " + primaryLastName.orElse("BLANK")));
		} else {
			Optional<String> contactName = Optional.ofNullable(transactionDetails.get("health/contactDetails/name"));
			message.setContactName(contactName.orElse("BLANK"));
		}

		final Optional<String> phoneNumber1 = Optional.ofNullable(transactionDetails.get("health/application/mobile"));
		if(phoneNumber1.isPresent()) {
			message.setPhoneNumber1(phoneNumber1.orElse(""));
		} else {
			message.setPhoneNumber1(Optional.ofNullable(transactionDetails.get("health/contactDetails/contactNumber/mobile")).orElse(""));
		}

		final Optional<String> phoneNumber2 = Optional.ofNullable(transactionDetails.get("health/application/other"));
		if(phoneNumber2.isPresent()) {
			message.setPhoneNumber2(phoneNumber2.orElse(""));
		} else {
			message.setPhoneNumber2(Optional.ofNullable(transactionDetails.get("health/contactDetails/contactNumber/other")).orElse(""));
		}

		return message;
	}

	/**
	 * transactionIdExists calls the DAO to confirm the transactionId exists in the database.
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 */
	public boolean transactionIdExists(long transactionId) throws DaoException {
	    final TransactionDao transactionDao = new TransactionDao();
		return transactionDao.transactionIdExists(transactionId);
	}
}