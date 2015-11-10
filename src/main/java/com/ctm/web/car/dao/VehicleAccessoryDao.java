package com.ctm.web.car.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.car.model.VehicleAccessory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VehicleAccessoryDao {

    public List<VehicleAccessory> getStandardAccessories(String redBookCode) throws DaoException {
        return getVehicleAccessories("SELECT code, des FROM aggregator.vehicle_accessories " +
                "WHERE redbookCode = ? AND type = 'S' ORDER BY des;", redBookCode);
    }

    public List<VehicleAccessory> getOptionalAccessories(String redBookCode) throws DaoException {
        return getVehicleAccessories("SELECT code, des FROM aggregator.vehicle_accessories " +
                "WHERE redbookCode = ? AND type = 'O' ORDER BY des;", redBookCode);
    }

    public List<VehicleAccessory> getAlarmAccessories(String redBookCode) throws DaoException {
        return getVehicleAccessories("SELECT code, des FROM aggregator.vehicle_accessories " +
                "WHERE redbookCode = ? AND type = 'S' AND des LIKE ('%alarm%') LIMIT 1;", redBookCode);
    }

    public List<VehicleAccessory> getImmobiliserAccessories(String redBookCode) throws DaoException {
        return getVehicleAccessories("SELECT code, des FROM aggregator.vehicle_accessories " +
                "WHERE redbookCode = ? AND type = 'S' AND des LIKE ('%immobil%') LIMIT 1;", redBookCode);
    }

    private List<VehicleAccessory> getVehicleAccessories(String query, String redBookCode) throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        List<VehicleAccessory> list = new ArrayList<VehicleAccessory>();

        try {
            PreparedStatement stmt;
            dbSource = new SimpleDatabaseConnection();

            stmt = dbSource.getConnection().prepareStatement(query);

            stmt.setString(1, redBookCode);

            ResultSet results = stmt.executeQuery();

            while (results.next()) {
                VehicleAccessory result = new VehicleAccessory();
                result.setCode(results.getString("code"));
                result.setLabel(results.getString("des"));
                list.add(result);
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        finally {
            dbSource.closeConnection();
        }

        return list;

    }

}
