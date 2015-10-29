package com.ctm.web.car.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.web.car.model.CarTransmission;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CarTransmissionDao {

	public CarTransmissionDao() {
	}

	/**
	 * Get all bodies applicable to particular make, model and year.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 * @param bodyCode Body code e.g. 2CPE
	 */
	public ArrayList<CarTransmission> getByMakeModelYearBody(String makeCode, String modelCode, String yearCode, String bodyCode) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarTransmission> carTrans = new ArrayList<CarTransmission>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT DISTINCT trans FROM aggregator.vehicles"
				+ " WHERE make = ?"
				+ " AND   model = ?"
				+ " AND   year = ?"
				+ " AND   body = ?"
				+ " UNION"
				+ " SELECT DISTINCT trans FROM aggregator.vehicles_nextyear"
				+ " WHERE make = ?"
				+ " AND   model = ?"
				+ " AND   year = ?"
				+ " AND   body = ?"
			);
			stmt.setString(1, makeCode);
			stmt.setString(2, modelCode);
			stmt.setString(3, yearCode);
			stmt.setString(4, bodyCode);

			stmt.setString(5, makeCode);
			stmt.setString(6, modelCode);
			stmt.setString(7, yearCode);
			stmt.setString(8, bodyCode);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarTransmission carTransmission = new CarTransmission();

				CarTransmission.TransmissionType type = CarTransmission.TransmissionType.findByCode(results.getString("trans"));
				if (type != null) {
					carTransmission.setCode(type.getCode());
					carTransmission.setLabel(type.getLabel());
				}

				carTrans.add(carTransmission);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carTrans;
	}
}
