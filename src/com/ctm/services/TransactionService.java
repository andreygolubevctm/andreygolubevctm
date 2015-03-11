package com.ctm.services;

import com.ctm.dao.simples.MessageAuditDao;
import com.ctm.dao.simples.MessageDao;
import com.ctm.model.simples.ConfirmationOperator;
import com.ctm.model.simples.Message;
import org.apache.log4j.Logger;

import com.ctm.dao.CommentDao;
import com.ctm.dao.TouchDao;
import com.ctm.dao.TransactionDao;
import com.ctm.dao.health.HealthTransactionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.TransactionProperties;
import com.ctm.model.health.HealthTransaction;

public class TransactionService {

	@SuppressWarnings("unused")
	private static final Logger logger = Logger.getLogger(TransactionService.class.getName());

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
			final HealthTransactionDao transactionHealthDao = new HealthTransactionDao();
			transactionHealthDao.getHealthDetails(details);

			final CommentDao commentDao = new CommentDao();
			details.setComments( commentDao.getCommentsForTransactionId(transactionId) );

			final TouchDao touchDao = new TouchDao();
			details.setTouches( touchDao.getTouchesForTransactionId(transactionId) );

			final MessageDao messageDao = new MessageDao();
			final Message message = messageDao.getMessageByTransactionId(transactionId);
			if (message != null) {
				final MessageAuditDao messageAuditDao = new MessageAuditDao();
				details.setAudits(messageAuditDao.getMessageAudits(message.getMessageId()));
			}
		}
		catch (DaoException e) {
			Error error = new Error(e.getMessage());
			details.addError(error);
		}

		return details;
	}

	/**
	 * HEALTH CALL CENTRE SPECIFIC LOGIC, need to be moved to somewhere else
	 * @throws DaoException
	 */
	public String getHawkingOptinForTransaction(final long transactionId) throws DaoException {
		final HealthTransactionDao transactionHealthDao = new HealthTransactionDao();
		return transactionHealthDao.getHawkingOptinForTransaction(transactionId);
	}


	/**
	 * Find if any transaction chained from the provided Root ID is confirmed (sold).
	 * @param rootId
	 * @return Not null if confirmed
	 */
	public ConfirmationOperator findConfirmationByRootId(long rootId) throws DaoException {
		TransactionDao transactionDao = new TransactionDao();
		return transactionDao.getConfirmationFromTransactionChain(rootId);
	}

}
