package com.ctm.dao.car;

import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.AbstractJsonModel;
import com.ctm.model.car.CarModel;
import com.ctm.dao.car.CarMakeDao;
import com.ctm.model.car.CarMake;
import com.ctm.model.formatter.JsonUtils;

public class CarModelDao {

	public CarModelDao() {}

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

			/**
			 * This will need to be amended to be a UNION to render the top models at top
			 **/
			stmt = dbSource.getConnection().prepareStatement(
				"(SELECT p.model AS model, vm.des AS des, '1' AS isTop " +
				"FROM aggregator.vehicle_popular_models AS p " +
				"JOIN aggregator.vehicle_models AS vm ON p.make = vm.make AND p.model = vm.model " +
				"WHERE p.make = ?) " +
				"UNION ALL " +
				"(SELECT DISTINCT vm.model AS model, vm.des AS des, '0' AS isTop " +
				"FROM aggregator.vehicle_models AS vm " +
				"JOIN aggregator.vehicles AS v ON v.model = vm.model AND v.make = vm.make " +
				"WHERE v.make = ?) " +
				"ORDER BY isTop DESC, des ASC;"
			);
			stmt.setString(1, makeCode);
			stmt.setString(2, makeCode);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarModel carModel = new CarModel();
				carModel.setCode(results.getString("model"));
				carModel.setLabel(results.getString("des"));
				carModel.setIsTopModel(results.getBoolean("isTop"));
				carModels.add(carModel);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carModels;
	}

	/**
	 * Updates the aggregator.vehicle_popular_models with the top models
	 * for each vehicle make.
	 */
	public void updatePopularModels() throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		Connection connection = null;
		PreparedStatement stmt;

		try {
			dbSource = new SimpleDatabaseConnection();
			connection = dbSource.getConnection();

			stmt = connection.prepareStatement(
				"CALL aggregator.populatePopularVehicleModels();"
			);

			stmt.execute();
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	public String getLastUpdate() throws DaoException {

		String lastUpdate = null;
		SimpleDatabaseConnection dbSource = null;

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT DISTINCT(last_update) FROM aggregator.vehicle_popular_models;"
			);

			ResultSet results = stmt.executeQuery();

			if (results.first()) {
				lastUpdate = results.getString("last_update");
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return lastUpdate;
	}
}
