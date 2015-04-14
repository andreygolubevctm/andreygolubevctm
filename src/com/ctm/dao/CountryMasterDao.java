package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.CountryMaster;
import org.apache.log4j.Logger;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Fetches the list of countries from ctm.country_master
 */
public class CountryMasterDao {

    private static Logger logger = Logger.getLogger(CountryMasterDao.class.getName());

    public CountryMasterDao() {
    }

    /**
     * Fetch countries from the ctm.country_master table.
     * Optional search by countryName%
     * Better searching may be available if we used SOUNDEX or moved this table to elastic search and enabled fuzzy matching.
     * @param countryNameLike Optional
     * @return
     * @throws DaoException
     */
    public ArrayList<CountryMaster> getCountries(String countryNameLike) throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        ArrayList<CountryMaster> countries = new ArrayList<CountryMaster>();

        try {
            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt;

            stmt = dbSource.getConnection().prepareStatement(
                    buildQuery(countryNameLike)
            );

            if(countryNameLike != null && countryNameLike.length() > 0) {
                stmt.setString(1, countryNameLike);
            }

            ResultSet resultSet = stmt.executeQuery();

            while (resultSet.next()) {
                CountryMaster country = new CountryMaster();
                country.setIsoCode(resultSet.getString("isoCode"));
                country.setCountryName(resultSet.getString("countryName"));
                countries.add(country);
            }

            if (countries.size() == 0) {
                logger.error("There are no countries available");
            }

        } catch (SQLException e) {
            throw new DaoException(e.getMessage(), e);
        } catch (NamingException e) {
            throw new DaoException(e.getMessage(), e);
        } finally {
            dbSource.closeConnection();
        }
        return countries;
    }

    private String buildQuery(String countryNameLike) {

        String stmt = "SELECT isoCode, countryName " +
                "FROM ctm.country_master ";
        if(countryNameLike != null && countryNameLike.length() > 0) {
            stmt += " WHERE countryName LIKE ?";
        }
        stmt += " ORDER BY countryName ASC";
        return stmt;
    }

    /**
     *
     * @param isoCodes
     * @return
     */
    public ArrayList<CountryMaster> getCountriesByIsoCodes(ArrayList<String> isoCodes) throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        ArrayList<CountryMaster> countries = new ArrayList<CountryMaster>();

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
                CountryMaster country = new CountryMaster();
                country.setIsoCode(resultSet.getString("isoCode"));
                country.setCountryName(resultSet.getString("countryName"));
                countries.add(country);
            }

            if (countries.size() == 0) {
                logger.error("There are no countries available");
            }

        } catch (SQLException e) {
            throw new DaoException(e.getMessage(), e);
        } catch (NamingException e) {
            throw new DaoException(e.getMessage(), e);
        } finally {
            dbSource.closeConnection();
        }
        return countries;
    }

    private String buildQuery(ArrayList<String> isoCodes) {

        String stmt = "SELECT isoCode, countryName " +
                "FROM ctm.country_master ";
        if(isoCodes != null && isoCodes.size() > 0) {
            stmt += " WHERE isoCode IN("+SimpleDatabaseConnection.createSqlArrayParams(isoCodes.size())+")";
        }
        stmt += " ORDER BY countryName ASC";
        return stmt;
    }
    
}
