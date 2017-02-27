package com.ctm.web.creditcards.services.creditcards;

import au.com.bytecode.opencsv.CSVReader;
import com.ctm.web.creditcards.model.UploadRequest;

import java.io.*;
import java.util.*;
import java.util.regex.*;

public class UploadService {

    private static final char SINGLE_QUOTE = '\'';
    private static final Pattern REMOVE_QUOTED = Pattern.compile("^\"|\"$");
	private static final Pattern MATCH_QUOTE = Pattern.compile("\\p{Pf}|\\p{Pi}");
	private static final Pattern MATCH_DASH = Pattern.compile("\\p{Pd}");
	private static final Pattern MATCH_SPACE = Pattern.compile("\\p{Zs}");

    private static final int PRODUCT_CODE_COLUMN_NUMBER = 0;
    //int PROVIDER_NAME_COLUMN_NUMBER = 1;

    private static final int PROPERTY_SLUG_COLUMN_NUMBER = 2;
    private static final int PROPERTY_META_PAGE_COLUMN_NUMBER = 3;
    private static final int PROPERTY_META_PAGE_DESC_COLUMN_NUMBER = 4;
    private static final int PRODUCT_SHORT_DESC_COLUMN_NUMBER = 5;
    private static final int PROPERTY_TYPE_COLUMN_NUMBER = 6;
    private static final int PROPERTY_CARD_CLASS_COLUMN_NUMBER = 7;

    private static final int PROPERTY_INTRO_INTEREST_RATE_COLUMN_NUMBER = 8;
    private static final int PROPERTY_INTRO_INTEREST_RATE_PERIOD_COLUMN_NUMBER = 9;
    private static final int PROPERTY_INTEREST_RATE_COLUMN_NUMBER = 10;
    private static final int PROPERTY_INTRO_BALANCE_TRANSFER_RATE_COLUMN_NUMBER = 11;
    private static final int PROPERTY_INTRO_BALANCE_TRANSFER_RATE_PERIOD_COLUMN_NUMBER = 12;
    private static final int PROPERTY_BALANCE_TRANSFER_RATE_COLUMN_NUMBER = 13;
    private static final int PROPERTY_BALANCE_TRANSFER_FEE_COLUMN_NUMBER = 14;
    private static final int PROPERTY_INTRO_ANNUAL_FEE_COLUMN_NUMBER = 15;
    private static final int PROPERTY_INTRO_ANNUAL_FEE_PERIOD_COLUMN_NUMBER = 16;
    private static final int PROPERTY_ANNUAL_FEE_COLUMN_NUMBER = 17;
    private static final int PROPERTY_CASH_ADVANCE_COLUMN_NUMBER = 18;


    //int PROPERTY_REWARDS_CARD_CLASS_COLUMN_NUMBER = 0;
    private static final int PROPERTY_REWARDS_STANDARD_POINTS_COLUMN_NUMBER = 19;
    private static final int PROPERTY_REWARDS_AMEX_POINTS_COLUMN_NUMBER = 20;
    private static final int PROPERTY_BONUS_POINTS_COLUMN_NUMBER = 21;

    private static final int PROPERTY_SPECIAL_OFFER_COLUMN_NUMBER = 22;
    private static final int PROPERTY_LONG_DESC_COLUMN_NUMBER = 23;
    private static final int PROPERTY_REWARDS_DESC_COLUMN_NUMBER = 24;
    private static final int PROPERTY_OTHER_FEATURES_COLUMN_NUMBER = 25;
    private static final int PROPERTY_INTEREST_RATE_TERMS_COLUMN_NUMBER = 26;
    private static final int PROPERTY_REWARDS_TERMS_COLUMN_NUMBER = 27;
    private static final int PROPERTY_BALANCE_TRANSFER_TERMS_COLUMN_NUMBER = 28;
    private static final int PROPERTY_OTHER_FEATURES_TERMS_COLUMN_NUMBER = 29;
    private static final int PROPERTY_GENERAL_TERMS_COLUMN_NUMBER = 30;

