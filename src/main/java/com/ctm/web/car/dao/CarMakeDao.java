package com.ctm.web.car.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.car.model.CarMake;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CarMakeDao {

	public CarMakeDao() {
	}

	/**
	 * Get all car makes. They will be grouped into isTopMake=true and isTopMake=false.
	 */
	public ArrayList<CarMake> getAll() throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarMake> carMakes = new ArrayList<CarMake>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"(SELECT '1' AS isTop, code, description FROM aggregator.general WHERE type = 'make' ORDER BY orderSeq LIMIT 16) " +
				"UNION ALL " +
				"(SELECT '0' AS isTop, code, description FROM aggregator.general WHERE type = 'make' ORDER BY description)"
			);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarMake carMake = new CarMake();
				carMake.setCode(results.getString("code"));
				carMake.setLabel(results.getString("description"));
				carMake.setIsTopMake(results.getBoolean("isTop"));
				carMakes.add(carMake);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carMakes;
	}
}
