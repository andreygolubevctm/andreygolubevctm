package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.LmiModel;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class LmiDao {

    public ArrayList<LmiModel> fetchProviders(String verticalType) throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        ArrayList<LmiModel> lmiModels = new ArrayList<LmiModel>();
        try {
            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt;
            Connection conn = dbSource.getConnection();

            if (conn != null) {
                stmt = conn.prepareStatement(
                        "SELECT DISTINCT fb.id, displayName AS name, realName," +
                                "   ( SELECT count(*) AS count" +
                                "       FROM aggregator.features_product_mapping map" +
                                "       JOIN aggregator.features_products fp" +
                                "           WHERE fp.ref = map.lmi_Ref" +
                                "                  AND fp.brandId = fb.id" +
                                "   ) AS in_ctm" +
                                "   FROM aggregator.features_brands fb" +
                                "   LEFT JOIN aggregator.features_products fp" +
                                "   ON fp.brandId = fb.id" +
                                "   WHERE fp.vertical = ? AND fb.status = 'Y'" +
                                "   ORDER BY fb.displayName ASC;"
                );

                stmt.setString(1, verticalType);

                ResultSet resultSet = stmt.executeQuery();
                while (resultSet.next()) {
                    LmiModel lmiModel = new LmiModel();
                    lmiModel.setBrandId(resultSet.getString("id"));
                    lmiModel.setBrandName(resultSet.getString("name"));
                    lmiModel.setIsInCtm(resultSet.getInt("in_ctm") > 0);
                    lmiModels.add(lmiModel);
                }
            }
        } catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        } finally {
            if (dbSource != null) {
                dbSource.closeConnection();
            }
        }

        return lmiModels;
    }
}
