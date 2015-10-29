package com.ctm.services;

import com.ctm.web.core.dao.CommentDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Comment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.logging.LoggingArguments.kv;

public class SimplesService {
	private static final Logger LOGGER = LoggerFactory.getLogger(SimplesService.class);

	/**
	 * Add a comment to a transaction ID.
	 * @param transactionId
	 * @param operator
	 * @param comment
	 * @return Success true, otherwise false
	 */
	public boolean addComment(long transactionId, String operator, String comment) {
		if (operator == null || operator.isEmpty()) {
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
			LOGGER.error("Failed to add comment to transactionId {},{},{}", kv("transactionId", transactionId),
				kv("operator", operator), kv("comment", comment));
			return false;
		}

		return true;
	}

}
