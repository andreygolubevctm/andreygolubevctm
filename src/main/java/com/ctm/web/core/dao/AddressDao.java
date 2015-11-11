package com.ctm.web.core.dao;

import com.ctm.web.core.model.Address;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
				"SELECT unitType, unitNo, houseNo, FloorNo, street, suburb, postCode, state, dpId, streetId FROM aggregator.vw_elastic_street_address " +
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
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return address;
	}

}
