package com.ctm.web.car.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.car.model.CarBody;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CarBodyDao {

	public CarBodyDao() {
	}

	/**
	 * Get all bodies applicable to particular make, model and year.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 */
	public ArrayList<CarBody> getByMakeModelYear(String makeCode, String modelCode, String yearCode) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarBody> carBodies = new ArrayList<CarBody>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT DISTINCT(vehicle_body.code), vehicle_body.des"
					+ " FROM aggregator.vehicle_body"
					+ " JOIN aggregator.vehicles ON vehicle_body.code = vehicles.body"
					+ " WHERE vehicles.make = ?"
					+ "     AND vehicles.model = ?"
					+ "     AND vehicles.year = ?"
					+ " UNION"
					+ " SELECT DISTINCT(vehicle_body.code), vehicle_body.des"
					+ " FROM aggregator.vehicle_body"
					+ " JOIN aggregator.vehicles_nextyear ON vehicle_body.code = vehicles_nextyear.body"
					+ " WHERE vehicles_nextyear.make = ?"
					+ "     AND vehicles_nextyear.model = ?"
					+ "     AND vehicles_nextyear.year = ?"
			);
			stmt.setString(1, makeCode);
			stmt.setString(2, modelCode);
			stmt.setString(3, yearCode);

			stmt.setString(4, makeCode);
			stmt.setString(5, modelCode);
			stmt.setString(6, yearCode);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarBody carBody = new CarBody();
				carBody.setCode(results.getString("code"));
				carBody.setLabel(results.getString("des"));
				carBodies.add(carBody);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carBodies;
	}
}
