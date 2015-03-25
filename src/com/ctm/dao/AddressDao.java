package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Address;

public class AddressDao {

	public Address getAddressDetails(String dpId) throws DaoException {
		int parsedDpId = Integer.parseInt(dpId);
		return getAddressDetailsByDpId(parsedDpId);
	}

	/**
	 * Get address for a specific dpId
	 * @param dpId
	 */
	public Address getAddressDetailsByDpId(int dpId) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		Address address = new Address();

		try {
			PreparedStatement sqlStatement;
			dbSource = new SimpleDatabaseConnection();

			sqlStatement = dbSource.getConnection().prepareStatement(
				"SELECT * FROM aggregator.vw_elastic_street_address " +
				"WHERE dpId = ? " +
				"LIMIT 0,1"
			);
			sqlStatement.setInt(1, dpId);

			ResultSet results = sqlStatement.executeQuery();

			while (results.next()) {
				address.setDpId(results.getString("dpId"));
				address.setUnitType(results.getString("unitType"));
				address.setUnitNo(results.getString("unitNo"));
				address.setHouseNo(results.getString("houseNo"));
				address.setFloorNo(results.getString("FloorNo"));
				address.setStreet(results.getString("street"));
				address.setStreetId(results.getString("streetId"));
				address.setSuburb(results.getString("suburb"));
				address.setPostCode(results.getString("postCode"));
				address.setState(results.getString("state"));
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return address;
	}

}
