package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.IsoLocations;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Fetches the list of countries from ctm.country_master
 */
public class IsoLocationsDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(IsoLocationsDao.class);

    public IsoLocationsDao() {
    }

    /**
     * Fetch countries from the ctm.country_master table.
     * Optional search by countryName%
     * Better searching may be available if we used SOUNDEX or moved this table to elastic search and enabled fuzzy matching.
     * @param searchString Optional
     * @return
     * @throws DaoException
     */
    public ArrayList<IsoLocations> getIsoLocations(String searchString) throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        ArrayList<IsoLocations> countries = new ArrayList<IsoLocations>();

        try {
            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt;

            stmt = dbSource.getConnection().prepareStatement(
                    buildQuery(searchString)
            );

            if(searchString != null && searchString.length() > 0) {
                stmt.setString(1, searchString);
                stmt.setString(2, searchString);
                stmt.setString(3, searchString);
            }
            ResultSet resultSet = stmt.executeQuery();

            while (resultSet.next()) {
                IsoLocations country = new IsoLocations();
                country.setIsoCode(resultSet.getString("isoCode"));
                country.setCountryName(resultSet.getString("countryName"));
                countries.add(country);
            }

            if (countries.size() == 0) {
                LOGGER.debug("No countries available {}", kv("searchString", searchString));
            }

        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
        return countries;
    }

    /**
     * Note: This query should be moved to something like elastic search when the number of records reaches
     * around 5,000-10,000.
     */
    private String buildQuery(String searchString) {

        String stmt;

        if(searchString != null && searchString.length() > 0) {
            stmt = "SELECT * FROM (" +
                    "SELECT DISTINCT isoCode AS `isoCode`, countryName " +
                        "FROM ctm.country_master LEFT JOIN ctm.country_search_terms ON isoCode = searchTermsIsoCode" +
                        " WHERE countryName LIKE ? OR searchTerm LIKE  ? " +
                    "UNION ALL " +
                    "SELECT countryIsoCode AS isoCode, CONCAT(subdivisionName, ' (', countryName,')')  AS countryName " +
                        "FROM ctm.country_master LEFT JOIN ctm.country_subdivisions ON isoCode=countryIsoCode " +
                    "WHERE subdivisionName LIKE ? ) as ALLCOUNTRIES " +
                    "ORDER BY countryName ASC ";
        } else {
            stmt = "SELECT DISTINCT isoCode AS `isoCode`, countryName " +
                    "FROM ctm.country_master ORDER BY countryName ASC";
        }

        return stmt;
    }

    /**
     *
     * @param isoCodes
     * @return
     */
    public ArrayList<IsoLocations> getCountriesByIsoCodes(List<String> isoCodes) throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        ArrayList<IsoLocations> countries = new ArrayList<IsoLocations>();

        try {
            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt;

            stmt = dbSource.getConnection().prepareStatement(
                    buildQuery(isoCodes)
            );

            int counter = 1;
            for(String code: isoCodes){
                stmt.setString(counter, code);
                counter++;
            }

            ResultSet resultSet = stmt.executeQuery();

            while (resultSet.next()) {
                IsoLocations country = new IsoLocations();
                country.setIsoCode(resultSet.getString("isoCode"));
                country.setCountryName(resultSet.getString("countryName"));
                countries.add(country);
            }

            if (countries.size() == 0) {
                LOGGER.debug("No countries available {}", kv("isoCodes", isoCodes));
            }

        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
        return countries;
    }

    private String buildQuery(List<String> isoCodes) {

        String stmt = "SELECT isoCode, countryName " +
                "FROM ctm.country_master ";
        if(isoCodes != null && isoCodes.size() > 0) {
            stmt += " WHERE isoCode IN("+SimpleDatabaseConnection.createSqlArrayParams(isoCodes.size())+")";
        }
        stmt += " ORDER BY countryName ASC";
        return stmt;
    }
    
}
