package com.ctm.web.car.dao;

import com.ctm.web.car.model.CarColour;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CarColourDao {

	public CarColourDao() {
	}

	/**
	 * Get all car colours.
	 */
	public ArrayList<CarColour> getAll() throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarColour> carColours = new ArrayList<>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"(SELECT p.colourCode, p.colourDescription, '1' AS isTop " +
						"FROM aggregator.vehicle_popular_colour AS p " +
						" ) " +
						"UNION ALL " +
						"(SELECT DISTINCT vm.colourCode , vm.colourDescription, '0' AS isTop " +
						"FROM aggregator.vehicle_colour AS vm " +
						") ORDER BY isTop DESC, colourCode;");


			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				carColours.add(createCarColour(results));
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carColours;
	}

	public CarColour getColourCode(String colourCode) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarColour> carColours = new ArrayList<>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT colourCode, colourDescription FROM aggregator.vehicle_colour where colourCode = ? or colourCode = 'other' ORDER BY vehicleColourId DESC LIMIT 1");
			stmt.setString(1, colourCode);

			ResultSet results = stmt.executeQuery();

			if (results.next()) {
				return createCarColour(results);
			}
			return null;
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	private CarColour createCarColour(ResultSet results) throws SQLException {
		CarColour carColour = new CarColour();
		carColour.setCode(results.getString("colourCode"));
		carColour.setLabel(results.getString("colourDescription"));
		carColour.setIsTop(results.getBoolean("isTop"));
		return carColour;
	}
}
