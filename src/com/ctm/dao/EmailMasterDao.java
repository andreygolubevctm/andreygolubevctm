package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailDetails;

public class EmailMasterDao {

	private static Logger logger = Logger.getLogger(EmailMasterDao.class.getName());

	public EmailDetails decrypt(String hashedEmail, int brandId) throws DaoException {
		EmailDetails hashedEmailInfo =  new EmailDetails();
		SimpleDatabaseConnection dbSource = null;
		try {
			dbSource = new SimpleDatabaseConnection();
			hashedEmailInfo.setHashedEmail(hashedEmail);
			hashedEmailInfo.setValid(false);
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
						"SELECT emailid, firstName , lastName, emailAddress " +
						"FROM aggregator.email_master " +
						"WHERE hashedEmail = ? " +
						"AND styleCodeId = ? " +
						"LIMIT 1;"
				);

				stmt.setString(1 , hashedEmail);
				stmt.setInt(2 , brandId);

				ResultSet resultSet = stmt.executeQuery();

				while (resultSet.next()) {
					hashedEmailInfo.setEmailId(resultSet.getInt("emailid"));
					hashedEmailInfo.setFirstName(resultSet.getString("firstName"));
					hashedEmailInfo.setLastName(resultSet.getString("lastName"));
					hashedEmailInfo.setEmailAddress(resultSet.getString("emailAddress"));
					hashedEmailInfo.setValid(true);
				}
			}
		} catch (SQLException e) {
			logger.error("failed to get email details" , e);
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			logger.error("failed to get email details" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return hashedEmailInfo;
	}

}
