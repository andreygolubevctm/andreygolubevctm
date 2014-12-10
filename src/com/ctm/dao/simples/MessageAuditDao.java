package com.ctm.dao.simples;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.simples.MessageAudit;

public class MessageAuditDao {

	/**
	 *
	 */
	protected MessageAudit addMessageAudit(MessageAudit messageAudit) throws DaoException {

		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"INSERT INTO simples.message_audit (messageId, userId, created, statusId, reasonStatusId, comment)" +
				"VALUES (?, ?, NOW(), ?, ?, ?);"
				, java.sql.Statement.RETURN_GENERATED_KEYS
			);
			stmt.setInt(1, messageAudit.getMessageId());
			stmt.setInt(2, messageAudit.getUserId());
			stmt.setInt(3, messageAudit.getStatusId());
			stmt.setInt(4, messageAudit.getReasonStatusId());
			stmt.setString(5, messageAudit.getComment());
			stmt.executeUpdate();

			ResultSet rs = stmt.getGeneratedKeys();
			if (rs != null && rs.next()) {
				messageAudit.setId(rs.getInt(1));
			}
			stmt.close();
		}
		catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		}
		catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return messageAudit;
	}

	/**
	 * Get all message audits for a message.
	 *
	 * @param messageId
	 * @return List of message audits
	 */
	public ArrayList<MessageAudit> getMessageAudits(int messageId) throws DaoException {
		ArrayList<MessageAudit> list = new ArrayList<MessageAudit>();
		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT audit.id, audit.messageId, audit.userId, audit.created, audit.statusId, audit.reasonStatusId, audit.comment, stat.status, stat2.status AS reasonStatus, user.ldapuid " +
				"FROM simples.message_audit audit " +
				"LEFT JOIN simples.message_status stat ON audit.statusId = stat.id " +
				"LEFT JOIN simples.message_status stat2 ON audit.reasonStatusId = stat2.id " +
				"LEFT JOIN simples.user ON audit.userId = user.id " +
				"WHERE messageId = ? ORDER BY id DESC;"
			);
			stmt.setInt(1, messageId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				MessageAudit audit = new MessageAudit();
				audit.setId(results.getInt("id"));
				audit.setMessageId(results.getInt("messageId"));
				audit.setUserId(results.getInt("userId"));
				audit.setOperator(results.getString("ldapuid"));
				audit.setCreated(results.getTimestamp("created"));
				audit.setStatusId(results.getInt("statusId"));
				audit.setStatus(results.getString("status"));
				audit.setReasonStatusId(results.getInt("reasonStatusId"));
				audit.setReasonStatus(results.getString("reasonStatus"));
				audit.setComment(results.getString("comment"));
				list.add(audit);
			}

			stmt.close();
		}
		catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		}
		catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return list;
	}
}
