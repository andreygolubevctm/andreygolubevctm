package com.ctm.web.car.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.car.model.CarFuel;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CarFuelDao {

	public CarFuelDao() {
	}

	/**
	 * Get all fuels applicable to particular make, model, year, body and transmission.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 * @param bodyCode Body code e.g. 2CPE
	 * @param transmissionCode Transmission code e.g. M
	 */
	public ArrayList<CarFuel> getByMakeModelYearBodyTransmission(String makeCode, String modelCode, String yearCode, String bodyCode, String transmissionCode) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarFuel> carFuels = new ArrayList<CarFuel>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT DISTINCT fuel FROM aggregator.vehicles"
				+ " WHERE make = ?"
				+ " AND   model = ?"
				+ " AND   year = ?"
				+ " AND   body = ?"
				+ " AND   trans = ?"
				+ " UNION"
				+ " SELECT DISTINCT fuel FROM aggregator.vehicles_nextyear"
				+ " WHERE make = ?"
				+ " AND   model = ?"
				+ " AND   year = ?"
				+ " AND   body = ?"
				+ " AND   trans = ?"
			);
			stmt.setString(1, makeCode);
			stmt.setString(2, modelCode);
			stmt.setString(3, yearCode);
			stmt.setString(4, bodyCode);
			stmt.setString(5, transmissionCode);

			stmt.setString(6, makeCode);
			stmt.setString(7, modelCode);
			stmt.setString(8, yearCode);
			stmt.setString(9, bodyCode);
			stmt.setString(10, transmissionCode);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarFuel carFuel = new CarFuel();

				CarFuel.FuelType type = CarFuel.FuelType.findByCode(results.getString("fuel"));
				if (type != null) {
					carFuel.setCode(type.getCode());
					carFuel.setLabel(type.getLabel());
				}

				carFuels.add(carFuel);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carFuels;
	}
}
