package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.FormValidationLog;

/**
 * Data Access Object to interface with the form_validation table.
 * @author bthompson
 */
public class FormValidationDao {

	/**
	 * Constructor
	 */
	public FormValidationDao() {
	}

	/**
	 *
	 * @param formValidation
	 * @param transactionId
	 * @throws DaoException
	 */
	public void addValidationLog(FormValidationLog formValidation, long transactionId) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		try {
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();

			if(conn != null) {
				stmt = conn.prepareStatement(
						"INSERT INTO ctm.form_validation " +
						"(transactionId, xpath, validationMessage, textValue, stepId, logDateTime) " +
						"VALUES " +
						"(?,?,?,?,?,NOW());"
				);

				stmt.setLong(1, transactionId);
				stmt.setString(2, formValidation.getXPath());
				stmt.setString(3, formValidation.getValidationMessage());
				stmt.setString(4, formValidation.getTextValue());
				stmt.setString(5, formValidation.getStepId());
				stmt.executeUpdate();
			}
		} catch (SQLException e) {
			throw new DaoException(e);
		} catch (NamingException e) {
			throw new DaoException(e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
	}

}
