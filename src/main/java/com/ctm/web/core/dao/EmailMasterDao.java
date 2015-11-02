package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class EmailMasterDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmailMasterDao.class);
	private final SimpleDatabaseConnection dbSource;
	private int brandId;
	private String vertical;
	private String brandCode;

	/**
	 * JSP Beans don't allow params for constructor
	 */
	public EmailMasterDao() {
		this.dbSource = new SimpleDatabaseConnection();
	}

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
					"SELECT emailId, firstName , lastName, emailAddress, hashedEmail " +
					"FROM aggregator.email_master " +
					"WHERE emailAddress = ? " +
					"AND styleCodeId = ?;"
				);

				stmt.setString(1 , email);
				stmt.setInt(2 , brandId);

				ResultSet resultSet = stmt.executeQuery();

				while (resultSet.next()) {
					hashedEmailInfo.setEmailId(resultSet.getInt("emailId"));
					hashedEmailInfo.setFirstName(resultSet.getString("firstName"));
					hashedEmailInfo.setLastName(resultSet.getString("lastName"));
					hashedEmailInfo.setEmailAddress(resultSet.getString("emailAddress"));
					hashedEmailInfo.setHashedEmail(resultSet.getString("hashedEmail"));
				}
				resultSet.close();
			}
		} catch (SQLException | NamingException e) {
			LOGGER.error("failed to get email master {}", kv("email", email), e);
			throw new DaoException(e);
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

	private EmailMaster getEmailMasterFromHashedEmail(String hashedEmail) throws DaoException {
		EmailMaster hashedEmailInfo =  new EmailMaster();
		try {
			hashedEmailInfo.setHashedEmail(hashedEmail);
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
						"SELECT emailId, firstName , lastName, emailAddress " +
						"FROM aggregator.email_master " +
						"WHERE hashedEmail = ? " +
						"AND styleCodeId = ? " +
						"LIMIT 1;"
				);

				stmt.setString(1 , hashedEmail);
				stmt.setInt(2 , brandId);

				ResultSet resultSet = stmt.executeQuery();

				while (resultSet.next()) {
					hashedEmailInfo.setEmailId(resultSet.getInt("emailId"));
					hashedEmailInfo.setFirstName(resultSet.getString("firstName"));
					hashedEmailInfo.setLastName(resultSet.getString("lastName"));
					hashedEmailInfo.setEmailAddress(resultSet.getString("emailAddress"));
				}
			}
		} catch (SQLException | NamingException e) {
			LOGGER.error("failed to get email master {}", kv("hashedEmail", hashedEmail), e);
			throw new DaoException(e);
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
					boolean isOptedIn = optedIn != null && optedIn.equalsIgnoreCase("Y");
					emailDetails.setOptedInMarketing(isOptedIn , vertical);
					emailDetails.setEmailAddress(emailAddress);
				}
			}
		} catch (SQLException | NamingException e) {
			LOGGER.error("failed to get email master with optedIn {}", kv("emailAddress", emailAddress), e);
			throw new DaoException(e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return emailDetails;

	}

	public EmailMaster writeEmailDetails(EmailMaster emailDetails) throws DaoException {
		try {
			// database is set to max 35 chars
			emailDetails.setFirstName(trimTo(emailDetails.getFirstName(), 35));
			emailDetails.setLastName(trimTo(emailDetails.getLastName(), 35));
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
				"INSERT INTO aggregator.email_master " +
				"(styleCodeId, emailAddress, emailPword, brand,vertical,source,firstName,lastName,createDate,transactionId,hashedEmail) " +
				"VALUES (?,?,?,?,?,?,?, ? ,CURRENT_DATE,?,?); ", java.sql.Statement.RETURN_GENERATED_KEYS
				);

				stmt.setInt(1 , brandId);
				stmt.setString(2 , emailDetails.getEmailAddress());
				stmt.setString(3 , emailDetails.getPassword());
				stmt.setString(4 , brandCode);
				stmt.setString(5 , vertical);
				stmt.setString(6 , emailDetails.getSource());
				stmt.setString(7 , emailDetails.getFirstName());
				stmt.setString(8 , emailDetails.getLastName());
				stmt.setLong(9 , emailDetails.getTransactionId());
				stmt.setString(10, emailDetails.getHashedEmail());
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
			LOGGER.error("failed to write email details {}", kv("emailDetails", emailDetails), e);
			throw new DaoException(e);
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
			LOGGER.error("failed to write to email properties for all verticals {}", kv("emailDetails", emailDetails), e);
			throw new DaoException(e);
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
			LOGGER.error("failed to write to email properties {}" , kv("emailDetails", emailDetails), e);
			throw new DaoException(e);
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

	public EmailMaster getEmailMasterById(int emailId) throws DaoException {
		EmailMaster hashedEmailInfo =  new EmailMaster();
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
					"SELECT emailAddress "
					+ "FROM aggregator.email_master "
					+ "WHERE emailId = ? "
					+ "AND styleCodeId = ? "
					+ "LIMIT 1;"
				);

				stmt.setInt(1 , emailId);
				stmt.setInt(2 , brandId);

				ResultSet resultSet = stmt.executeQuery();

				while (resultSet.next()) {
					hashedEmailInfo.setEmailId(emailId);
					hashedEmailInfo.setEmailAddress(resultSet.getString("emailAddress"));
				}
				resultSet.close();
			}
		} catch (SQLException | NamingException e) {
			LOGGER.error("failed to get email details {}" , kv("emailId", emailId), e);
			throw new DaoException(e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return hashedEmailInfo;
	}
	
	public int updatePassword(EmailMaster emailMaster) throws DaoException {
		int result = 0;
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
						"UPDATE aggregator.email_master " +
				" SET emailPword = ? "
				+ "WHERE emailAddress = ? "
				+ "AND styleCodeId = ? ");

				stmt.setString(1 , emailMaster.getPassword());
				stmt.setString(2 , emailMaster.getEmailAddress());
				stmt.setInt(3 , brandId);

				result = stmt.executeUpdate();
			}
		} catch (SQLException | NamingException e) {
			LOGGER.error("failed to update password {}", kv("emailMaster", emailMaster));
			throw new DaoException(e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return result;
	}


	private String trimTo(String value, int characterToTrim) {
		if(value != null && value.length() > characterToTrim){
			value = value.substring(0, characterToTrim);
			LOGGER.warn("email property value too long so trimming {}, {}", kv("characterToTrim", characterToTrim), kv("value", value));
		}
		return value;
	}

}
