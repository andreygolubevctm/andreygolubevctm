package com.ctm.dao.car;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import org.slf4j.Logger; import org.slf4j.LoggerFactory;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.car.CarMake;

public class CarMakeDao {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(CarMakeDao.class.getName());

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
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carMakes;
	}
}
