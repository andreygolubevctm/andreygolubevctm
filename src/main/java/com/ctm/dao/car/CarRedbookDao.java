package com.ctm.dao.car;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.NamingException;

import com.ctm.model.car.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

public class CarRedbookDao {

    public CarRedbookDao() {
    }

    /**
     * Get all vehicle properties for the redbook code provided.
     * @param redbookCode Redbook code e.g. ABAR11AA
     */
    public CarDetails getCarDetails(String redbookCode) throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        CarDetails carDetails = new CarDetails();

        //
        // Run the query
        //
        try {
            PreparedStatement stmt;
            dbSource = new SimpleDatabaseConnection();

            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT v.make, g.description AS makeDes, v.model, m.des AS modelDes, "
                    + " v.year, v.body, b.des AS bodyDes, v.trans, t.desc AS transDes, "
                    + " v.fuel, f.desc AS fuelDes, v.redbookCode, v.des, v.value"
                    + " FROM aggregator.vehicles AS v"
                    + " LEFT JOIN aggregator.general AS g ON g.type='make' AND g.code=v.make"
                    + " LEFT JOIN aggregator.vehicle_models AS m ON m.make=v.make AND m.model=v.model"
                    + " LEFT JOIN aggregator.vehicle_body AS b ON b.code=v.body"
                    + " LEFT JOIN aggregator.vehicle_desc AS t ON t.type='trans' AND t.code=v.trans"
                    + " LEFT JOIN aggregator.vehicle_desc AS f ON f.type='fuel' AND f.code=v.fuel"
                    + " WHERE v.redbookCode = ?"
                    + " UNION"
                    + " SELECT v.make, g.description AS makeDes, v.model, m.des AS modelDes, "
                    + " v.year, v.body, b.des AS bodyDes, v.trans, t.desc AS transDes, "
                    + " v.fuel, f.desc AS fuelDes, v.redbookCode, v.des, v.value"
                    + " FROM aggregator.vehicles_nextyear AS v"
                    + " LEFT JOIN aggregator.general AS g ON g.type='make' AND g.code=v.make"
                    + " LEFT JOIN aggregator.vehicle_models AS m ON m.make=v.make AND m.model=v.model"
                    + " LEFT JOIN aggregator.vehicle_body AS b ON b.code=v.body"
                    + " LEFT JOIN aggregator.vehicle_desc AS t ON t.type='trans' AND t.code=v.trans"
                    + " LEFT JOIN aggregator.vehicle_desc AS f ON f.type='fuel' AND f.code=v.fuel"
                    + " WHERE v.redbookCode = ?"
                    + " ORDER BY redbookCode ASC LIMIT 1"
            );

            stmt.setString(1, redbookCode);
            stmt.setString(2, redbookCode);

            ResultSet results = stmt.executeQuery();

            if (results.next()) {
                CarMake carMake = new CarMake();
                carMake.setCode(results.getString("make"));
                carMake.setLabel(results.getString("makeDes"));
                carDetails.setMake(carMake);

                CarModel carModel = new CarModel();
                carModel.setCode(results.getString("model"));
                carModel.setLabel(results.getString("modelDes"));
                carDetails.setModel(carModel);

                CarYear carYear = new CarYear();
                carYear.setCode(results.getString("year"));
                carYear.setLabel(results.getString("year"));
                carDetails.setYear(carYear);

                CarBody carBody = new CarBody();
                carBody.setCode(results.getString("body"));
                carBody.setLabel(results.getString("bodyDes"));
                carDetails.setBody(carBody);

                CarTransmission carTransmission = new CarTransmission();
                carTransmission.setCode(results.getString("trans"));
                carTransmission.setLabel(results.getString("transDes"));
                carDetails.setTransmission(carTransmission);

                CarFuel carFuel = new CarFuel();
                carFuel.setCode(results.getString("fuel"));
                carFuel.setLabel(results.getString("fuelDes"));
                carDetails.setFuel(carFuel);

                CarType carType = new CarType();
                carType.setCode(results.getString("redbookCode"));
                carType.setLabel(results.getString("des"));
                carType.setMarketValue(results.getInt("value"));
                carDetails.setType(carType);
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }
        finally {
            dbSource.closeConnection();
        }

        return carDetails;
    }
}
