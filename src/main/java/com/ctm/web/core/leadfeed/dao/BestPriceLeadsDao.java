package com.ctm.web.core.leadfeed.dao;

import com.ctm.web.car.leadfeed.services.CTM.CTMCarLeadFeedService;
import com.ctm.web.car.model.form.CarQuote;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.model.ContentSupplement;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.dao.VerticalsDao;
import com.ctm.web.core.exceptions.DaoException;

import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadService.model.LeadType;
import com.ctm.web.core.leadfeed.model.CTMCarLeadFeedRequestMetadata;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.model.Person;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.leadfeed.LeadFeedRootTransaction;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;

import javax.naming.NamingException;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Find any transactions which qualify as leads and create an instance of LeadFeedData for each one.
 * This in preparation for sending a valid request to ctm-leads.
 * (http://bitbucket.budgetdirect.com.au/projects/CTMSRV/repos/ctm-leads-project)
 *
 */
public class BestPriceLeadsDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(BestPriceLeadsDao.class);
	private static final CharSequence BUDD = "BUDD";

	private ArrayList<LeadFeedRootTransaction> transactions = null;
	private ArrayList<LeadFeedData> leads = null;

	/**
	 * TODO: get this 'orrible mess into some kind of configuration.
	 */
	private final Integer CALLBACKDELAY = 0;
	private final Integer CALLDIRECTDELAY = 15;
	private final Integer NPODELAY = 30;
	private final Integer BESTPRICEDELAY = 10;
	private final Integer MOREINFODELAY = 10;

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
	public ArrayList<LeadFeedData> getLeads(int brandCodeId, String verticalCode, Integer minutes, Date serverDate) throws DaoException {

		SimpleDatabaseConnection dbSource = null;

		transactions = new ArrayList<>();
		leads = new ArrayList<>();


		Integer minutes_max = (minutes * 2) + 5; // Add 5 minutes to allow for timing issues with running of cron job

		try{

			VerticalsDao verticalDao = new VerticalsDao();
			Vertical vertical = verticalDao.getVerticalByCode(verticalCode);

			if(verticalCode != null) {

				String activeBestPriceLeadProviders = getActiveProviders(vertical.getId(), serverDate);
				if(activeBestPriceLeadProviders != null) {

					dbSource = new SimpleDatabaseConnection();
					PreparedStatement stmt;

					/* Source transactions that have progressed through to results page or had any of the "lead request" types in the last x minutes depending on the lead request type.
					 * and/or those with existing leads triggered (which imply results have been seen) */
					stmt = dbSource.getConnection().prepareStatement(
						"SELECT h.rootId AS rootId, h.TransactionId AS transactionId, t.type AS type, h.styleCode, h.ipAddress " +
						"FROM aggregator.transaction_header AS h " +
						"LEFT JOIN ctm.touches AS t ON t.transaction_id = h.TransactionId AND t.type IN  ('R','BP','CMR','CDR','MoreInfo','OHR', 'CD', 'BPDD') " +
						"WHERE h.ProductType = ? AND h.styleCodeId = ? " +
						// Next line is important as it greatly reduces the size of the recordset and query speed overall
						"AND t.date >= DATE(CURRENT_DATE - INTERVAL 40 MINUTE) " +
						"AND t.transaction_id IS NOT NULL AND t.type IS NOT NULL " +
						"AND CONCAT_WS(' ', t.date, t.time) <= TIMESTAMP(CURRENT_TIMESTAMP - INTERVAL " +
								"CASE WHEN t.type = 'R' THEN " + BESTPRICEDELAY + " " +
								" WHEN t.type = 'CMR' THEN " + CALLBACKDELAY + " " +
									"WHEN t.type = 'CDR' THEN " + CALLDIRECTDELAY + " " +
									"WHEN t.type = 'MoreInfo' THEN " + MOREINFODELAY + " " +
								"WHEN t.type = 'OHR' THEN " + NPODELAY + " ELSE 0 END" +
									" MINUTE) " +
						"AND CONCAT_WS(' ', t.date, t.time) >= TIMESTAMP(CURRENT_TIMESTAMP - INTERVAL 40 MINUTE) " +
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
									"p2.Value AS leadInfo, p3.Value AS brandCode, p4.Value AS followupIntended, p5.Value AS propensityScore," +
									"p1.productId, t.productCode AS moreInfoProductCode, " +
									// This sub-select will count all leads for the rootID which will eliminate
									// sending duplicates for transactions that span more than one reporting
									// period - ie greater than the delay to source leads (in previous select)
									"(SELECT COUNT(type) FROM ctm.touches WHERE transaction_id IN (" +
									"		SELECT TransactionId FROM aggregator.transaction_header " +
									"		WHERE rootId = '" + tran.getId() + "'" +
									"	) " +
									"	AND type IN ('BP','CB','CD','NPO','MIR', 'CD', 'BPDD')" +
									") AS existingLeadCount " +
									"FROM aggregator.ranking_details AS r " +
									"LEFT JOIN aggregator.results_properties AS p5 " +
									"	ON p5.transactionId = r.TransactionId AND p5.productId = r.Value AND p5.property = 'propensityScore' " +
									"LEFT JOIN aggregator.results_properties AS p1 " +
									"	ON p1.transactionId = r.TransactionId AND p1.productId = r.Value AND p1.property = 'leadNo' " +
									"LEFT JOIN aggregator.results_properties AS p2  " +
									"	ON p2.transactionId = r.TransactionId AND p2.productId = r.Value AND p2.property = 'leadfeedinfo' " +
									"LEFT JOIN aggregator.results_properties AS p3  " +
									"	ON p3.transactionId = r.TransactionId AND p3.productId = r.Value AND p3.property = 'brandCode' " +
									"LEFT JOIN aggregator.results_properties AS p4  " +
									"	ON p4.transactionId = r.TransactionId AND p4.productId = r.Value AND p4.property = 'followupIntended' " +
									" left join (select tp.productCode, t.transaction_id as transactionId from ctm.touches t join ctm.touches_products tp on t.id = tp.touchesId where t.type = 'MoreInfo') as t " +
									" on t.transactionId = r.transactionId and t.productCode = r.value and r.property = 'productId' " +
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

									// old leadfeedinfo will have 4 elements, and new once will have 6.
									if(leadConcat.length >= CarQuote.LEAD_FEED_INFO_SIZE_V1) {
										String curLeadNumber = resultSet.getString("leadNo");
										String propensityScore = resultSet.getString("propensityScore");
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
												leadData.setLeadType(tran.getType());
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
												leadData.setMoreInfoProductCode(resultSet.getString("moreInfoProductCode"));
												leadData.setFollowupIntended(resultSet.getString("followupIntended"));

												Brand brand = ApplicationService.getBrandByCode(tran.getStyleCode());
												leadData.setBrandId(brand.getId());
												leadData.setBrandCode(brand.getCode());
												leadData.setVerticalCode(verticalCode);
												leadData.setVerticalId(brand.getVerticalByCode(verticalCode).getId());

												/**
												 * CAR-1524: Send all CAR BestPrice leads for Budget Direct to `ctm-leads` instead of A&G.
												 * To be able to process leads, `ctm-leads` require more info (person, metadata) as part of lead feed data.
												 */
												if (isCarBestPriceLeadFeedForBUDD(leadData)) {
													final ServiceConfiguration serviceConfig;
													try {
														serviceConfig = ServiceConfigurationService.getServiceConfiguration("leadService", CTMCarLeadFeedService.CAR_VERTICAL_ID);
													} catch (ServiceConfigurationException e) {
														LOGGER.error("[lead feed] Exception while reading service config. Message: {}", e.getMessage(), e);
														throw new DaoException(e.getMessage(), e);
													}

													final Boolean carCtmLeadsEnabled = Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", brandCodeId, 0, ServiceConfigurationProperty.Scope.SERVICE));

													if (carCtmLeadsEnabled) {
														if (leadConcat.length >= CarQuote.LEAD_FEED_INFO_SIZE_V2) {
															leadData.setRootId(tran.getMinTransactionId());
															updateLeadFeedDataWithPersonInfo(leadData, leadConcat[4]);
															updateLeadFeedDataWithMetadata(leadData, leadConcat[5], propensityScore);
														} else {
															//log and skip this lead as its un-processable.
															LOGGER.error("[Lead info] lead info has invalid number of elements {}, {}, {}, {}, {}, {}", kv("transactionId", transactionId), kv("leadConcatLength", leadConcat.length), kv("brandCodeId", brandCodeId), kv("verticalCode", verticalCode), kv("minutes", minutes), kv("serverDate", serverDate));
															leadData = null;
														}
													}
												}

											// Escape current loop as the identifier has changed and we already have our lead data
											} else {
												searching = false;
											}
										} else {
											LOGGER.debug("[Lead info] lead skipped as no optin for call {}, {}, {}, {}, {}", kv("transactionId", transactionId), kv("brandCodeId", brandCodeId), kv("verticalCode", verticalCode), kv("minutes", minutes), kv("serverDate", serverDate));
										}
									} else {
										LOGGER.error("[Lead info] lead info has invalid number of elements {}, {}, {}, {}, {}, {}", kv("transactionId", transactionId), kv("leadConcatLength", leadConcat.length), kv("brandCodeId", brandCodeId), kv("verticalCode", verticalCode), kv("minutes", minutes), kv("serverDate", serverDate));
									}
								}

								// Add lead object to the list
								if(leadData != null) {

									// CAR-1357 - When BUDD is best price AND product is "Budget Direct Gold Comprehensive" AND followupIntended=N AND NOT More Info Best Price
									if (Vertical.VerticalType.CAR.getCode().equals(vertical.getCode())
											&& StringUtils.equals("BUDD", leadData.getPartnerBrand())
											&& StringUtils.equals("BUDD-05-04", leadData.getProductId()) //  Budget Direct Gold Comprehensive
											&& StringUtils.equals("N", leadData.getFollowupIntended())
											&& StringUtils.isBlank(leadData.getMoreInfoProductCode())) {
										// Alter brandCode, productId and partnerReference to EXDD

										stmt = dbSource.getConnection().prepareStatement(
												"SELECT p1.Value AS brandCode, p2.Value AS leadNumber, p3.Value AS productId " +
												"FROM aggregator.results_properties p1 " +
												"	LEFT JOIN aggregator.results_properties p2 " +
												"		ON p2.transactionId = p1.transactionId AND p2.productId = p1.productId AND p2.property = 'leadNo' " +
												"	LEFT JOIN aggregator.results_properties p3 " +
												"		ON p3.transactionId = p1.transactionId AND p3.productId = p1.productId AND p3.property = 'productId' " +
												"WHERE p1.transactionId = ? AND p1.productId = ? AND p1.property = 'brandCode'");

										stmt.setLong(1, leadData.getTransactionId());
										stmt.setString(2, "EXDD-05-04");

										resultSet = stmt.executeQuery();
										while(resultSet.next()) {
											// NOTE: leadData brandId should not change as we are sending the lead using BUDD credentials.
											leadData.setNewPartnerBrand(resultSet.getString("brandCode"));
											leadData.setNewPartnerReference(resultSet.getString("leadNumber"));
											leadData.setNewProductId(resultSet.getString("productId"));
											leadData.setPartnerReferenceChange(true);
										}

									}

									leads.add(leadData);
								}
							}
						}
					}
				} else {
					LOGGER.error("Failed to retrieve any active best price lead feed providers {}, {}, {}, {}", kv("verticalCode", verticalCode), kv("brandCodeId", brandCodeId), kv("minutes", minutes), kv("serverDate", serverDate));
					throw new DaoException("Failed to retrieve any active best price lead feed providers verticalCode=" + verticalCode);
				}
			} else {
				LOGGER.error("Failed to retrieve lead feed {}, {}, {}, {}", kv("verticalCode", verticalCode), kv("brandCodeId", brandCodeId), kv("minutes", minutes), kv("serverDate", serverDate));
				throw new DaoException("Failed to retrieve vertical data for id (" + verticalCode + ")");
			}
		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to get lead feed transactions {}, {}", kv("verticalCode", verticalCode), kv("minutes", minutes));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return leads;
	}

	/**
	 * Update lead feed data with meta data as required by `ctm-leads`
	 *
	 * Note: do not throw any exception here.
	 * @param leadData
	 * @param metadataJsonString
	 * @param propensityScore
	 */
	private void updateLeadFeedDataWithMetadata(LeadFeedData leadData, String metadataJsonString, final String propensityScore) {
        if(StringUtils.isBlank(metadataJsonString)){
            return;
        }
        LOGGER.info("BANANA: "+ metadataJsonString);
        CTMCarLeadFeedRequestMetadata metadata = new CTMCarLeadFeedRequestMetadata();
        try {
            final ObjectMapper mapper = new ObjectMapper();
            metadata = mapper.readValue(metadataJsonString, CTMCarLeadFeedRequestMetadata.class);
        } catch (IOException e) {
            e.printStackTrace();
        }

        metadata.setProviderQuoteRef(leadData.getPartnerReference());
        metadata.setProviderCode(leadData.getPartnerBrand());
        //propensity score could be null, DUPLICATE, double, string. `ctm-leads` is responsible for it to convert it to usable form.
        metadata.setPropensityScore(propensityScore);
        leadData.setMetadata(metadata);
    }

	/**
	 * Updates lead feed data with person as required by `ctm-leads`
	 *
	 * Note: do not throw any exception here.
	 * @param leadData
	 * @param personJsonString
	 */
	private void updateLeadFeedDataWithPersonInfo(LeadFeedData leadData, String personJsonString) {

        if (StringUtils.isBlank(personJsonString)) {
            return;
        }

        Person person = null;
        try {
            final ObjectMapper mapper = new ObjectMapper();
            person = mapper.readValue(personJsonString, Person.class);
        } catch (IOException e) {
            e.printStackTrace();
        }

        leadData.setPerson(person);
    }

	/**
	 * returns true if lead feed data is for Car, best price, for Budget Direct, else false.
	 *
	 * Note: do not throw any exception here.
	 * @param leadFeedData
	 * @return
	 */
	private boolean isCarBestPriceLeadFeedForBUDD(LeadFeedData leadFeedData) {
        if (StringUtils.equalsIgnoreCase(leadFeedData.getVerticalCode(), Vertical.VerticalType.CAR.toString())
                && StringUtils.equals(leadFeedData.getPartnerBrand(), BUDD)) {
            return true;
        }
        return false;
    }


	private void addTransaction(ResultSet set) {
		try {
			// Either create a new root transaction object or add transaction to existing one
			LeadFeedRootTransaction tran = getRootTransaction(set.getLong("rootId"));
			final long transactionId = set.getLong("transactionId");
			if(tran == null) {
				tran = new LeadFeedRootTransaction(set.getLong("rootId"), transactionId);
				transactions.add(tran);
			} else {
				tran.addTransaction(transactionId);
			}
			tran.setStyleCode(set.getString("styleCode"));
			tran.setIpAddress(set.getString("ipAddress"));
			// Flag the root transaction as having existing lead feed if applicable
			String type = set.getString("type");
			if(
				type.equalsIgnoreCase("BP") || type.equalsIgnoreCase("CB")|| type.equalsIgnoreCase("CD")|| type.equalsIgnoreCase("NPO")|| type.equalsIgnoreCase("MIR")) {
				tran.setHasLeadFeed(true);
				LOGGER.info("[Lead info] Skipping existing lead feed transaction {}", kv("transactionId", transactionId));
			}
			switch(type) {
				case("CMR"): tran.setType(LeadType.CALL_ME_BACK); break;
				case("CDR"): tran.setType(LeadType.CALL_DIRECT); break;
				//If tran type is absent, or tran type = Best price, update to MoreInfo.
				case("MoreInfo"): if(tran.getType() == null || (tran.getType() != null && tran.getType().equals(LeadType.BEST_PRICE))) {
					tran.setType(LeadType.MORE_INFO);
				} break;
				case("OHR"): tran.setType(LeadType.ONLINE_HANDOVER); break;
				default: tran.setType(LeadType.BEST_PRICE); break;

			}
		} catch(SQLException e) {
			LOGGER.error("[Lead info] Failed to add best price lead feed transaction", e);
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
			throw new DaoException(e);
		}
		return providers.toString();
	}
}
