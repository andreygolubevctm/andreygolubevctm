package com.ctm.web.simples.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.text.WordUtils;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

public class MessageDetailDao {
	private static String FAMILY_TYPE_SINGLE = "single";
	private static String FAMILY_TYPE_COUPLE = "familyOrCouple";
	private static String RESULT_PATH_HOSPITAL = "hospital";
	private static String RESULT_PATH_EXTRA = "extras";
	private static String XPATH_EMAIL = "health/contactDetails/email";
	private static String XPATH_ADDRESS = "health/application/address/fullAddress";
	private static String XPATH_COVER_TYPE = "health/situation/coverType";
	private static String XPATH_CAT_SELECT_HOSPITAL = "health/benefits/categorySelectHospital";
	private static String XPATH_QUICK_SELECT_HOSPITAL = "health/benefits/quickSelectHospital";
	private static String XPATH_CAT_SELECT_EXTRA= "health/benefits/categorySelectExtras";
	private static String XPATH_BENEFIT_SOURCE= "health/hospitalBenefitsSource";

	public static SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

	public Map<String,String> getHealthProperties(long transactionId) throws DaoException {
		Map<String,String> properties = new HashMap<>();

		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT xpath, textValue, resultPath, name FROM aggregator.transaction_details " +
							"LEFT JOIN aggregator.features_details fd ON fd.shortlistKey = " +
							"case when locate('health/benefits/benefitsExtras/', xpath) > 0 then REPLACE(SUBSTRING(xpath, length('health/benefits/benefitsExtras/')+1), '/', '_') else null end AND " +
							"fd.vertical = (" +
							"select case when not exists(select 1 from aggregator.transaction_details ad2 where ad2.transactionId = ? " + // 1
							"and ad2.xpath = ? and ad2.textValue = 'CLINICAL_CATEGORIES') then 'health2018' " + // 2
							"when exists(select 1 from aggregator.transaction_details ad2 where ad2.transactionId = ? " + // 3
							"and ad2.xpath = ? and ad2.textValue = 'CLINICAL_CATEGORIES') then 'health_cc' end as healthVer " + // 4
							") and fd.status = '1'" +
							"WHERE (xpath LIKE 'health/benefits/benefitsExtras/%' OR xpath IN ('health/situation/healthCvr', 'health/situation/healthSitu', " +
							"'health/healthCover/primary/dob', 'health/healthCover/incomelabel', 'health/healthCover/income', ?, ?," + // 5 6
							"'health/application/primary/dob', ?, ?, ?, ?, ?)) " + // 7 - 11
							"AND transactionId = ? " + // 12
							"UNION ALL " +
							"SELECT tf.fieldCode as xpath, textValue, fd.resultPath, fd.name FROM aggregator.transaction_details2_cold tdc " +
							"INNER JOIN aggregator.transaction_fields tf ON tf.fieldId = tdc.fieldId " +
							"LEFT JOIN aggregator.features_details fd ON fd.shortlistKey = " +
							"case when locate('health/benefits/benefitsExtras/', tf.fieldCode) > 0 then REPLACE(SUBSTRING(tf.fieldCode, length('health/benefits/benefitsExtras/')+1), '/', '_') else null end AND " +
							"fd.vertical = (" +
							"select case when not exists(select 1 from aggregator.transaction_details ad2 where ad2.transactionId = ? " + // 13
							"and ad2.xpath = ? and ad2.textValue = 'CLINICAL_CATEGORIES') then 'health2018' " + // 14
							"when exists(select 1 from aggregator.transaction_details ad2 where ad2.transactionId = ? " + // 15
							"and ad2.xpath = ? and ad2.textValue = 'CLINICAL_CATEGORIES') then 'health_cc' end as healthVer " + // 16
							") and fd.status = '1'" +
							"WHERE " +
							"(tf.fieldCode LIKE 'health/benefits/benefitsExtras/%' OR tf.fieldCode IN ('health/situation/healthCvr', 'health/situation/healthSitu', 'health/healthCover/primary/dob', 'health/healthCover/incomelabel', ?, ?,'health/application/primary/dob')) " + // 17 18
							"AND transactionId = ? " + // 19
							"ORDER BY xpath"
			);

			stmt.setLong(1, transactionId);
			stmt.setString(2, XPATH_BENEFIT_SOURCE);
			stmt.setLong(3, transactionId);
			stmt.setString(4, XPATH_BENEFIT_SOURCE);
			stmt.setString(5, XPATH_EMAIL);
			stmt.setString(6, XPATH_ADDRESS);
			stmt.setString(7, XPATH_COVER_TYPE);
			stmt.setString(8, XPATH_CAT_SELECT_HOSPITAL);
			stmt.setString(9, XPATH_QUICK_SELECT_HOSPITAL);
			stmt.setString(10, XPATH_CAT_SELECT_EXTRA);
			stmt.setString(11, XPATH_BENEFIT_SOURCE);
			stmt.setLong(12, transactionId);
			stmt.setLong(13, transactionId);
			stmt.setString(14, XPATH_BENEFIT_SOURCE);
			stmt.setLong(15, transactionId);
			stmt.setString(16, XPATH_BENEFIT_SOURCE);
			stmt.setString(17, XPATH_EMAIL);
			stmt.setString(18, XPATH_ADDRESS);
			stmt.setLong(19, transactionId);

