package com.ctm.web.car.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.car.model.CarProduct;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class CarProductDao {

    public CarProduct getCarProduct(Date effectiveDate, String productId, int styleCodeId) throws DaoException {
        try ( SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection() ) {
            PreparedStatement stmt;


            String query = "SELECT pm.providerCode as brandCode, cp.*, cc.* FROM " +
                    "ctm.provider_master pm JOIN ctm.car_product cp ON  pm.providerId = cp.providerId " +
                    "JOIN ctm.car_product_content cc ON cp.carProductId = cc.carProductId " +
                    "WHERE cp.code = ? AND (cc.styleCodeId = ? or cc.styleCodeId = 0) ";


            if (effectiveDate != null) {
                query += " AND ? BETWEEN cp.effectiveStart and cp.effectiveEnd " +
                        " AND ? BETWEEN cc.effectiveStart and cc.effectiveEnd ";
            }
            query += " order by cc.styleCodeId";

            stmt = dbSource.getConnection().prepareStatement(query);

            stmt.setString(1, productId);
            stmt.setInt(2, styleCodeId);

            if (effectiveDate != null) {
                stmt.setDate(3, new java.sql.Date(effectiveDate.getTime()));
                stmt.setDate(4, new java.sql.Date(effectiveDate.getTime()));
            }

            ResultSet results = stmt.executeQuery();

            // Get the first result
            if (results.next()) {
                CarProduct product = createCarProduct(results);
                return product;
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } catch (Exception e) {
            throw new DaoException(e);
        }

        return null;
    }

    private CarProduct createCarProduct(ResultSet results) throws SQLException {
        CarProduct product = new CarProduct();
        product.setBenefits(results.getString("benefits"));
        product.setInclusions(results.getString("inclusions"));
        product.setOptionalExtras(results.getString("optionalExtras"));
        return product;
    }


}
