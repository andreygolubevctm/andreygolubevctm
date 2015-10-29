package com.ctm.web.car.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.web.car.model.CarYear;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CarYearDao {

	public CarYearDao() {
	}

	/**
	 * Get all years applicable to particular make and model.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 */
	public ArrayList<CarYear> getByMakeCodeAndModelCode(String makeCode, String modelCode) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarYear> carYears = new ArrayList<CarYear>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT DISTINCT(year) FROM aggregator.vehicles"
				+ " WHERE make = ? AND model = ?"
				+ " UNION"
				+ " SELECT DISTINCT(year) FROM aggregator.vehicles_nextyear"
				+ " WHERE make = ? AND model = ?"
				+ " ORDER BY year DESC"
			);
			stmt.setString(1, makeCode);
			stmt.setString(2, modelCode);
			stmt.setString(3, makeCode);
			stmt.setString(4, modelCode);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarYear carYear = new CarYear();
				carYear.setCode(results.getString("year"));
				carYear.setLabel(results.getString("year"));
				carYears.add(carYear);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carYears;
	}
}
