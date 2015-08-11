package com.ctm.dao.car;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.car.CarTransmission;
import com.ctm.model.car.CarType;

public class CarTypeDao {
	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger(CarTypeDao.class.getName());

	public CarTypeDao() {
	}

	/**
	 * Get all fuels applicable to particular make, model, year, body and transmission.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 * @param bodyCode Body code e.g. 2CPE
	 * @param transmissionCode Transmission code e.g. M
	 * @param fuelCode Fuel code e.g. P
	 */
	public ArrayList<CarType> getByMakeModelYearBodyTransmissionFuel(String makeCode, String modelCode, String yearCode, String bodyCode, String transmissionCode, String fuelCode) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<CarType> carTypes = new ArrayList<CarType>();

		//
		// Expand the transmission being searched for.
		// Was originally added in CAR-130. Apparently it's a 'fuzzy' search to help people find their vehicles.
		//
		String[] transmissions = null;
		CarTransmission.TransmissionType trans = CarTransmission.TransmissionType.findByCode(transmissionCode);

		switch (trans) {
		case MANUAL:
			transmissions = new String[]{
				CarTransmission.TransmissionType.MANUAL.getCode(),
				CarTransmission.TransmissionType.SEMI_AUTOMATIC.getCode(),
				CarTransmission.TransmissionType.DUAL_CLUTCH.getCode()
			};
			break;
		case AUTOMATIC:
			transmissions = new String[]{
					CarTransmission.TransmissionType.AUTOMATIC.getCode(),
					CarTransmission.TransmissionType.SEMI_AUTOMATIC.getCode()
			};
			break;
		default:
			transmissions = new String[]{
				transmissionCode
			};
			break;
		}

		//
		// Run the query
		//
		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT redbookCode, des, value FROM aggregator.vehicles"
				+ " WHERE make = ?"
				+ "   AND model = ?"
				+ "   AND year = ?"
				+ "   AND body = ?"
				+ "   AND trans in ("+ SimpleDatabaseConnection.createSqlArrayParams(transmissions.length) + ")"
				+ "   AND fuel = ?"
				+ " UNION"
				+ " SELECT redbookCode, des, value FROM aggregator.vehicles_nextyear"
				+ " WHERE make = ?"
				+ "   AND model = ?"
				+ "   AND year = ?"
				+ "   AND body = ?"
				+ "   AND trans in ("+ SimpleDatabaseConnection.createSqlArrayParams(transmissions.length) + ")"
				+ "   AND fuel = ?"
				+ " ORDER BY des ASC"
			);

			int counter = 1;

			stmt.setString(counter++, makeCode);
			stmt.setString(counter++, modelCode);
			stmt.setString(counter++, yearCode);
			stmt.setString(counter++, bodyCode);

			for (String code : transmissions) {
				stmt.setString(counter++, code);
			}
			stmt.setString(counter++, fuelCode);

			stmt.setString(counter++, makeCode);
			stmt.setString(counter++, modelCode);
			stmt.setString(counter++, yearCode);
			stmt.setString(counter++, bodyCode);

			for (String code : transmissions) {
				stmt.setString(counter++, code);
			}
			stmt.setString(counter++, fuelCode);

			//logger.debug(stmt.toString());

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				CarType carType = new CarType();

				carType.setCode(results.getString("redbookCode"));
				carType.setLabel(results.getString("des"));
				carType.setMarketValue(results.getInt("value"));

				carTypes.add(carType);
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return carTypes;
	}
}
