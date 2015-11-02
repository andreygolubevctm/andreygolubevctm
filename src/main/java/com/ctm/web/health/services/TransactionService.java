package com.ctm.web.health.services;

import com.ctm.web.core.dao.CommentDao;
import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Error;
import com.ctm.web.core.model.TransactionProperties;
import com.ctm.web.health.dao.HealthTransactionDao;
import com.ctm.web.health.model.HealthTransaction;
import com.ctm.web.simples.dao.MessageAuditDao;
import com.ctm.web.simples.dao.MessageDao;
import com.ctm.web.simples.model.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.web.core.logging.LoggingArguments.kv;

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

}