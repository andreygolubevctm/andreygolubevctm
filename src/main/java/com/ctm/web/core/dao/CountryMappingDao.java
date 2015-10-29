package com.ctm.web.core.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.CountryMapping;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class CountryMappingDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(CountryMappingDao.class);
	// TODO: Add styleCodeId and isActive and combine with ProviderCodes DAO in e.g. a get query string method.
	// add to router as well
	public ArrayList<CountryMapping> getMapping(String selectedCountries) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		String[] countries = selectedCountries.split(",");
		ArrayList<CountryMapping> providerCountries = new ArrayList<>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			// the IF statement for 1COV and 1FOW is due to xpaths not liking the numeric value at the start
			stmt = dbSource.getConnection().prepareStatement(
				"SELECT IF(providerCode = '1COV' OR providerCode = '1FOW' OR providerCode = '30UN', IF(providerCode = '1COV', 'COVR', IF(providerCode = '1FOW', 'FFOW', 'UN30')), providerCode) AS providerCode, \n" +
						"productGroup, \n" +
						"\tIF(countryValue IS NULL or countryValue = '', '', GROUP_CONCAT(countryValue ORDER by priority ASC)) AS selectedCountries, \n" +
						"    IF(countryValue IS NULL or countryValue = '', 'N', 'Y') AS hasCountries, \n" +
						"    IF(regionValue IS NULL or regionValue = '', '', GROUP_CONCAT(regionValue ORDER by priority ASC)) AS selectedRegions, \n" +
						"    IF(regionValue IS NULL or regionValue = '', 'N', 'Y') AS hasRegions, \n" +
						"    IF(handoverValue IS NULL or handoverValue = '', '', GROUP_CONCAT(handoverValue  ORDER by priority ASC)) AS handoverMappings, " +
						"    IF(handoverValue IS NULL or handoverValue = '', 'N', 'Y') AS hasHandoverValue, " +
						"	 IF (COUNT(isoCode) = "+countries.length+", 'Y', 'N')  AS isAvailable "+
						"FROM ctm.country_provider_mapping  cpm\n" +
						"INNER JOIN ctm.provider_master pm ON pm.providerId = cpm.providerId\n" +
						"WHERE isoCode IN ("+SimpleDatabaseConnection.createSqlArrayParams(countries.length)+") \n" +
						"AND priority != 300 -- this means they do not provider quotes for this country\n" +
						"GROUP BY cpm.providerId, cpm.productGroup\n" +
						"ORDER by priority ASC;"
			);

			for (int i = 0; i < countries.length; i++) {
				stmt.setString((i + 1), countries[i]);
			}

			ResultSet countryMappingResult = stmt.executeQuery();

			while (countryMappingResult.next()) {
				// this bit of code prevents a quote being shown for providers that do not provider a quote to countries that are not eligible. This includes countries
				// that are selected as part of a multi-selection or as a single destination
				if (countryMappingResult.getString("isAvailable").charAt(0) == 'Y') {

					CountryMapping mappedEntries = new CountryMapping();
					mappedEntries.setProviderCode(countryMappingResult.getString("providerCode"));
					mappedEntries.setProductGroup(countryMappingResult.getInt("productGroup"));
					mappedEntries.setSelectedCountries(countryMappingResult.getString("selectedCountries"));
					mappedEntries.setHasCountries(countryMappingResult.getString("hasCountries").charAt(0));
					mappedEntries.setSelectedRegions(countryMappingResult.getString("selectedRegions"));
					mappedEntries.setHasRegions(countryMappingResult.getString("hasRegions").charAt(0));
					mappedEntries.setHandoverMappings(countryMappingResult.getString("handoverMappings"));
					mappedEntries.setHasHandoverValues(countryMappingResult.getString("hasHandoverValue").charAt(0));

					providerCountries.add(mappedEntries);
				}
			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("failed getting country mapping for {}", kv("selectedCountries", selectedCountries), e);
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return providerCountries;
	}

	// retrieve the country names from the selected ISO codes
	public CountryMapping getSelectedCountryNames(String selectedISOCodes) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		CountryMapping userSelectedCountries = null;

		String[] countryISOCodes = selectedISOCodes.split(",");
		String sqlPlaceholders = SimpleDatabaseConnection.createSqlArrayParams(countryISOCodes.length);

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			// Select the countries selected by the user in the same order that the user selected
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT GROUP_CONCAT(countryName ORDER BY FIELD (isoCode, "+sqlPlaceholders+")) AS selectedCountries \n" +
					"FROM ctm.country_master \n" +
					"WHERE isoCode IN ("+sqlPlaceholders+");"
			);

			for (int i = 0; i < countryISOCodes.length; i++) {
				stmt.setString((i + 1), countryISOCodes[i]);
				stmt.setString((i +countryISOCodes.length + 1), countryISOCodes[i]);
			}

			ResultSet countryMappingResult = stmt.executeQuery();
			userSelectedCountries = new CountryMapping();

			while (countryMappingResult.next()) {
				userSelectedCountries.setSelectedCountries(countryMappingResult.getString("selectedCountries"));
			}
		} catch (SQLException | NamingException e) {
			LOGGER.error("failed getting country mapping {}", kv("selectedISOCodes", selectedISOCodes), e);
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return userSelectedCountries;
	}
}
