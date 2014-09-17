package com.ctm.services;

import org.apache.log4j.Logger;

import com.ctm.dao.CommentDao;
import com.ctm.dao.TouchDao;
import com.ctm.dao.health.HealthTransactionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.TransactionProperties;
import com.ctm.model.health.HealthTransaction;

public class TransactionService {

	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger(TransactionService.class.getName());

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
	public static HealthTransaction getMoreDetailsOfTransaction(long transactionId) {

		// TODO: This would be extended to support other verticals, to collect vertical-specific details
		// Would have to retrieve the vertical of the transaction first probably.

		HealthTransaction details = new HealthTransaction();
		details.setTransactionId(transactionId);

		try {
			//TransactionDao transactionDao = new TransactionDao();
			//transactionDao.getCoreInformation(details);

			HealthTransactionDao transactionHealthDao = new HealthTransactionDao();
			transactionHealthDao.getHealthDetails(details);

			CommentDao commentDao = new CommentDao();
			details.setComments( commentDao.getCommentsForTransactionId(transactionId) );

			TouchDao touchDao = new TouchDao();
			details.setTouches( touchDao.getTouchesForTransactionId(transactionId) );
		}
		catch (DaoException e) {
			Error error = new Error();
			error.setMessage(e.getMessage());
			details.addError(error);
		}

		return details;
	}


}
