package com.ctm.dao.leadfeed;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.dao.VerticalsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.content.Content;
import com.ctm.model.content.ContentSupplement;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.leadfeed.LeadFeedRootTransaction;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.ContentService;

public class BestPriceLeadsDao {

	private static Logger logger = Logger.getLogger(BestPriceLeadsDao.class.getName());

	private ArrayList<LeadFeedRootTransaction> transactions = null;
	private ArrayList<LeadFeedData> leads = null;

	/**
	 * Query the database for leads
	 *
	 * @param brandCodeId
	 * @param verticalCode
	 * @param minutes
	 * @param serverDate
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<LeadFeedData> getLeads(int brandCodeId, String verticalCode, Integer minutes, Date serverDate) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		transactions = new ArrayList<LeadFeedRootTransaction>();
		leads = new ArrayList<LeadFeedData>();

		Integer minutes_max = (minutes * 2) + 5; // Add 5 minutes to allow for timing issues with running of cron job
		Integer minutes_min = minutes;

		try{

			VerticalsDao verticalDao = new VerticalsDao();
			Vertical vertical = verticalDao.getVerticalByCode(verticalCode);

			if(verticalCode != null) {

				String activeBestPriceLeadProviders = getActiveProviders(vertical.getId(), serverDate);
				if(activeBestPriceLeadProviders != null) {

					dbSource = new SimpleDatabaseConnection();
					PreparedStatement stmt;

					/* Source transactions that have progressed through to results page in the last x minutes
					 * and/or those with existing leads triggered (which imply results have been seen) */
					stmt = dbSource.getConnection().prepareStatement(
						"SELECT h.rootId AS rootId, h.TransactionId AS transactionId, t.type AS type, h.styleCode, h.ipAddress " +
						"FROM aggregator.transaction_header AS h " +
						"LEFT JOIN ctm.touches AS t ON t.transaction_id = h.TransactionId AND t.type IN  ('R','BP','CB','A') " +
						"WHERE h.ProductType = ? AND h.styleCodeId = ? " +
						// Next line is important as it greatly reduces the size of the recordset and query speed overall
						"AND t.date >= DATE(CURRENT_DATE - INTERVAL " + minutes_max.toString() + " MINUTE) " +
						"AND t.transaction_id IS NOT NULL AND t.type IS NOT NULL " +
						"AND CONCAT_WS(' ', t.date, t.time) >= TIMESTAMP(CURRENT_TIMESTAMP - INTERVAL " + minutes_max.toString() + " MINUTE) " +
						"AND CONCAT_WS(' ', t.date, t.time) <= TIMESTAMP(CURRENT_TIMESTAMP - INTERVAL " + minutes_min.toString() + " MINUTE) " +
						"ORDER BY RootId ASC, transactionId ASC, t.date ASC, t.time ASC;"
					);
					stmt.setString(1, verticalCode);
					stmt.setInt(2, brandCodeId);
					ResultSet resultSet = stmt.executeQuery();

					while (resultSet.next()) {
						addTransaction(resultSet);
					}

