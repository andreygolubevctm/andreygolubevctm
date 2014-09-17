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
	private SimpleDatabaseConnection dbSource;
	private int brandId;
	private String vertical;
	private String brandCode;

	public EmailMasterDao() {
		this.dbSource = new SimpleDatabaseConnection();
	};

	public EmailMasterDao(int brandId, String brandCode, String vertical) {
		this.dbSource = new SimpleDatabaseConnection();
		this.brandId = brandId;
		this.vertical = vertical;
		this.brandCode = brandCode;
	}

	public EmailMasterDao(SimpleDatabaseConnection dbSource, String vertical,
			int brandId) {
		this.dbSource = dbSource;
		this.brandId = brandId;
		this.vertical = vertical;
	}

	public EmailDetails decrypt(String hashedEmail, int brandId) throws DaoException {
		EmailDetails hashedEmailInfo =  new EmailDetails();
		try {
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

	public EmailDetails getEmailDetails(String emailAddress) throws DaoException {

		EmailDetails emailDetails = null;
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
				"SELECT em.hashedEmail, ep.value as optedIn " +
				"FROM aggregator.email_master em " +
				"LEFT JOIN aggregator.email_properties ep " +
				"	ON ep.emailId = em.emailId " +
				"		AND ep.vertical = ? " +
				" AND propertyId = 'marketing' " +
				" WHERE em.emailAddress = ? " +
				" AND em.styleCodeId = ? " +
				" GROUP BY emailPword " +
						"LIMIT 1; "
				);

				stmt.setString(1 , vertical);
				stmt.setString(2 , emailAddress);
				stmt.setInt(3 , brandId);

				ResultSet resultSet = stmt.executeQuery();

				if (resultSet.next()) {
					emailDetails= new EmailDetails();
					emailDetails.setHashedEmail(resultSet.getString("hashedEmail"));
					String optedIn = resultSet.getString("optedIn");
					boolean isOptedIn = optedIn == null ? false : optedIn.equalsIgnoreCase("Y");
					emailDetails.setOptedInMarketing(isOptedIn , vertical);
					emailDetails.setEmailAddress(emailAddress);
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
		return emailDetails;

	}

	public EmailDetails writeEmailDetails(EmailDetails emailDetails, String source) throws DaoException {
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
				"INSERT INTO aggregator.email_master " +
				"(styleCodeId,emailAddress,brand,vertical,source,firstName,lastName,createDate,transactionId,hashedEmail) " +
				"VALUES (?,?,?,?,?,?,?,CURRENT_DATE,?,?); "
				);

				stmt.setInt(1 , brandId);
				stmt.setString(2 , emailDetails.getEmailAddress());
				stmt.setString(3 , brandCode);
				stmt.setString(4 , vertical);
				stmt.setString(5 , source);
				stmt.setString(6 , emailDetails.getFirstName());
				stmt.setString(7 , emailDetails.getLastName());
				stmt.setLong(8 , emailDetails.getTransactionId());
				stmt.setString(9 , emailDetails.getHashedEmail());

				stmt.executeUpdate();
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
		return emailDetails;
	}

}
