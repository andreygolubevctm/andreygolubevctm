package com.ctm.services;

import com.ctm.dao.CommentDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Comment;

public class SimplesService {

	/**
	 * Add a comment to a transaction ID.
	 * @param transactionId
	 * @param operator
	 * @param comment
	 * @return Success true, otherwise false
	 */
	public boolean addComment(long transactionId, String operator, String comment) {
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

}
