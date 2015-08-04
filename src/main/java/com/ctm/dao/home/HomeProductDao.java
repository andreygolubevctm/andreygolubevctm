package com.ctm.dao.home;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.home.HomeProduct;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class HomeProductDao {

    public HomeProduct getHomeProduct(Date effectiveDate, String productId, String type, int styleCodeId) throws DaoException {
        try ( SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection() ) {
            PreparedStatement stmt;


            String query = "SELECT pm.providerCode as brandCode, hp.*, hc.* FROM " +
                    "ctm.provider_master pm JOIN ctm.home_product hp ON  pm.providerId = hp.providerId " +
                    "JOIN ctm.home_product_content hc ON hp.homeProductId = hc.homeProductId " +
                    "WHERE hp.code = ? AND hc.coverType = ? AND (hc.styleCodeId = ? or hc.styleCodeId = 0) ";

            if (effectiveDate != null) {
                query += " AND ? BETWEEN hp.effectiveStart and hp.effectiveEnd " +
                        " AND ? BETWEEN hc.effectiveStart and hc.effectiveEnd ";
            }
            query += " order by hc.styleCodeId";

            stmt = dbSource.getConnection().prepareStatement(query);

            stmt.setString(1, productId);
            stmt.setString(2, type);
            stmt.setInt(3, styleCodeId);

            if (effectiveDate != null) {
                stmt.setDate(4, new java.sql.Date(effectiveDate.getTime()));
                stmt.setDate(5, new java.sql.Date(effectiveDate.getTime()));
            }

            ResultSet results = stmt.executeQuery();

            // Get the first result
            if (results.next()) {
                HomeProduct product = createHomeProduct(results);
                return product;
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        } catch (Exception e) {
            throw new DaoException(e.getMessage(), e);
        }

        return null;
    }

    private HomeProduct createHomeProduct(ResultSet results) throws SQLException {
        HomeProduct product = new HomeProduct();
        product.setBenefits(results.getString("benefits"));
        product.setInclusions(results.getString("inclusions"));
        product.setOptionalExtras(results.getString("optionalExtras"));
        return product;
    }


}
