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
	 * Get all car makes. They will be grouped into isTopMake=true and isTopMake=false.
	 */
	public ArrayList<CarColour> getAll() throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarColour> carColours = new ArrayList<>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT colourCode, colourDescription FROM aggregator.vehicle_colour ORDER BY colourCode");

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarColour carColour = new CarColour();
				carColour.setCode(results.getString("colourCode"));
				carColour.setLabel(results.getString("colourDescription"));
				carColours.add(carColour);
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
}
