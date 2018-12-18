package com.ctm.web.health.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.model.HealthDuplicateTransaction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class HealthDetectMatchingTransactionsDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(HealthDetectMatchingTransactionsDao.class);


    public HealthDetectMatchingTransactionsDao() {

    }

	/**
	 * Returns list of duplicate transactions
	 *
	 * @param rootId
	 * @param transactionId
	 * @param emailAddress
	 * @param fullAddress
	 * @param mobile
	 * @param homePhone
	 * @param numberOfResultsToReturn
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<HealthDuplicateTransaction> checkMatchingTransactions(String rootId, String transactionId, String emailAddress, String fullAddress, String mobile, String homePhone, int numberOfResultsToReturn) throws DaoException { // java.lang.RuntimeException {  //throws DaoException || JSONException
		SimpleDatabaseConnection dbSource = null;

		ArrayList<HealthDuplicateTransaction> duplicateTransactions = new ArrayList<>();

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;
			Boolean addUnion = false;

			String statementSQL =
				"SELECT th.`transactionId`, th.`rootId`, tn.`textValue` as 'full_name', tch.`date`, tch.`time`, tch.`operator_id` , mr.`match_rating` " +
				"FROM `aggregator`.`transaction_header` th " +
				"INNER JOIN `aggregator`.`transaction_details` tn ON th.`transactionId` = tn.`transactionId` " +
				"INNER JOIN `ctm`.`touches` tch ON tch.`transaction_id` = th.`transactionId` " +
				"INNER JOIN ( " +
				"	SELECT `transactionId`, SUM(`score`) as 'match_rating' " +
				"	FROM ( ";


			if (emailAddress.length() > 0) {
				// other transactions that have the same email where the user has reached the payment page or the confirmation page
				statementSQL +=
					"		( " +
					"			SELECT distinct em.`transactionId`,  1 as 'score' " +
					"			FROM `aggregator`.`email_master` em " +
					"			INNER JOIN `ctm`.`touches` t " +
					"			ON em.transactionId = t.transaction_id " +
					"			AND (( " +
										// Sold in the last 60 days
					"					t.`type` = 'c' " +
					"					AND t.`date` BETWEEN DATE_ADD(CURDATE(), INTERVAL -60 DAY) AND CURDATE() " +
					"				) OR ( " +
										// payment page reached today
					"					t.`type` = 'p' " +
					"					AND t.`date` = CURDATE() " +
					"				) " +
					"			) " +
					"			WHERE `emailAddress` = '" + emailAddress + "' " +
					"		) ";

				addUnion = true;
			}

			if (mobile.length() > 0) {
				// other transactions that have the same mobile where the user has reached the payment page or the confirmation page

				if (addUnion) {
					statementSQL += "		UNION ALL ";
				}

				statementSQL +=
					"( " +
					"			SELECT distinct pl.`transactionId`,  1 as 'score' " +
					"			FROM `aggregator`.`phone_lookup` pl " +
					"			INNER JOIN `ctm`.`touches` t " +
					"			ON pl.transactionId = t.transaction_id " +
					"			AND (( " +
										// Sold in the last 60 days
					"					t.`type` = 'c' " +
					"					AND t.`date` BETWEEN DATE_ADD(CURDATE(), INTERVAL -60 DAY) AND CURDATE() " +
					"				) OR ( " +
										// payment page reached today
					"					t.`type` = 'p' " +
					"					AND t.`date` = CURDATE() " +
					"				) " +
					"			) " +
					"			WHERE pl.`PhoneNumber` =  '" + mobile + "' " +
					"		) ";

				addUnion = true;
			}

			if (homePhone.length() > 0) {
				// other transactions that have the landline where the user has reached the payment page or the confirmation page

				if (addUnion) {
					statementSQL += "		UNION ALL ";
				}

				statementSQL +=
					"( " +
					"			SELECT distinct pl.`transactionId`,  1 as 'score' " +
					"			FROM `aggregator`.`phone_lookup` pl " +
					"			INNER JOIN `ctm`.`touches` t " +
					"			ON pl.transactionId = t.transaction_id " +
					"			AND (( " +
										// Sold in the last 60 days
					"					t.`type` = 'c' " +
					"					AND `date` BETWEEN DATE_ADD(CURDATE(), INTERVAL -60 DAY) AND CURDATE() " +
					"				) OR ( " +
										// payment page reached today
					"					t.`type` = 'p' " +
					"					AND t.`date` = CURDATE() " +
					"				) " +
					"			) " +
					"			WHERE `PhoneNumber` = '" + homePhone + "' " +
					"			OR `PhoneNumber` = '" + homePhone.substring(2) + "' " +
					"		) ";

				addUnion = true;
			}

			if (fullAddress.length() > 0) {
				// other transactions that have the same address

				if (addUnion) {
					statementSQL += "		UNION ALL ";
				}

				statementSQL +=
					"( " +
					"			SELECT distinct t.`transaction_Id`,  1 as 'score' " +
					"			FROM `ctm`.`touches` t " +
					"			INNER JOIN `aggregator`.`transaction_details` td " +
					"			ON 	td.transactionId = t.transaction_id " +
					"			AND  td.`xpath` = 'health/application/address/fullAddress' " +
					"			AND  UPPER(td.`textValue`) = '" + fullAddress.toUpperCase() + "' " +
					"			WHERE  ( " +
										// Sold in the last 60 days
					"					t.`type` = 'c' " +
					"					AND t.`date` BETWEEN DATE_ADD(CURDATE(), INTERVAL -60 DAY) AND CURDATE() " +
					"				) OR ( " +
										// payment page reached today
					"					t.`type` = 'p' " +
					"					AND t.`date` = CURDATE() " +
					"			) " +

					"		) ";
			}

			statementSQL +=
				"		UNION ALL ( " +
				            // other transactions that have the same root id where the user has reached the payment page or the confirmation page
				"			SELECT distinct h.`transactionId`,  1 as 'score' " +
				"			FROM `aggregator`.`transaction_header` h " +
				"			INNER JOIN  `ctm`.`touches` t " +
				"			ON h.`transactionId` = t.`transaction_id` " +
				"			AND (( " +
									// Sold in the last 60 days
				"					t.`type` = 'c' " +
				"					AND t.`date` BETWEEN DATE_ADD(CURDATE(), INTERVAL -60 DAY) AND CURDATE() " +
				"				) OR ( " +
									// payment page reached today
				"					t.`type` = 'p' " +
				"					AND t.`date` = CURDATE() " +
				"				) " +
				"			) " +
				"			WHERE h.`rootId` = " + rootId + " " +                 // Current root id
				"			AND h.`transactionId` != " + transactionId + " " +    // Current transaction ID
				"		) " +
				"	) AS a " +
				"	GROUP BY `transactionId` " +
				") mr ON mr.`transactionId` = th.`transactionId` " +
				"WHERE th.`ProductType` = 'HEALTH' " +
				"AND th.`StyleCode` = 'ctm' " +
				"AND tn.`xpath` = 'health/contactDetails/name' " +
				"AND tch.`type` = 'p' " +
				"ORDER BY mr.`match_rating` DESC, tch.`date` DESC, tch.`time` DESC " +
				"LIMIT " + String.valueOf(numberOfResultsToReturn);

			stmt = dbSource.getConnection().prepareStatement(statementSQL);

			ResultSet dupeCheckResult = stmt.executeQuery();

			while (dupeCheckResult.next()) {
				HealthDuplicateTransaction dupeTrans = new HealthDuplicateTransaction();
				dupeTrans.setTransactionId(dupeCheckResult.getString("transactionId"));
				dupeTrans.setRootId(dupeCheckResult.getString("rootId"));
				dupeTrans.setFullName(dupeCheckResult.getString("full_name"));
				dupeTrans.setDate(dupeCheckResult.getString("date"));
				dupeTrans.setTime(dupeCheckResult.getString("time"));
				dupeTrans.setOperatorId(dupeCheckResult.getString("operator_id"));
				duplicateTransactions.add(dupeTrans);
			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to Fetch Duplicate Transactions Check Result {}, {}",  kv("transactionId", transactionId));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return duplicateTransactions;
	}
}