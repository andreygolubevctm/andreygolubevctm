package com.ctm.dao.simples;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

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
					"(xpath LIKE 'health/benefits/benefitsExtras/%' OR xpath IN ('health/situation/healthCvr', 'health/situation/healthSitu', 'health/healthCover/primary/dob', 'health/healthCover/incomelabel')) " +
					"AND transactionId = ? " +
					"ORDER BY xpath"
			);
			stmt.setLong(1, transactionId);
			final ResultSet results = stmt.executeQuery();

			String situationValue = "";
			String coverValue = "";
			StringBuilder benefitsValue = null;

			while (results.next()) {
				String key = results.getString("xpath");
				String value = results.getString("textValue");

				if (key.equals("health/situation/healthCvr")) {
					switch(value) {
						case "S": coverValue = "Single"; break;
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
				else if (key.equals("health/healthCover/primary/dob")) {
					key = "Primary DOB";
				}
				else if (key.equals("health/healthCover/incomelabel")) {
					key = "Income level";
				}
				else if (key.startsWith("health/benefits/")) {
					if (benefitsValue == null) {
						benefitsValue = new StringBuilder();
					}
					else {
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

				// General property
				properties.put(key, value);
			}

			// Special case for combined values
			properties.put("Situation", coverValue + " - " + situationValue);
			properties.put("Benefits", benefitsValue.toString());
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return properties;
	}
}
