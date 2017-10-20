package com.ctm.web.health.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import com.ctm.web.core.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Repository
public class HealthProductsSalesSynchronizationDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthProductsSalesSynchronizationDao.class);


    public HealthProductsSalesSynchronizationDao() {
    }

    public void addNewProductSalesFromLastSync(String lastSyncPeriod) throws DaoException {
        SimpleDatabaseConnection dbSource = null;
        boolean autoCommit = true;
        try {
            PreparedStatement addNewSalesStmt;
            PreparedStatement updateSyncStmt;
            dbSource = new SimpleDatabaseConnection();
            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);

            //add new sales data from last sync period to end of last month
            addNewSalesStmt = dbSource.getConnection().prepareStatement(
                    "INSERT INTO aggregator.product_sales ( " +
                            "  product_code, product_name, " +
                            "  family_type, state, age_group, " +
                            "  cover_Type, sale_month, sales, provider_id) " +
                            "  SELECT  p.ProductCode, vSale.product_name, " +
                            "    vSale.family_type, vSale.state, a.code age_group, " +
                            "    p.Cover_Type, vSale.sale_month, " +
                            "                                    COUNT(*) sales, " +
                            "    p.provider_id " +
                            "  FROM ( " +
                            "         SELECT h.TransactionId, " +
                            "           DATE_FORMAT(t.date,'%Y%m') sale_month, " +
                            "           MAX(CASE WHEN d.xpath = 'health/application/productName' THEN d.textValue END) AS  product_code, " +
                            "           MAX(CASE WHEN d.xpath = 'health/application/productTitle' THEN d.textValue END) AS  product_name, " +
                            "           MAX(CASE WHEN d.xpath = 'health/situation/healthCvr' THEN d.textValue END) AS  family_type, " +
                            "           MAX(CASE WHEN d.xpath = 'health/application/address/state'  THEN d.textValue END) AS  state, " +
                            "           MAX(CASE WHEN d.xpath = 'health/application/primary/dob'  THEN d.textValue END) AS dob " +
                            "         FROM   ctm.touches t " +
                            "           JOIN   aggregator.transaction_header h ON (h.TransactionId = t.transaction_id AND h.ProductType = 'HEALTH' AND h.styleCodeId = 1) " +
                            "           JOIN   aggregator.transaction_details d on (h.TransactionId = d.transactionId) " +
                            "         WHERE  t.type = 'C' " +
                            "                AND    t.date >= (SELECT DATE_ADD(STR_TO_DATE(CONCAT(?,'01'),'%Y%m%d'), INTERVAL 1 MONTH) " +
                            "                                  FROM ctm.health_product_sales_sync) " +
                            "                AND    t.date < DATE_FORMAT(NOW() ,'%Y-%m-01') " +
                            "                AND    d.xpath in ( " +
                            "           'health/application/productName', " +
                            "           'health/application/productTitle', " +
                            "           'health/situation/healthCvr', " +
                            "           'health/application/address/state', " +
                            "           'health/application/primary/dob') " +
                            "         GROUP BY " +
                            "           h.TransactionId, " +
                            "           t.date, t.operator_id " +
                            "       ) vSale " +
                            "    LEFT JOIN   aggregator.general a ON (a.type = 'Age' AND DATEDIFF(CURRENT_DATE, STR_TO_DATE(vSale.dob, '%e/%m/%Y'))/365.24 BETWEEN a.orderSeq and CONVERT(a.code, UNSIGNED)) " +
                            "    JOIN   ( " +
                            "             SELECT   m.ProductCode, MAX(s.productType) cover_type, MAX(providerId) provider_id " +
                            "             FROM     ctm.product_master m " +
                            "               JOIN     ctm.product_properties_search s on m.ProductId = s.productId " +
                            "             WHERE    EffectiveEnd > CURRENT_DATE " +
                            "             GROUP BY m.ProductCode " +
                            "           ) p ON p.ProductCode = vSale.product_code " +
                            "  GROUP BY " +
                            "    p.ProductCode, vSale.product_name, " +
                            "    vSale.family_type, vSale.state, age_group, " +
                            "    p.Cover_Type, vSale.sale_month, " +
                            "    p.provider_id " +
                            "  HAVING  age_group IS NOT NULL " +
                            "; ");

            addNewSalesStmt.setString(1,lastSyncPeriod);
            addNewSalesStmt.executeUpdate();

            //update sync period as last month.
            updateSyncStmt = dbSource.getConnection().prepareStatement(
                    "UPDATE ctm.health_product_sales_sync SET last_sync_period = DATE_FORMAT(NOW() - INTERVAL  1 month,'%Y%m')");

            updateSyncStmt.executeUpdate();

            dbSource.getConnection().commit();
        } catch (SQLException | NamingException e) {
            try {
                dbSource.getConnection().rollback();
                LOGGER.error("Error in adding New Health ProductSales to the table aggregator.product_sales :" ,e);
            } catch (SQLException | NamingException e1) {
                throw new DaoException(e1);
            }
            throw new DaoException(e);
        } finally {
            try {
                dbSource.getConnection().setAutoCommit(autoCommit);

            } catch (SQLException | NamingException e) {
                throw new DaoException(e);
            }
            dbSource.closeConnection();
        }
    }

    public String getLastProductSalesSyncPeriod() throws DaoException {

        final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        PreparedStatement stmt = null;
        String lastSyncPeriod = null;

        try {
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT last_sync_period" +
                            " FROM ctm.health_product_sales_sync"
            );
            final ResultSet results = stmt.executeQuery();
            while (results.next()) {
                lastSyncPeriod = results.getString("last_sync_period");
            }
            results.close();
            stmt.close();

        } catch (NamingException | SQLException e) {
            throw new DaoException(e);
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (final SQLException e) {
                    LOGGER.error("Failed to get Last Health ProductSalesSyncPeriod", e);
                }
            }
            dbSource.closeConnection();
        }

        return lastSyncPeriod;
    }

}
