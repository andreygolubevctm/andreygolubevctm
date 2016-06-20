package com.ctm.web.core.transaction.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.constants.PrivacyBlacklist;
import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.dao.SqlDaoFactory;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.model.TransactionDetail;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.transaction.utils.TransactionDetailsUtil.checkLengthTextValue;

/**
 * Data Access Object to interface with the transaction_details table.
 * @author bthompson
 */
@Repository
public class TransactionDetailsDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(TransactionDetailsDao.class);

    private final NamedParameterJdbcTemplate jdbcTemplate;

	private final SqlDaoFactory sqlDaoFactory;

    /**
	 * Constructor
	 */
	@Deprecated
	public TransactionDetailsDao() {
		sqlDaoFactory = new SqlDaoFactory(SimpleDatabaseConnection.getInstance());
		jdbcTemplate = new NamedParameterJdbcTemplate(SimpleDatabaseConnection.getDataSourceJdbcCtm());
	}

	public static final String DESCRIPTION = "infoDes";


	@Autowired
	@SuppressWarnings("SpringJavaAutowiringInspection")
	public TransactionDetailsDao(final NamedParameterJdbcTemplate jdbcTemplate, SqlDaoFactory sqlDaoFactory) {
        this.sqlDaoFactory = sqlDaoFactory;
		this.jdbcTemplate = jdbcTemplate;
	}

    /**
     * Handles all the parameters. Determines whether to insert a new transaction detail or update the existing one.
     * @param request HttpServletRequest
     * @param transactionId Long
     * @return
     */
	public Boolean insertOrUpdate(HttpServletRequest request, long transactionId) {

		/**
		 * Retrieve the parameter names as an Enumerated array of strings to iterate over.
		 */
		Enumeration<String> parameterNames = request.getParameterNames();

		boolean hasCheckedPrivacyOptin = (request.getParameter("hasPrivacyOptin") != null && request.getParameter("hasPrivacyOptin").equals("true"));

		/**
		 * For each parameter passed in, check if it exists in transaction details
		 * If it does: update it
		 * If it doesn't: get the max sequence number and insert it seqNo +=1
		 */
		while (parameterNames.hasMoreElements()) {

			/**
			 * Get the current parameter name.
			 * If it is not a detail stored in transaction details (e.g. tranid), continue.
			 */
			String paramName = parameterNames.nextElement();
			if(paramName.equals("transactionId")) {
				continue;
			}
			/**
			 * Convert from a parameter to an XPath.
			 */
			String xpath = paramName.replace("_", "/");
			if(xpath.length() > 127) {
				xpath = xpath.substring(0,127);
			}
			/**
			 * Do not send if blacklisted.
			 */
			if(isBlacklisted(xpath)) {
				continue;
			}

			String paramValue = request.getParameter(paramName).trim();

			if(paramValue.length() > 999) {
				paramValue = paramValue.substring(0,999);
			}
			paramValue = sanitizeInput(xpath, paramValue);

			if(!hasCheckedPrivacyOptin) {
				paramValue = maskPrivateFields(xpath, paramValue);
			}

			try {
				TransactionDetail transactionDetail = getTransactionDetailByXpath(transactionId, xpath);
				TransactionDetail transactionDetailNew = new TransactionDetail();
				transactionDetailNew.setXPath(xpath);
				transactionDetailNew.setTextValue(paramValue);
				if(transactionDetail == null) {
					addTransactionDetails(transactionId, transactionDetailNew);
				} else {
					updateTransactionDetails(transactionId, transactionDetailNew);
				}
			} catch (DaoException e) {
				LOGGER.error("Transaction details insert or update failed {}, {}", kv("parameterMap", request.getParameterMap()), kv("transactionId", transactionId), e);
			}
		}
		return true;
	}

	/**
	 * Mask private data fields.
	 * @param xpath
	 * @param paramValue
	 * @return String paramValue masked or not masked.
	 */
	private String maskPrivateFields(String xpath, String paramValue) {
		if(isPersonallyIdentifiableInfo(xpath)) {
			// if masking:
			//return paramValue.replaceAll("\\w",  "*");
			return "";
		}
		return paramValue;
	}
	/**
	 * Blacklist of xpaths to NEVER store in transaction details
	 * @param xpath
	 * @return true if is blacklisted
	 */
	public static boolean isPersonallyIdentifiableInfo(String xpath) {
		for(String xpathToCheck : PrivacyBlacklist.PERSONALLY_IDENTIFIABLE_INFORMATION_BLACKLIST) {
			if(xpath.contains(xpathToCheck)) {
				return true;
			}
		}
		return false;
	}
	/**
	 * Blacklist of xpaths to NEVER store in transaction details
	 * @param xpath
	 * @return true if is blacklisted
	 */
	public static boolean isBlacklisted(String xpath) {
		for(String xpathToCheck : PrivacyBlacklist.COMPLIANCE_BLACKLIST) {
			if(xpath.contains(xpathToCheck)) {
				return true;
			}
		}
		return false;
	}
	/**
	 * Basic sanitisation of URLs and HTML on name fields, ported from sanitiseInput.xsl
	 * @param xpath
	 * @param textValue
	 * @return returns sanitised input if in list of fields to sanitise.
	 */
	private String sanitizeInput(String xpath, String textValue) {

		String[] fieldNames = xpath.split("/");
		String fieldName = fieldNames[fieldNames.length-1];
		if( fieldName.equalsIgnoreCase("name") || fieldName.equalsIgnoreCase("surname")
				|| fieldName.equalsIgnoreCase("firstname") || fieldName.equalsIgnoreCase("lastname") ) {
			return textValue.replaceAll("(\\<|\\>|&gt;|&lt;|://|www\\.|\\.com|@|\\.co|\\.net|\\.org|\\.asn|\\.ws|\\.us|\\.mobi)", "");
		}
		return textValue;
	}

	/**
	 * Update a single transaction detail  based on its xpath and transaction id
	 * @param transactionId
	 * @param transactionDetail
	 * @return
	 * @throws DaoException
	 */
	private ArrayList<TransactionDetail> updateTransactionDetails(long transactionId, TransactionDetail transactionDetail) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<TransactionDetail> transactionDetails = new ArrayList<TransactionDetail>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
					" UPDATE aggregator.transaction_details " +
					" SET textValue = ?, " +
					"	 dateValue = CURDATE() " +
					" WHERE transactionId = ?" +
					"	 AND xpath = ?" +
					" LIMIT 1;"
			);
			stmt.setString(1, transactionDetail.getTextValue());
			stmt.setLong(2, transactionId);
			stmt.setString(3, transactionDetail.getXPath());
			stmt.executeUpdate();

		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return transactionDetails;

	}

	/**
	 * Retrieve a transaction detail based on the xpath and transaction id.
	 * @param transactionId
	 * @param xpath
	 * @return
	 * @throws DaoException
	 */
	public TransactionDetail getTransactionDetailByXpath(long transactionId, String xpath) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		TransactionDetail transactionDetail = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT xpath, textValue"
					+ " FROM aggregator.transaction_details"
					+ " WHERE transactionId = ?"
					+ "     AND xpath = ?"
			);
			stmt.setLong(1, transactionId);
			stmt.setString(2, xpath);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				transactionDetail = new TransactionDetail();
				transactionDetail.setXPath(results.getString("xpath"));
				transactionDetail.setTextValue(results.getString("textValue"));
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return transactionDetail;
	}

	/**
	 * Retrieve a transaction detail based on the xpath and transaction id.
	 * @param transactionId
	 * @param xpath
	 * @return
	 * @throws DaoException
	 */
	public Optional<TransactionDetail> getTransactionDetailWhereXpathLike(long transactionId, String xpath) {


		final MapSqlParameterSource map = new MapSqlParameterSource()
				.addValue("transactionId", transactionId).addValue("xpath", xpath);
		final String sql = "SELECT xpath, textValue"
				+ " FROM aggregator.transaction_details"
				+ " WHERE transactionId = (:transactionId)"
				+ " AND xpath like (:xpath) "
				+ " LIMIT 1";
		try {
			TransactionDetail result = jdbcTemplate.queryForObject(sql, map, (rs, rowNum) -> createTransactionDetail(rs));
			return Optional.of(result);
		}catch(EmptyResultDataAccessException e) {
			// not an issue just means no rows found
			return Optional.empty();
		}
	}

	private TransactionDetail createTransactionDetail(ResultSet rs) throws SQLException {
		TransactionDetail transactionDetail = new TransactionDetail();
		transactionDetail.setXPath(rs.getString("xpath"));
		transactionDetail.setTextValue(rs.getString("textValue"));
		return transactionDetail;
	}

	/**
	 * Retrieves the current highest sequence number to increment from
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 */
	public Integer getMaxSequenceNo(long transactionId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		Integer maxSequenceNo = 1;
		try {
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT MAX(sequenceNo) AS `maxSequenceNo`"
					+ " FROM aggregator.transaction_details"
					+ " WHERE transactionId = ?"
					+ "   AND sequenceNo < ?"
			);
			stmt.setLong(1, transactionId);
			stmt.setInt(2, 300);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				maxSequenceNo = results.getInt("maxSequenceNo");
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return maxSequenceNo;
	}

	/**
	 * Performs an insert on the transaction details table.
	 * @param transactionDetail
	 * @throws DaoException
	 */
	// Should pass in ArrayList<TransactionDetails> so can batch insert.
	public void addTransactionDetails(final long transactionId, final TransactionDetail transactionDetail) throws DaoException {
		final Integer nextSequenceNo = transactionDetail.getSequenceNo() == null ? getMaxSequenceNo(transactionId) + 1 : transactionDetail.getSequenceNo();
		DatabaseUpdateMapping databaseMapping = new DatabaseUpdateMapping(){
			@Override
			public void mapParams() throws SQLException {
				set(transactionId);
				set(nextSequenceNo);
				set(transactionDetail.getXPath());
				set(transactionDetail.getTextValue());
			}

            @Override
            public String getStatement() {
                return "INSERT INTO aggregator.transaction_details " +
                        "(transactionId, sequenceNo, xpath, textValue, dateValue) " +
                        "VALUES " +
                        "(?,?,?,?,CURDATE());";
            }
        };
		SqlDao sqlDao = sqlDaoFactory.createDao();
		sqlDao.update(databaseMapping);
		
	}

	public void addTransactionDetailsWithDuplicateKeyUpdate(final long transactionId, final TransactionDetail transactionDetail) throws DaoException {
		final Integer nextSequenceNo = transactionDetail.getSequenceNo() == null ? getMaxSequenceNo(transactionId) + 1 : transactionDetail.getSequenceNo();
		DatabaseUpdateMapping databaseMapping = new DatabaseUpdateMapping(){
			@Override
			public void mapParams() throws SQLException {
				set(transactionId);
				set(nextSequenceNo);
				set(transactionDetail.getXPath());
				set(checkLengthTextValue(transactionDetail.getTextValue()));
			}

			@Override
			public String getStatement() {
				return "INSERT INTO aggregator.transaction_details " +
						"(transactionId, sequenceNo, xpath, textValue, dateValue) " +
						"VALUES " +
						"(?,?,?,?,CURDATE()) " +
						"ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);";
			}
		};
		SqlDao sqlDao = sqlDaoFactory.createDao();
		sqlDao.update(databaseMapping);

	}

	/** returns transaction details based off transactionId.
	 * @param transactionId
	 * @throws DaoException
	 */
	public List<TransactionDetail> getTransactionDetails(long transactionId) throws DaoException {
		List<TransactionDetail> transactionDetails = new  ArrayList<TransactionDetail>();
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();

				String sql =	"SELECT xpath, textValue " +
								"FROM aggregator.transaction_details td " +
								"WHERE td.transactionId = ? " +
								"UNION ALL " +
								"SELECT tf.fieldCode AS xpath, td.textValue " +
								"FROM aggregator.transaction_details2_cold td " +
								"	JOIN aggregator.transaction_fields tf USING(fieldId) " +
								"WHERE td.transactionId = ?;";

				stmt = conn.prepareStatement(sql);
				stmt.setLong(1, transactionId);
				stmt.setLong(2, transactionId);
				ResultSet results = stmt.executeQuery();
				while (results.next()) {
					TransactionDetail transactionDetail = new TransactionDetail();
					transactionDetail.setXPath(results.getString("xpath"));
					transactionDetail.setTextValue(results.getString("textValue"));
					transactionDetails.add(transactionDetail);
				}
		} catch (SQLException | NamingException e) {
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}
		return transactionDetails;
	}
	
	
	/**
	 * Low level insertOrUpdate. Determines whether to insert a new transaction detail or update the existing one.
	 * @param xpath String
	 * @param textValue String
	 * @param transactionId Long
	 * @return
	 */
	public void insertOrUpdate(String xpath, String textValue, long transactionId) {

		try {
			TransactionDetail transactionDetail = getTransactionDetailByXpath(transactionId, xpath);
			TransactionDetail transactionDetailNew = new TransactionDetail();
			transactionDetailNew.setXPath(xpath);
			transactionDetailNew.setTextValue(textValue);
			if(transactionDetail == null) {
				addTransactionDetails(transactionId, transactionDetailNew);
			} else {
				updateTransactionDetails(transactionId, transactionDetailNew);
			}
		} catch (DaoException e) {
			LOGGER.error("Transaction details insert or update failed {}, {}, {}", kv("xpath", xpath), kv("textValue", textValue), kv("transactionId", transactionId), e);
		}
	}

}
