package com.ctm.services;

import com.ctm.dao.CommentDao;
import com.ctm.dao.TouchDao;
import com.ctm.dao.health.HealthTransactionDao;
import com.ctm.dao.simples.MessageAuditDao;
import com.ctm.dao.simples.MessageDao;
import com.ctm.dao.transaction.TransactionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.TransactionProperties;
import com.ctm.model.health.HealthTransaction;
import com.ctm.model.simples.ConfirmationOperator;
import com.ctm.model.simples.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class TransactionService {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(TransactionService.class.getName());

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
			logger.error("", e);
			Error error = new Error(e.getMessage());
			details.addError(error);
		}

		return details;
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

}