    private static final int PROPERTY_ADDITIONAL_CARD_HOLDER_COLUMN_NUMBER = 31;
    private static final int PROPERTY_FOREIGN_EXCHANGE_FEES_COLUMN_NUMBER = 32;
    private static final int PROPERTY_COMPLIMENTARY_TRAVEL_INSURANCE_COLUMN_NUMBER = 33;
    private static final int PROPERTY_EXTENDED_WARRANTY_COLUMN_NUMBER = 34;
    private static final int PROPERTY_AVAILABLE_TEMPORARY_RESIDENTS_COLUMN_NUMBER = 35;
    private static final int PROPERTY_INTEREST_FREE_DAYS_COLUMN_NUMBER = 36;
    private static final int PROPERTY_LATE_PAYMENT_FEE_COLUMN_NUMBER = 37;

    private static final int PROPERTY_MINIMUM_INCOME_COLUMN_NUMBER = 38;
    private static final int PROPERTY_MINIMUM_CREDIT_LIMIT_COLUMN_NUMBER = 39;
    private static final int PROPERTY_MAXIMUM_CREDIT_LIMIT_COLUMN_NUMBER = 40;
    private static final int PROPERTY_MINIMUM_MONTHLY_REPAYMENT_COLUMN_NUMBER = 41;
    private static final int PROPERTY_CATEGORIES_COLUMN_NUMBER = 42;
    private static final int PROPERTY_HANDOVER_URL_COLUMN_NUMBER = 43;
    private static final int PROPERTY_BONUS_POINTS_TYPE = 44;



	public static String getRates(UploadRequest file) {

		StringBuilder update = new StringBuilder();

		String providerCode = file.providerCode;
		String effectiveDate = file.effectiveDate;

		try {

			if(providerCode.isEmpty()) {
				throw new RuntimeException("FATAL ERROR: Provider ID not found.");
			}

            append(update, "USE ctm;\r\n\r\n", "-- Get Provider ID from Provider Code\r\n");
            append(update, "SET @provider_id = (SELECT providerId FROM ctm.provider_master WHERE providerCode = '"+providerCode+"');\r\n\r\n", "-- Create temporary table of product ids\r\n");
            append(update, "CREATE TEMPORARY TABLE _products SELECT productid FROM ctm.product_master WHERE productCat='CREDITCARD' AND providerid=@provider_id;\r\n\r\n", "-- Should return less than 12 products for most providers\r\n");
            append(update, "SELECT * FROM _products;\r\n\r\n", "-- Delete using join with temporary table\r\n");
            append(update, "DELETE cpm FROM ctm.category_product_mapping cpm INNER JOIN _products ON cpm.productID=_products.productId;\r\n", "DELETE pp FROM ctm.product_properties pp INNER JOIN _products ON pp.productID=_products.productId;\r\n");
            append(update, "DELETE ppt FROM ctm.product_properties_text ppt INNER JOIN _products ON ppt.productID=_products.productId;\r\n", "DELETE pm FROM ctm.product_master pm INNER JOIN _products ON pm.productID=_products.productId;\r\n\r\n");

            append(update, "-- Clean up\r\n", "DROP TEMPORARY TABLE _products;\r\n");
            CSVReader reader = new CSVReader(new InputStreamReader(file.uploadedStream));
            HashMap<String, Integer> map = new HashMap<>();

			String productCode = "";
			String prevProductCode = "";
			int sequenceNo = 0;
			String[] part;

			// Get the header
            reader.readNext();

			// Get first line
            part = reader.readNext();
            String[] lineNext = part;


			do {
				for(int i = 0; i< (part != null ? part.length : 0); i++){
					part[i] = replaceUnicodeCharactersInLine(part[i]);
					part[i] = part[i].trim();
				}

                assert part != null;
                if(part.length > 0){

                    createInsertProductMaster(update, effectiveDate, part);

                    if (!productCode.equals(prevProductCode)){
						prevProductCode = productCode;
					}

                    createMap(map);

					for (String key : map.keySet()){

						int idx = map.get(key);

						if (idx < part.length && !(part[idx].equals(""))) {
                            createInsert(update, effectiveDate, sequenceNo, part, key, idx);

                        }
					}
				}

                part = lineNext;
			}
			while(((lineNext = reader.readNext()) != null) || part != null);

            reader.close();

		}
		catch(IOException e) {
			throw new RuntimeException("Uploaded file error.", e);
		}
		return update.toString();

	}