			final ResultSet results = stmt.executeQuery();

			String situationValue = "";
			String coverValue = "";
			List<String> benefitsHospitalsValue = new LinkedList<>();
			List<String> benefitsExtrasValue = new LinkedList<>();
			String familyType = "";

			while (results.next()) {
				String key = results.getString("xpath");
				String value = results.getString("textValue");
				String resultPath = results.getString("resultPath");
				String name = results.getString("name");

				if (key.equals("health/situation/healthCvr")) {
					switch(value) {
						case "S": coverValue = "Single"; familyType = FAMILY_TYPE_SINGLE; break;
						case "SM": coverValue = "Single - Male"; familyType = FAMILY_TYPE_SINGLE; break;
						case "SF": coverValue = "Single - Female"; familyType = FAMILY_TYPE_SINGLE; break;
						case "C": coverValue = "Couple"; familyType = FAMILY_TYPE_COUPLE; break;
						case "F": coverValue = "Family"; familyType = FAMILY_TYPE_COUPLE; break;
						case "SPF": coverValue = "Single Parent Family"; familyType = FAMILY_TYPE_COUPLE; break;
						default: coverValue = value;
					}
					continue;
				}
				else if (key.equals("health/situation/healthSitu")) {
					switch(value) {
						case "LC": situationValue = "Compare my options"; break;
						case "LBC": situationValue = "Replace my current cover"; break;
						case "CSF": situationValue = "Grow my family"; break;
						case "ATP": situationValue = "Reduce taxes and penalties"; break;
						default: situationValue = value;
					}
					continue;
				}
				else if(key.equals("health/application/primary/dob")) {
					key = "Primary DOB";
				}
				else if(key.equals("health/healthCover/primary/dob")) {
					key = "Primary DOB";
					if(properties.containsKey(key)){
						continue;
					}
				}
				else if (key.equals("health/healthCover/incomelabel") || key.equals("health/healthCover/income")) {
					key = "Income level";
				}
				else if (key.startsWith("health/benefits/benefitsExtras/")) {

					value = key.replace("health/benefits/benefitsExtras/", "");
					switch(value) {
						case "GeneralHealth": name = "General Health"; resultPath = RESULT_PATH_EXTRA; break;
						case "Hospital": name = "HOSPITAL"; resultPath = RESULT_PATH_HOSPITAL; break;
						case "PrHospital": name = "Private Hospital"; resultPath = RESULT_PATH_HOSPITAL; break;
						case "PuHospital": name = "Private Patient in Public Hospital"; resultPath = RESULT_PATH_HOSPITAL; break;
						case "DentalGeneral": name = "General Dental"; resultPath = RESULT_PATH_EXTRA; break;
					}
					if(StringUtils.isNotBlank(resultPath)) {
						if(resultPath.contains(RESULT_PATH_HOSPITAL)) {
							benefitsHospitalsValue.add(name.toUpperCase(Locale.ROOT));
						} else {
							benefitsExtrasValue.add(WordUtils.capitalize(name));
						}
					}
					continue;
				}
				else if (key.equals(XPATH_EMAIL)) {
					key = "Email";
				}
				else if (key.equals(XPATH_ADDRESS)) {
					key = "Address";
				}
				else if (key.equals(XPATH_COVER_TYPE)) {
					key = "Product type";
				}
				else if (key.equals(XPATH_CAT_SELECT_HOSPITAL)) {
					key = "Reason";
				}
				else if (key.equals(XPATH_QUICK_SELECT_HOSPITAL)) {
					key = "Hospital quick selects";
				}
				else if (key.equals(XPATH_CAT_SELECT_EXTRA)) {
					key = "Extras quick selects";
				}
				else if (key.equals(XPATH_BENEFIT_SOURCE)) {
					key = "Benefits source";
				}

				// General property
				properties.put(key, value);
			}

			// Special case for combined values
			String benefitsHospitals = benefitsHospitalsValue.stream().sorted().collect(Collectors.joining(", "));
			String benefitsExtras = benefitsExtrasValue.stream().sorted().collect(Collectors.joining(", "));
			String separator = StringUtils.isNotBlank(benefitsHospitals) && StringUtils.isNotBlank(benefitsExtras) ? "; " : "";
			String benefits = benefitsHospitals + separator + benefitsExtras;
			properties.put("Situation", coverValue + " - " + situationValue);
			properties.put("Benefits", benefits);
			properties.put("Family Type", familyType);
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return properties;
	}
}
