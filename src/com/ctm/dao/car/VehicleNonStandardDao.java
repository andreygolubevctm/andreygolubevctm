package com.ctm.dao.car;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.car.VehicleNonStandard;
import com.ctm.model.car.VehicleNonStandardMapping;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VehicleNonStandardDao {

    public List<VehicleNonStandard> getVehicleNonStandards() throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        List<VehicleNonStandard> vehicleNonStandards = new ArrayList<VehicleNonStandard>();

        try {
            PreparedStatement stmt;
            dbSource = new SimpleDatabaseConnection();

            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT code, description, standard, min, max FROM aggregator.vehicle_nonstandard ORDER BY `description`;"
            );

            ResultSet results = stmt.executeQuery();

            while (results.next()) {
                VehicleNonStandard vehicleNonStandard = new VehicleNonStandard();
                vehicleNonStandard.setCode(results.getString("code"));
                vehicleNonStandard.setLabel(results.getString("description"));
                vehicleNonStandard.setStandard(results.getString("standard"));
                vehicleNonStandard.setMin(results.getString("min"));
                vehicleNonStandard.setMax(results.getString("max"));
                vehicleNonStandards.add(vehicleNonStandard);
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }
        finally {
            dbSource.closeConnection();
        }

        return vehicleNonStandards;

    }

    public List<VehicleNonStandardMapping> getVehicleNonStandardMappings() throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        List<VehicleNonStandardMapping> vehicleNonStandards = new ArrayList<>();

        try {
            PreparedStatement stmt;
            dbSource = new SimpleDatabaseConnection();

            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT `code`, `des`, `underwriter` FROM aggregator.vehicle_nonstandard_mapping;"
            );

            ResultSet results = stmt.executeQuery();

            while (results.next()) {
                VehicleNonStandardMapping mapping = new VehicleNonStandardMapping();
                mapping.setCode(results.getString("code"));
                mapping.setDes(results.getString("des"));
                mapping.setUnderwriter(results.getString("underwriter"));
                vehicleNonStandards.add(mapping);
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }
        finally {
            dbSource.closeConnection();
        }

        return vehicleNonStandards;

    }

}