					if(transactions.isEmpty() == false) {
						for (LeadFeedRootTransaction tran : transactions) {
							// Only proceed if no lead previously generated for root transaction
							// IE any transaction related to the rootID
							if(tran.getHasLeadFeed() == false) {
								stmt = dbSource.getConnection().prepareStatement(
									"SELECT r.TransactionId AS transactionId, p1.Value AS leadNo, " +
									"p2.Value AS leadInfo, p3.Value AS brandCode, p1.productId, " +
									// This sub-select will count all leads for the rootID which will eliminate
									// sending duplicates for transactions that span more than one reporting
									// period - ie greater than the delay to source leads (in previous select)
									"(SELECT COUNT(type) FROM ctm.touches WHERE transaction_id IN (" +
									"		SELECT TransactionId FROM aggregator.transaction_header " +
									"		WHERE rootId = '" + tran.getId() + "'" +
									"	) " +
									"	AND type IN ('BP','CB','A')" +
									") AS existingLeadCount " +
									"FROM aggregator.ranking_details AS r " +
									"LEFT JOIN aggregator.results_properties AS p1 " +
									"	ON p1.transactionId = r.TransactionId AND p1.productId = r.Value AND p1.property = 'leadNo' " +
									"LEFT JOIN aggregator.results_properties AS p2  " +
									"	ON p2.transactionId = r.TransactionId AND p2.productId = r.Value AND p2.property = 'leadfeedinfo' " +
									"LEFT JOIN aggregator.results_properties AS p3  " +
									"	ON p3.transactionId = r.TransactionId AND p3.productId = r.Value AND p3.property = 'brandCode' " +
									"WHERE r.TransactionId >= " + tran.getMinTransactionId() + " AND r.TransactionId <= " + tran.getMaxTransactionId() + " " +
									"	AND r.TransactionId IN (" + tran.toString() + ") " +
									"	AND r.RankPosition = 0 " +
									"	AND r.Value REGEXP '" + activeBestPriceLeadProviders + "' " +
									"	AND p2.Value IS NOT NULL AND p2.Value != '' " +
									"GROUP BY transactionId, leadNo, leadInfo, brandCode " +
									"HAVING existingLeadCount = 0 " +
									"ORDER BY r.TransactionId ASC, r.RankSequence DESC;"
								);

								resultSet = stmt.executeQuery();
								String identifier = null;
								String leadNumber = null;
								Boolean searching = true;
								LeadFeedData leadData = null;
								while(resultSet.next() && searching == true) {
									Long transactionId = resultSet.getLong("transactionId");
									String[] leadConcat = resultSet.getString("leadInfo").split("\\|\\|", -1);
									if(leadConcat.length == 4) {
										String curLeadNumber = resultSet.getString("leadNo");
										String curIdentifier = leadConcat[2];
										String phoneNumber = leadConcat[1];
										// Only proceed if a phone number has been provided otherwise the
										// user has not opted in and no lead should be generated
										if(!phoneNumber.isEmpty()) {
											// Create a lead data object only for the most recent identifer
											// Eg for car only get the latest lead for the first redbook code (aka identifier) found
											if(identifier == null || (curIdentifier.equals(identifier) && !curLeadNumber.equals(leadNumber))) {

												leadNumber = curLeadNumber;
												identifier = curIdentifier;

												String fullName = leadConcat[0];
												String state = leadConcat[3];
												String brandCode = resultSet.getString("brandCode");

												leadData = new LeadFeedData();
												leadData.setEventDate(serverDate);
												leadData.setPartnerBrand(brandCode);
												leadData.setTransactionId(transactionId);
												leadData.setClientName(fullName);
												leadData.setPhoneNumber(phoneNumber);
												leadData.setPartnerBrand(brandCode);
												leadData.setPartnerReference(leadNumber);
												leadData.setState(state);
												leadData.setClientIpAddress(tran.getIpAddress());
												leadData.setProductId(resultSet.getString("productId"));

												Brand brand = ApplicationService.getBrandByCode(tran.getStyleCode());
												leadData.setBrandId(brand.getId());
												leadData.setBrandCode(brand.getCode());
												leadData.setVerticalCode(verticalCode);
												leadData.setVerticalId(brand.getVerticalByCode(verticalCode).getId());

											// Escape current loop as the identifier has changed and we already have our lead data
											} else {
												searching = false;
											}
										} else {
											logger.info("[Lead info] Skipped " + transactionId + " as no optin for call");
										}
									} else {
										logger.error("leadInfo field in results properties (for " + transactionId + ") has an invalid number of elements (" + leadConcat.length + ")");
									}
								}

								// Add lead object to the list
								if(leadData != null) {
									leads.add(leadData);
								}
							}
						}
					}
				} else {
					logger.error("Failed to retrieve any active best price lead feed providers for (" + verticalCode + ")");
					throw new DaoException("Failed to retrieve any active best price lead feed providers for (" + verticalCode + ")");
				}
			} else {
				logger.error("Failed to retrieve vertical data for id (" + verticalCode + ") for last " + minutes + " minutes");
				throw new DaoException("Failed to retrieve vertical data for id (" + verticalCode + ")");
			}
		} catch (SQLException | NamingException e) {
			logger.error("Failed to get lead feed transactions for vertical (" + verticalCode + ") for last " + minutes + " minutes" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return leads;
	}

	private void addTransaction(ResultSet set) {
		try {
			// Either create a new root transaction object or add transaction to existing one
			LeadFeedRootTransaction tran = getRootTransaction(set.getLong("rootId"));
			if(tran == null) {
				tran = new LeadFeedRootTransaction(set.getLong("rootId"), set.getLong("transactionId"));
				transactions.add(tran);
			} else {
				tran.addTransaction(set.getLong("transactionId"));
			}
			tran.setStyleCode(set.getString("styleCode"));
			tran.setIpAddress(set.getString("ipAddress"));
			// Flag the root transaction as having existing lead feed if applicable
			String type = set.getString("type");
			if(
				type.equalsIgnoreCase("A") || type.equalsIgnoreCase("BP") || type.equalsIgnoreCase("CB")) {
				tran.setHasLeadFeed(true);
				logger.info("[Lead info] Skipping transaction " + set.getLong("transactionId") + " as has lead already");
			}
		} catch(SQLException e) {
			logger.error(e.getMessage(), e);
		}
	}

	private LeadFeedRootTransaction getRootTransaction(Long rootId) {
		for (LeadFeedRootTransaction tran : transactions) {
			if (tran.getId().equals(rootId)) {
				return tran;
			}
		}
		return null;
	}

	private String getActiveProviders(Integer verticalId, Date serverDate) throws DaoException {
		StringBuilder providers = new StringBuilder();
		try {
			ContentService contentService = new ContentService();
			Content content = contentService.getContent("bestPriceProviders", 0, verticalId, serverDate, true);
			ArrayList<ContentSupplement> providersContent = content.getSupplementary();
			for (ContentSupplement provider : providersContent) {
				if(provider.getSupplementaryValue().equalsIgnoreCase("Y")) {
					if(!providers.toString().isEmpty()) {
						providers.append("|");
					}
					providers.append(provider.getSupplementaryKey());
				}
			}
		} catch(DaoException e) {
			throw new DaoException(e.getMessage(), e);
		}
		return providers.toString();
	}
}
