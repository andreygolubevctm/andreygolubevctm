package com.ctm.dao.car;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.car.CarModel;

public class CarModelDao {

	public CarModelDao() {
	}

	/**
	 * Get all car models for a particular make.
	 * @param makeCode Make code e.g. HOLD
	 */
	public ArrayList<CarModel> getByMakeCode(String makeCode) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarModel> carModels = new ArrayList<CarModel>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT DISTINCT(vehicle_models.model), vehicle_models.des"
				+ " FROM aggregator.vehicle_models"
				+ " JOIN aggregator.vehicles ON vehicles.model = vehicle_models.model"
				+ " AND vehicles.make = vehicle_models.make"
				+ " WHERE vehicles.make = ?"
				+ " ORDER BY vehicle_models.des"
			);
			stmt.setString(1, makeCode);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarModel carModel = new CarModel();
				carModel.setCode(results.getString("model"));
				carModel.setLabel(results.getString("des"));
				carModels.add(carModel);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carModels;
	}
}
