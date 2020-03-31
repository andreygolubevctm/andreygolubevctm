package com.ctm.web.simples.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class MessageDetailDao {

	public Map<String,String> getHealthProperties(long transactionId) throws DaoException {
		Map<String,String> properties = new HashMap<>();

		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		try {
			final PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT xpath, textValue FROM aggregator.transaction_details WHERE " +
					"(xpath LIKE 'health/benefits/benefitsExtras/%' OR xpath IN ('health/situation/healthCvr', 'health/situation/healthSitu', 'health/healthCover/primary/dob', 'health/healthCover/incomelabel', 'health/contactDetails/email', 'health/application/address/fullAddress','health/application/primary/dob')) " +
					"AND transactionId = ? " +
				"UNION ALL " +
				"SELECT tf.fieldCode as xpath, textValue FROM aggregator.transaction_details2_cold tdc " +
				"INNER JOIN aggregator.transaction_fields tf ON tf.fieldId = tdc.fieldId " +
				"WHERE " +
					"(tf.fieldCode LIKE 'health/benefits/benefitsExtras/%' OR tf.fieldCode IN ('health/situation/healthCvr', 'health/situation/healthSitu', 'health/healthCover/primary/dob', 'health/healthCover/incomelabel', 'health/contactDetails/email', 'health/application/address/fullAddress','health/application/primary/dob')) " +
					"AND transactionId = ? " +
				"ORDER BY xpath"
			);
			stmt.setLong(1, transactionId);
			stmt.setLong(2, transactionId);

			final ResultSet results = stmt.executeQuery();

			String situationValue = "";
			String coverValue = "";
			StringBuilder benefitsValue = new StringBuilder();

			while (results.next()) {
				String key = results.getString("xpath");
				String value = results.getString("textValue");

				if (key.equals("health/situation/healthCvr")) {
					switch(value) {
						case "S": coverValue = "Single"; break;
						case "SM": coverValue = "Single - Male"; break;
						case "SF": coverValue = "Single - Female"; break;
						case "C": coverValue = "Couple"; break;
						case "F": coverValue = "Family"; break;
						case "SPF": coverValue = "Single Parent Family"; break;
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
				else if (key.equals("health/healthCover/incomelabel")) {
					key = "Income level";
				}
				else if (key.startsWith("health/benefits/")) {
					if (benefitsValue.length() > 0) {
						benefitsValue.append(", ");
					}
					value = key.replace("health/benefits/benefitsExtras/", "");
					switch(value) {
						case "PrHospital": value = "Private Hospital"; break;
						case "PuHospital": value = "Private Patient in Public Hospital"; break;
						case "DentalGeneral": value = "General Dental"; break;
					}
					benefitsValue.append(value);
					continue;
				}
				else if (key.equals("health/contactDetails/email")) {
					key = "Email";
				}
				else if (key.equals("health/application/address/fullAddress")) {
					key = "Address";
				}

				// General property
				properties.put(key, value);
			}

			// Special case for combined values
			properties.put("Situation", coverValue + " - " + situationValue);
			properties.put("Benefits", benefitsValue.toString());
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