    private static void createInsert(StringBuilder update, String effectiveDate, int sequenceNo,
                                     String[] part, String key, int idx) {
        String formatted = formatValue(part, idx);
        switch(idx) {
            case 42:
                update.append("INSERT INTO ctm.category_product_mapping (categoryId, productId) SELECT categoryId, @product_id FROM ctm.category_master WHERE categoryCode IN ('").append(part[idx].replaceAll(",", "','")).append("');\r\n");

                break;
            case 24:
            case 25:
            case 26:
            case 27:
            case 28:
            case 29:
            case 30:
                update.append("INSERT INTO ctm.product_properties_text VALUES(@product_id,'").append(key).append("',").append(sequenceNo).append(",'").append(part[idx]).append("','").append(effectiveDate).append("','2040-12-31','');\r\n");
                break;
            default:
                update.append("INSERT INTO ctm.product_properties VALUES(@product_id,'").append(key).append("',").append(sequenceNo).append(",").append(formatted).append(",'").append(part[idx]).append("',NULL,'").append(effectiveDate).append("','2040-12-31','',0);\r\n");
                break;
        }
    }

    private static String formatValue(String[] part, int idx) {
        //see if the variable actually needs a currency format
        String formatted;

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
        return formatted;
    }

    private static void createMap(HashMap<String, Integer> map) {
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
        map.put("rewards-bonus-points-type",PROPERTY_BONUS_POINTS_TYPE);

        map.put("terms-interest-rate",PROPERTY_INTEREST_RATE_TERMS_COLUMN_NUMBER);
        map.put("terms-rewards",PROPERTY_REWARDS_TERMS_COLUMN_NUMBER);
        map.put("terms-balance-transfer",PROPERTY_BALANCE_TRANSFER_TERMS_COLUMN_NUMBER);
        map.put("terms-other-features",PROPERTY_OTHER_FEATURES_TERMS_COLUMN_NUMBER);
        map.put("terms-general",PROPERTY_GENERAL_TERMS_COLUMN_NUMBER);
        map.put("special-offer",PROPERTY_SPECIAL_OFFER_COLUMN_NUMBER);
        map.put("other-features",PROPERTY_OTHER_FEATURES_COLUMN_NUMBER);
        map.put("categories",PROPERTY_CATEGORIES_COLUMN_NUMBER);
        map.put("handover-url",PROPERTY_HANDOVER_URL_COLUMN_NUMBER);
    }

    private static void createInsertProductMaster(StringBuilder update, String effectiveDate, String[] part) {
       String productCode = part[PRODUCT_CODE_COLUMN_NUMBER];
        String productShortDescription = part[PRODUCT_SHORT_DESC_COLUMN_NUMBER];
        append(update, "\r\n\r\nINSERT INTO ctm.product_master (ProductCat,ProductCode,ProviderId, " +
                "ShortTitle, " +
                "LongTitle,EffectiveStart,EffectiveEnd,Status) VALUES('CREDITCARD','" +
                productCode + "',@provider_id,'" +
                productShortDescription + "','" + productShortDescription +
                "','" + effectiveDate + "','2040-12-31','');\r\n", "SET @product_id = LAST_INSERT_ID();\r\n");
    }

    private static void append(StringBuilder update, String str, String str2) {
        update.append(str);
        update.append(str2);
    }

    private static String replaceUnicodeCharactersInLine(String line) {
        line = replaceMsCharacters(line) ;
		line = REMOVE_QUOTED.matcher(line).replaceAll("");
		line = MATCH_QUOTE.matcher(line).replaceAll("'");
		line = MATCH_DASH.matcher(line).replaceAll("-");
        line = MATCH_SPACE.matcher(line).replaceAll(" ");
        line = line.replaceAll("'-", "-");
        line = line.replaceAll("''","'").replaceAll("'","''");
        return line;
	}

    public static String replaceMsCharacters(String s) {
        s = s.replace( (char)145, SINGLE_QUOTE);
        s = s.replace( (char)8216, SINGLE_QUOTE); // left single quote
        s = s.replace( (char)146, SINGLE_QUOTE);
        s = s.replace( (char)65533, SINGLE_QUOTE);
        s = s.replace( (char)8217, SINGLE_QUOTE); // right single quote
        s = s.replace( (char)147, '\"');
        s = s.replace( (char)148, '\"');
        s = s.replace( (char)8220, '\"'); // left double
        s = s.replace( (char)8221, '\"'); // right double
        s = s.replace( (char)8211, '-');
        return s.replace( (char)65533, SINGLE_QUOTE);
    }
}
