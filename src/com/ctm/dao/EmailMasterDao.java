package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailMaster;

public class EmailMasterDao {

	private static Logger logger = Logger.getLogger(EmailMasterDao.class.getName());
	private SimpleDatabaseConnection dbSource;
	private int brandId;
	private String vertical;
	private String brandCode;

	/**
	 * JSP Beans don't allow params for constructor
	 */
	public EmailMasterDao() {
		this.dbSource = new SimpleDatabaseConnection();
	};

	public EmailMasterDao(int brandId, String brandCode, String vertical) {
		this.dbSource = new SimpleDatabaseConnection();
		this.brandId = brandId;
		this.vertical = vertical;
		this.brandCode = brandCode;
	}

	public EmailMasterDao(int brandId) {
		this.dbSource = new SimpleDatabaseConnection();
		this.brandId = brandId;
	}

	public EmailMasterDao(SimpleDatabaseConnection dbSource, String vertical,
			int brandId) {
		this.dbSource = dbSource;
		this.brandId = brandId;
		this.vertical = vertical;
	}
	
	public EmailMaster getEmailMaster(String email, int brandId) throws DaoException {
		this.brandId = brandId;
		return getEmailMaster(email);
	}

	public EmailMaster getEmailMaster(String email) throws DaoException {
		EmailMaster hashedEmailInfo =  new EmailMaster();
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
					"SELECT emailid, firstName , lastName, emailAddress, hashedEmail " +
					"FROM aggregator.email_master " +
					"WHERE emailAddress = ? " +
					"AND styleCodeId = ?;"
				);

				stmt.setString(1 , email);
				stmt.setInt(2 , brandId);

				ResultSet resultSet = stmt.executeQuery();

				while (resultSet.next()) {
					hashedEmailInfo.setEmailId(resultSet.getInt("emailid"));
					hashedEmailInfo.setFirstName(resultSet.getString("firstName"));
					hashedEmailInfo.setLastName(resultSet.getString("lastName"));
					hashedEmailInfo.setEmailAddress(resultSet.getString("emailAddress"));
					hashedEmailInfo.setHashedEmail(resultSet.getString("hashedEmail"));
				}
				resultSet.close();
			}
		} catch (SQLException | NamingException e) {
			logger.error("failed to get email details" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return hashedEmailInfo;
	}

	public EmailMaster getEmailMasterFromHashedEmail(String hashedEmail, int brandId) throws DaoException {
		this.brandId = brandId;
		return getEmailMasterFromHashedEmail(hashedEmail);
	}

	public EmailMaster getEmailMasterFromHashedEmail(String hashedEmail) throws DaoException {
		EmailMaster hashedEmailInfo =  new EmailMaster();
		try {
			hashedEmailInfo.setHashedEmail(hashedEmail);
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
				}
			}
		} catch (SQLException | NamingException e) {
			logger.error("failed to get email details" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return hashedEmailInfo;
	}

	public EmailMaster getEmailDetails(String emailAddress) throws DaoException {

		EmailMaster emailDetails = null;
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
					emailDetails= new EmailMaster();
					emailDetails.setHashedEmail(resultSet.getString("hashedEmail"));
					String optedIn = resultSet.getString("optedIn");
					boolean isOptedIn = optedIn == null ? false : optedIn.equalsIgnoreCase("Y");
					emailDetails.setOptedInMarketing(isOptedIn , vertical);
					emailDetails.setEmailAddress(emailAddress);
				}
			}
		} catch (SQLException | NamingException e) {
			logger.error("failed to get email details" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return emailDetails;

	}

	public EmailMaster writeEmailDetails(EmailMaster emailDetails) throws DaoException {
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
				"INSERT INTO aggregator.email_master " +
				"(styleCodeId,emailAddress,brand,vertical,source,firstName,lastName,createDate,transactionId,hashedEmail) " +
				"VALUES (?,?,?,?,?,?,?,CURRENT_DATE,?,?); ", java.sql.Statement.RETURN_GENERATED_KEYS
				);

				stmt.setInt(1 , brandId);
				stmt.setString(2 , emailDetails.getEmailAddress());
				stmt.setString(3 , brandCode);
				stmt.setString(4 , vertical);
				stmt.setString(5 , emailDetails.getSource());
				stmt.setString(6 , emailDetails.getFirstName());
				stmt.setString(7 , emailDetails.getLastName());
				stmt.setLong(8 , emailDetails.getTransactionId());
				stmt.setString(9 , emailDetails.getHashedEmail());
				stmt.executeUpdate();

				// Update the emailDetails model with the insert ID
				ResultSet rs = stmt.getGeneratedKeys();
				if (rs != null && rs.next()) {
					emailDetails.setEmailId(rs.getInt(1));
				}
				stmt.close();

				if(vertical != null && !vertical.isEmpty()){
					writeToEmailProperties(emailDetails, conn);
			}
			}
		} catch (SQLException | NamingException e) {
			logger.error("failed to get email details" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return emailDetails;
	}

	public void writeToEmailPropertiesAllVerticals(EmailMaster emailDetails) throws DaoException  {
		int count = 0;
		PreparedStatement stmt;
		try {
			Connection conn = dbSource.getConnection();
			stmt = conn.prepareStatement(
					"SELECT count(emailId) as propertiesCount " +
					"FROM aggregator.email_properties ep " +
					"WHERE ep.emailId = ? " +
					"AND brand=? ;"
			);

			stmt.setInt(1 , emailDetails.getEmailId());
			stmt.setInt(2 , brandId);

			ResultSet resultSet = stmt.executeQuery();

			if (resultSet.next()) {
				count = (resultSet.getInt("propertiesCount"));
			}

			stmt.close();
			if(count > 0){
				stmt = conn.prepareStatement(
					"UPDATE aggregator.email_properties " +
					"SET value=? " +
					"WHERE emailId=? "+
					"AND propertyId=? "+
					"AND brand=?; "
				);
				stmt.setString(1 , emailDetails.getOptedInMarketing(vertical) ? "Y" : "N");
				stmt.setInt(2 , emailDetails.getEmailId());
				stmt.setString(3 , "marketing");
				stmt.setString(4 , brandCode);
				stmt.executeUpdate();
				stmt.close();
			} else {
				writeToEmailProperties(emailDetails, conn);
			}
		} catch (NamingException | SQLException e) {
			logger.error("failed to write to email properties" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
	}

	public void writeToEmailProperties(EmailMaster emailDetails) throws DaoException  {
		try {
			Connection conn = dbSource.getConnection();
			writeToEmailProperties(emailDetails, conn);
		} catch (NamingException | SQLException e) {
			logger.error("failed to write to email properties" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
	}

	private void writeToEmailProperties(EmailMaster emailDetails , Connection conn ) throws SQLException  {
		PreparedStatement stmt = conn.prepareStatement("INSERT INTO aggregator.email_properties " +
					"(emailId,emailAddress,propertyId,brand,vertical,value)" +
					" VALUES (?,?,?,?,?,?) ON DUPLICATE KEY UPDATE " +
					"value = ?; "
					);
		stmt.setInt(1 , emailDetails.getEmailId());
		stmt.setString(2 , emailDetails.getEmailAddress());
		stmt.setString(3 , "marketing");
		stmt.setString(4 , brandCode);
		stmt.setString(5 , vertical);
		stmt.setString(6 , emailDetails.getOptedInMarketing(vertical) ? "Y" : "N");
		stmt.setString(7 , emailDetails.getOptedInMarketing(vertical) ? "Y" : "N");
		stmt.executeUpdate();
		stmt.close();
	}

}
