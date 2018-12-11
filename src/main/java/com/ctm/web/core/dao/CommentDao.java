package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Comment;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CommentDao {

	/**
	 * Add a comment to a transaction. It will be associated with the root ID.
	 * @param comment Comment to add
	 */
	public Comment addComment(Comment comment) throws DaoException {

		TransactionDao transactionDao = new TransactionDao();
		long rootId = transactionDao.getRootIdOfTransactionId(comment.getTransactionId());

		if (comment.getComment().length() == 0) {
			throw new DaoException("Comment length must be greater than zero.");
		}

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"INSERT INTO ctm.quote_comments (transactionId, operatorId, comment, createDate, createTime)" +
				"VALUES (?, ?, ?, CURRENT_DATE, CURRENT_TIME)"
				, java.sql.Statement.RETURN_GENERATED_KEYS
			);
			stmt.setLong(1, rootId);
			stmt.setString(2, comment.getOperator());
			stmt.setString(3, cleanTextContent(comment.getComment()));
			stmt.executeUpdate();

			// Update the comment model with the insert ID
			ResultSet rs = stmt.getGeneratedKeys();
			if (rs != null && rs.next()) {
				comment.setId(rs.getInt(1));
			}
			stmt.close();
		}
		catch (SQLException e) {
			throw new DaoException(e);
		}
		catch (NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return comment;
	}

	/**
	 * Get all the comments connected with a transaction ID, based on its root ID.
	 * @param transactionId
	 */
	public ArrayList<Comment> getCommentsForTransactionId(long transactionId) throws DaoException {

		TransactionDao transactionDao = new TransactionDao();
		long rootId = transactionDao.getRootIdOfTransactionId(transactionId);

		return getCommentsForRootId(rootId);
	}

	/**
	 * Get all the comments for transactions with the provided root ID.
	 * @param rootId
	 */
	public ArrayList<Comment> getCommentsForRootId(long rootId) throws DaoException {

		SimpleDatabaseConnection dbSource =  new SimpleDatabaseConnection();
		ArrayList<Comment> comments = new ArrayList<>();

		try {
			PreparedStatement stmt;

			//
			// Get the comments
			//

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT commId, transactionId, operatorId, comment, CONCAT(createDate, ' ', createTime) as dateTime " +
				"FROM ctm.quote_comments " +
				"WHERE transactionId = ? " +
				"ORDER BY commId DESC"
			);
			stmt.setLong(1, rootId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				Comment comment = new Comment();
				comment.setId(results.getInt("commId"));
				comment.setTransactionId(results.getLong("transactionId"));
				comment.setOperator(results.getString("operatorId"));
				comment.setComment(results.getString("comment"));
				comment.setDatetime(results.getTimestamp("dateTime"));
				comments.add(comment);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return comments;
	}

	/**
	 * Strip out invalid characters from string to avoid database and rendering issues
	 * 
	 * @param text
	 * @return
	 */
	private String cleanTextContent(String text) {
		// strips off all non-ASCII characters
		text = text.replaceAll("[^\\x00-\\x7F]", "");

		// erases all the ASCII control characters
		text = text.replaceAll("[\\p{Cntrl}&&[^\r\n\t]]", "");

		// removes non-printable characters from Unicode
		text = text.replaceAll("\\p{C}", "");

		return text.trim();
	}

}
