package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Random;


public class ProviderCodesDao {

	private SimpleDatabaseConnection dbSource;
	private int maxProviders = 9;
	private int providerCodesSize = 0;
	private ArrayList<String> providerCodes;

	public ProviderCodesDao() {
		dbSource = new SimpleDatabaseConnection();
		providerCodes = new ArrayList<String>();
	}

	public void setProviderCodes(String verticalType, int styleCodeId) throws DaoException {
		try {
			// PageSettings pageSettings = pageSettings.getVertical().getType();

			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();

			if(conn != null) {

				stmt = dbSource.getConnection().prepareStatement(
					"SELECT providerCode FROM ctm.stylecode_providers WHERE verticalCode = ? AND stylecodeId = ? AND providerId IN (SELECT DISTINCT (ProviderId) AS providerids FROM ctm.stylecode_products WHERE productCat = ?) AND Status != 'X' AND CURRENT_DATE BETWEEN EffectiveStart AND EffectiveEnd"
				);

				stmt.setString(1, verticalType);
				stmt.setInt(2, styleCodeId);
				stmt.setString(3, verticalType);

				ResultSet results = stmt.executeQuery();

				while (results.next()) {
					providerCodes.add(results.getString("providerCode"));
				}

				providerCodesSize = providerCodes.size();
			}
		} catch (SQLException e) {
			throw new DaoException(e);
		} catch (NamingException e) {
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}
	}

	public void setMaxProviders(int maxProviders) {
		this.maxProviders = maxProviders;
	}

	public ArrayList<String> getMaxProviderCodes() {
		Random randomGenerator = new Random(); // random number generator
		ArrayList<String> tempProviderCodes = new ArrayList<String>(); // temp provider codes arraylist
		String element; // chosen element
		int i = 0; // while loop index
		int randomIndex = 0; // random number generated

		if (providerCodesSize > 0) {
			while (i < this.maxProviders) {
				randomIndex = randomGenerator.nextInt(providerCodesSize); // generate a random number
				element = providerCodes.get(randomIndex); // retrieve the element at this position

				if (!tempProviderCodes.contains(element) && element != null) // check if this element has already been added
				{
					tempProviderCodes.add(element);
					i++;
				}
			}
		}

		return tempProviderCodes;
	}

	public ArrayList<String> getAllProviderCodes()
	{
		return providerCodes;
	}
}
