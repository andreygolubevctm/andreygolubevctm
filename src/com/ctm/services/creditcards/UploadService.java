package com.ctm.services.creditcards;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.model.creditcards.UploadRequest;
import javax.naming.NamingException;
import java.io.*;
import java.util.*;
import java.util.regex.*;

public class UploadService {

	public static String getRates(UploadRequest file) {

		StringBuilder update = new StringBuilder();

		int providerId = 0;
		String providerCode = file.providerCode;
		String providerName = "";
		String effectiveDate = file.effectiveDate;

		if(file.deleteId.length() > 0) {
			update.append("UPDATE ctm.product_properties_text SET EffectiveEnd='"+effectiveDate+"' WHERE productid IN ("+file.deleteId+");\r\n");
			update.append("UPDATE ctm.product_properties SET EffectiveEnd='"+effectiveDate+"' WHERE productid IN ("+file.deleteId+");\r\n");
			update.append("UPDATE ctm.product_master SET EffectiveEnd='"+effectiveDate+"', Status='X' WHERE productid IN ("+file.deleteId+");\r\n");
		}

		try {
			SimpleDatabaseConnection dbSource = null;
			try {
				PreparedStatement stmt;

				dbSource = new SimpleDatabaseConnection();

				stmt = dbSource.getConnection().prepareStatement(
						"SELECT providerId, Name  FROM ctm.provider_master WHERE providerCode = ?"
				);
				stmt.setString(1, providerCode);

				ResultSet results = stmt.executeQuery();

				while (results.next()) {
					providerId = results.getInt("ProviderId");
					providerName = results.getString("Name");
				}

			} catch (SQLException | NamingException e) {

			}
			finally {
				dbSource.closeConnection();
			}
				int PRODUCT_CODE_COLUMN_NUMBER = 0;
				int PROVIDER_NAME_COLUMN_NUMBER = 1;

				int PROPERTY_SLUG_COLUMN_NUMBER = 2;
				int PROPERTY_META_PAGE_COLUMN_NUMBER = 3;
				int PROPERTY_META_PAGE_DESC_COLUMN_NUMBER = 4;
				int PRODUCT_SHORT_DESC_COLUMN_NUMBER = 5;
				int PROPERTY_TYPE_COLUMN_NUMBER = 6;
				int PROPERTY_CARD_CLASS_COLUMN_NUMBER = 7;

				int PROPERTY_INTRO_INTEREST_RATE_COLUMN_NUMBER = 8;
				int PROPERTY_INTRO_INTEREST_RATE_PERIOD_COLUMN_NUMBER = 9;
				int PROPERTY_INTEREST_RATE_COLUMN_NUMBER = 10;
				int PROPERTY_INTRO_BALANCE_TRANSFER_RATE_COLUMN_NUMBER = 11;
				int PROPERTY_INTRO_BALANCE_TRANSFER_RATE_PERIOD_COLUMN_NUMBER = 12;
				int PROPERTY_BALANCE_TRANSFER_RATE_COLUMN_NUMBER = 13;
				int PROPERTY_BALANCE_TRANSFER_FEE_COLUMN_NUMBER = 14;
				int PROPERTY_INTRO_ANNUAL_FEE_COLUMN_NUMBER = 15;
				int PROPERTY_INTRO_ANNUAL_FEE_PERIOD_COLUMN_NUMBER = 16;
				int PROPERTY_ANNUAL_FEE_COLUMN_NUMBER = 17;
				int PROPERTY_CASH_ADVANCE_COLUMN_NUMBER = 18;


				//int PROPERTY_REWARDS_CARD_CLASS_COLUMN_NUMBER = 0;
				int PROPERTY_REWARDS_STANDARD_POINTS_COLUMN_NUMBER = 19;
				int PROPERTY_REWARDS_AMEX_POINTS_COLUMN_NUMBER = 20;
				int PROPERTY_BONUS_POINTS_COLUMN_NUMBER = 21;

				int PROPERTY_SPECIAL_OFFER_COLUMN_NUMBER = 22;
				int PROPERTY_LONG_DESC_COLUMN_NUMBER = 23;
				int PROPERTY_REWARDS_DESC_COLUMN_NUMBER = 24;
				int PROPERTY_OTHER_FEATURES_COLUMN_NUMBER = 25;
				int PROPERTY_INTEREST_RATE_TERMS_COLUMN_NUMBER = 26;
				int PROPERTY_REWARDS_TERMS_COLUMN_NUMBER = 27;
				int PROPERTY_BALANCE_TRANSFER_TERMS_COLUMN_NUMBER = 28;
				int PROPERTY_OTHER_FEATURES_TERMS_COLUMN_NUMBER = 29;
				int PROPERTY_GENERAL_TERMS_COLUMN_NUMBER = 30;

				int PROPERTY_ADDITIONAL_CARD_HOLDER_COLUMN_NUMBER = 31;
				int PROPERTY_FOREIGN_EXCHANGE_FEES_COLUMN_NUMBER = 32;
				int PROPERTY_COMPLIMENTARY_TRAVEL_INSURANCE_COLUMN_NUMBER = 33;
				int PROPERTY_EXTENDED_WARRANTY_COLUMN_NUMBER = 34;
				int PROPERTY_AVAILABLE_TEMPORARY_RESIDENTS_COLUMN_NUMBER = 35;
				int PROPERTY_INTEREST_FREE_DAYS_COLUMN_NUMBER = 36;
				int PROPERTY_LATE_PAYMENT_FEE_COLUMN_NUMBER = 37;

				int PROPERTY_MINIMUM_INCOME_COLUMN_NUMBER = 38;
				int PROPERTY_MINIMUM_CREDIT_LIMIT_COLUMN_NUMBER = 39;
				int PROPERTY_MAXIMUM_CREDIT_LIMIT_COLUMN_NUMBER = 40;
				int PROPERTY_MINIMUM_MONTHLY_REPAYMENT_COLUMN_NUMBER = 41;
				int PROPERTY_CATEGORIES_COLUMN_NUMBER = 42;
				int PROPERTY_HANDOVER_URL_COLUMN_NUMBER = 43;

					BufferedReader in = new BufferedReader(new InputStreamReader(file.uploadedStream));

					String line, lineNext = "";

					HashMap<String, Integer> map = new HashMap<String, Integer>();

					String productCode = "";
					String prevProductCode = "";
					int sequenceNo = 0;
					String[] part;

					// Get the header
					line = in.readLine();

					// Get first line
					line = in.readLine().trim();


					do {
						if(lineNext != null) {
							if(!lineNext.startsWith(providerCode)) {
								if(lineNext.trim().length() > 0) {
									line += "\n" + lineNext.trim();
								}
								continue;
							}
						}
						part = line.split(",(?=(?:(?:[^\"]*\"){2})*[^\"]*$)");
						for(int i=0;i<part.length; i++){
							part[i] = part[i].replaceAll("\"", "");
							part[i] = part[i].replaceAll("\u2014", "-");
							part[i] = part[i].replaceAll("\u2018", "'");
							part[i] = part[i].replaceAll("\u2019", "'");
							part[i] = part[i].replaceAll("\u201C", "\"");
							part[i] = part[i].replaceAll("\u201D", "\"");
							part[i] = part[i].replaceAll("'-", "-");
							part[i] = part[i].replaceAll("'", "''");
							part[i] = part[i].trim();
						}

						if(part.length > 0){
							int productId = -1;

							productCode = part[PRODUCT_CODE_COLUMN_NUMBER];

							if (part[PROVIDER_NAME_COLUMN_NUMBER].equals(providerName)){

								try {
									PreparedStatement stmt;

									dbSource = new SimpleDatabaseConnection();

									stmt = dbSource.getConnection().prepareStatement(
											"SELECT productId FROM ctm.product_master WHERE ProductCode = ? AND Status != 'X'"
									);

									stmt.setString(1, part[PRODUCT_CODE_COLUMN_NUMBER]);

									ResultSet results = stmt.executeQuery();

									while (results.next()) {
										productId = results.getInt("productId");
									}
								} catch (SQLException | NamingException e) {

								}
								finally {
									dbSource.closeConnection();
								}

								if (productId == -1){
									update.append("\r\n\r\nINSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, ShortTitle, LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','"+part[PRODUCT_CODE_COLUMN_NUMBER]+"',"+providerId+",'"+part[PRODUCT_SHORT_DESC_COLUMN_NUMBER]+"','"+part[PRODUCT_SHORT_DESC_COLUMN_NUMBER]+"','"+effectiveDate+"','2040-12-31','');\r\n");
									update.append("SET @product_id = LAST_INSERT_ID();\r\n");

								} else {
									update.append("\r\n\r\nUPDATE ctm.product_master SET ShortTitle = '"+part[PRODUCT_SHORT_DESC_COLUMN_NUMBER]+"', LongTitle = '"+part[PRODUCT_SHORT_DESC_COLUMN_NUMBER]+"' WHERE productId = "+productId+";\r\n");
									update.append("SET @product_id = "+productId+";\r\n");
								}

								update.append("DELETE FROM ctm.product_properties WHERE productid = @product_id;\r\n");
								update.append("DELETE FROM ctm.product_properties_text WHERE productid = @product_id;\r\n");

								if (productCode != prevProductCode){
									prevProductCode = productCode;
								}

									map.clear();
									map.put("slug",PROPERTY_SLUG_COLUMN_NUMBER);
									map.put("meta-page-title",PROPERTY_META_PAGE_COLUMN_NUMBER);
									map.put("meta-page-desc",PROPERTY_META_PAGE_DESC_COLUMN_NUMBER);
									map.put("product-type",PROPERTY_TYPE_COLUMN_NUMBER);
									map.put("card-class",PROPERTY_CARD_CLASS_COLUMN_NUMBER);

									map.put("intro-rate",PROPERTY_INTRO_INTEREST_RATE_COLUMN_NUMBER);
									map.put("intro-rate-period",PROPERTY_INTRO_INTEREST_RATE_PERIOD_COLUMN_NUMBER);
									map.put("interest-rate",PROPERTY_INTEREST_RATE_COLUMN_NUMBER);
									map.put("intro-balance-transfer-rate",PROPERTY_INTRO_BALANCE_TRANSFER_RATE_COLUMN_NUMBER);
									map.put("intro-balance-transfer-rate-period",PROPERTY_INTRO_BALANCE_TRANSFER_RATE_PERIOD_COLUMN_NUMBER);

									map.put("balance-transfer-rate",PROPERTY_BALANCE_TRANSFER_RATE_COLUMN_NUMBER);
									map.put("balance-transfer-fee",PROPERTY_BALANCE_TRANSFER_FEE_COLUMN_NUMBER);

									map.put("intro-annual-fee",PROPERTY_INTRO_ANNUAL_FEE_COLUMN_NUMBER);
									map.put("intro-annual-fee-period",PROPERTY_INTRO_ANNUAL_FEE_PERIOD_COLUMN_NUMBER);

									map.put("annual-fee",PROPERTY_ANNUAL_FEE_COLUMN_NUMBER);
									map.put("cash-advance-rate",PROPERTY_CASH_ADVANCE_COLUMN_NUMBER);
									map.put("product-desc",PROPERTY_LONG_DESC_COLUMN_NUMBER);
									map.put("interest-free-days",PROPERTY_INTEREST_FREE_DAYS_COLUMN_NUMBER);

									map.put("minimum-income",PROPERTY_MINIMUM_INCOME_COLUMN_NUMBER);
									map.put("minimum-credit-limit",PROPERTY_MINIMUM_CREDIT_LIMIT_COLUMN_NUMBER);
									map.put("maximum-credit-limit",PROPERTY_MAXIMUM_CREDIT_LIMIT_COLUMN_NUMBER);
									map.put("minimum-monthly-repayment",PROPERTY_MINIMUM_MONTHLY_REPAYMENT_COLUMN_NUMBER);

									map.put("late-payment-fee",PROPERTY_LATE_PAYMENT_FEE_COLUMN_NUMBER);
									map.put("additional-card-holder",PROPERTY_ADDITIONAL_CARD_HOLDER_COLUMN_NUMBER);
									map.put("foreign-exchange-fees",PROPERTY_FOREIGN_EXCHANGE_FEES_COLUMN_NUMBER);
									map.put("complimentary-travel-insurance",PROPERTY_COMPLIMENTARY_TRAVEL_INSURANCE_COLUMN_NUMBER);
									map.put("extended-warranty",PROPERTY_EXTENDED_WARRANTY_COLUMN_NUMBER);
									map.put("available-temporary-residents",PROPERTY_AVAILABLE_TEMPORARY_RESIDENTS_COLUMN_NUMBER);

									map.put("rewards-desc",PROPERTY_REWARDS_DESC_COLUMN_NUMBER);
									//map.put("rewards-standard-card-class",PROPERTY_REWARDS_CARD_CLASS_COLUMN_NUMBER);
									map.put("rewards-standard-card-points",PROPERTY_REWARDS_STANDARD_POINTS_COLUMN_NUMBER);
									map.put("rewards-amex-card-points",PROPERTY_REWARDS_AMEX_POINTS_COLUMN_NUMBER);
									map.put("rewards-bonus-points",PROPERTY_BONUS_POINTS_COLUMN_NUMBER);
									map.put("terms-interest-rate",PROPERTY_INTEREST_RATE_TERMS_COLUMN_NUMBER);
									map.put("terms-rewards",PROPERTY_REWARDS_TERMS_COLUMN_NUMBER);
									map.put("terms-balance-transfer",PROPERTY_BALANCE_TRANSFER_TERMS_COLUMN_NUMBER);
									map.put("terms-other-features",PROPERTY_OTHER_FEATURES_TERMS_COLUMN_NUMBER);
									map.put("terms-general",PROPERTY_GENERAL_TERMS_COLUMN_NUMBER);
									map.put("special-offer",PROPERTY_SPECIAL_OFFER_COLUMN_NUMBER);
									map.put("other-features",PROPERTY_OTHER_FEATURES_COLUMN_NUMBER);
									map.put("categories",PROPERTY_CATEGORIES_COLUMN_NUMBER);
									map.put("handover-url",PROPERTY_HANDOVER_URL_COLUMN_NUMBER);

									for (String key : map.keySet()){

										int idx = map.get(key);

										if (idx < part.length && !(part[idx].equals(""))) {

											//see if the variable actually needs a currency format
											String formatted = "";

											switch(idx) {
												case 8:
												case 9:
												case 10:
												case 11:
												case 12:
												case 13:
												case 14:
												case 15:
												case 16:
												case 17:
												case 18:
												case 19:
												case 20:
												case 21:
												case 36:
												case 37:
												case 38:
												case 39:
												case 40:
												case 41:
													if(part[idx].equals("N/A")) {
														part[idx] = part[idx].replaceAll("N/A", "");
														formatted = "NULL";
													} else {
														part[idx] = part[idx].replaceAll(",", "");

														Pattern p = Pattern.compile("([\\d\\.,]+)");
														Matcher m = p.matcher(part[idx]);
														double j = 0.0;
														if (m.find()) {
															j = Double.valueOf(m.group(1));
														}
														formatted = String.valueOf(j);
													}
													break;
												case 31:
												case 32:
												case 33:
												case 34:
												case 35:
													if (part[idx].equals("Yes")) {
														formatted = "1";
													} else {
														formatted = "0";
													}
													break;
												default:
													if(part[idx].equals("N/A")) {
														formatted = "NULL";
													} else {
														formatted = "0";
													}
													part[idx] = part[idx].replaceAll("N/A", "");
													break;
											}

												switch(idx) {
												case 42:

													update.append("DELETE FROM ctm.category_product_mapping WHERE productId = @product_id;\r\n");
													update.append("INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM category_master WHERE categoryCode IN ('"+part[idx].replaceAll(",", "','")+"');\r\n");

													break;
												case 24:
												case 25:
												case 26:
												case 27:
												case 28:
												case 29:
												case 30:
													update.append("INSERT INTO ctm.product_properties_text VALUES(@product_id,'"+key+"',"+sequenceNo+",'"+part[idx]+"','"+effectiveDate+"','2040-12-31','');\r\n");
													break;
												default:
													update.append("INSERT INTO ctm.product_properties VALUES(@product_id,'"+key+"',"+sequenceNo+","+formatted+",'"+part[idx]+"',NULL,'"+effectiveDate+"','2040-12-31','',0);\r\n");
													break;
											}

										}
									}
							}
						}

						line = lineNext;
					}
					while(((lineNext = in.readLine()) != null) || line != null);

					in.close();

		}
		catch(IOException e) {

		}
		return update.toString();

	}
}