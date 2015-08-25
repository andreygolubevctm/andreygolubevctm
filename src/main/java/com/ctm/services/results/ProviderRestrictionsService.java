package com.ctm.services.results;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.model.health.HealthPriceRequest;
import com.ctm.model.settings.Vertical.VerticalType;
import org.slf4j.Logger; import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProviderRestrictionsService {

	private static final Logger logger = LoggerFactory.getLogger(ProviderRestrictionsService.class.getName());


    public ProviderRestrictionsService() {

    }

    private int getProviderOfLatestAppliedProduct(long transactionId) {
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        int providerID = 0;
        String selectStatement =
                "SELECT pm.providerId \n" +
                        "FROM   ctm.product_master pm\n" +
                        "INNER JOIN ctm.vw_dailySalesCount pp ON pp.providerId= pm.ProviderId  \n" +
                        "WHERE  pm.productId = (SELECT tp.productCode \n" +
                        "                          FROM   ctm.touches t \n" +
                        "                          INNER JOIN ctm.touches_products tp \n" +
                        "                                     ON t.id = tp.touchesId \n" +
                        "                          WHERE  t.transaction_id IN (SELECT transactionId \n" +
                        "                                                      FROM   aggregator.transaction_header th \n" +
                        "                                                      WHERE  th.rootId = (SELECT th1.rootid \n" +
                        "                                                                          FROM   aggregator.transaction_header th1\n" +
                        "                                                                          WHERE  th1.transactionid = ?))\n" +
                        "                          ORDER  BY date,time DESC LIMIT 1) \n" +
                        "       AND limitCategory = 'S' LIMIT 1; ";

        try {
            Connection conn = dbSource.getConnection();

            PreparedStatement stmt;
            ResultSet results;
            stmt = conn.prepareStatement(selectStatement);
            stmt.setLong(1, transactionId);
            results = stmt.executeQuery();
            if (results.next()) {
                providerID = results.getInt("providerId");
            }
        } catch (NamingException e) {
            logger.error("failed to get connection", e);
        } catch (Exception e) {
            logger.error(transactionId + ": failed to get filtered brands", e);
        } finally {
            if (dbSource != null) {
                dbSource.closeConnection();
            }
        }
        return providerID;
    }

    public List<Integer> getProvidersWithExceededSoftLimit(String state, String vertical, long transactionid) {
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        String selectStatement =
                "SELECT providerId \n" +
                        "FROM ctm.vw_dailySalesCount \n" +
                        "WHERE ( \n" +
                        "       (limitValue = ? AND limitType = 'STATE') \n" +
                        "                           OR   limitType = 'GENERAL' \n" +
                        "       ) \n" +
                        "       AND currentJoinCount >= maxJoins \n"+
                        "       AND vertical = ? \n"+
                        "       AND providerId NOT IN ( \n" +
                        "                       SELECT pm.providerId \n" +
                        "                       FROM `ctm`.`joins`  j \n" +
                        "                       INNER JOIN ctm.product_master pm \n" +
                        "                                   on pm.productid = j.productid \n" +
                        "                       WHERE rootid in ( \n" +
                        "                                           SELECT rootid \n" +
                        "                                           FROM aggregator.transaction_header th \n" +
                        "                                           WHERE th.transactionid = ? \n" +
                        "                                       ) \n" +
                        "                               )  \n" +
                        "       AND providerID <> ? \n" +
                        " UNION  \n"+
                        " SELECT providerId \n" +
                        " FROM ctm.vw_monthlySalesCount \n" +
                        " WHERE ( \n" +
                        "           (limitValue = ? AND limitType = 'STATE') \n" +
                        "                           OR  limitType = 'GENERAL' \n" +
                        "       ) \n" +
                        "       AND currentJoinCount >= maxJoins \n"+
                        "       AND vertical = ? \n"+
                        "       AND providerId NOT IN ( \n" +
                        "                               SELECT pm.providerId \n" +
                        "                               FROM `ctm`.`joins`  j \n" +
                        "                               INNER JOIN ctm.product_master pm \n" +
                        "                                       on pm.productid = j.productid \n" +
                        "                               WHERE rootid in ( \n" +
                        "                                                   SELECT rootid \n" +
                        "                                                   FROM aggregator.transaction_header th \n" +
                        "                                                   WHERE th.transactionid = ? \n" +
                        "                                               ) \n" +
                        "                             )" +
                        "union " +
                        "select \n" +
                        "    distinct ProviderId\n" +
                        "from\n" +
                        "    ctm.provider_properties\n" +
                        "where\n" +
                        "    (propertyId = 'MonthlyLimit' or (propertyId = 'DailyLimit' and status='H'))\n" +
                        "        and text = '0'\n" +
                        "        and curdate() between EffectiveStart and EffectiveEnd;";

        List<Integer> restrictedProviders = new ArrayList<Integer>();
        try {
            Connection conn = dbSource.getConnection();

            PreparedStatement stmt;
            ResultSet results;
            stmt = conn.prepareStatement(selectStatement);
            stmt.setString(1, state);
            stmt.setString(2, vertical);
            stmt.setLong(3, transactionid);
            stmt.setLong(4, getProviderOfLatestAppliedProduct(transactionid));
            stmt.setString(5, state);
            stmt.setString(6, vertical);
            stmt.setLong(7, transactionid);
            results = stmt.executeQuery();
            while (results.next()) {
                restrictedProviders.add(results.getInt("providerId"));
            }
        } catch (NamingException e) {
            logger.error("failed to get connection", e);
        } catch (Exception e) {
            logger.error(transactionid + ": failed to get filtered brands", e);
        } finally {
            if (dbSource != null) {
                dbSource.closeConnection();
            }
        }
        return restrictedProviders;
    }


    /**
     * Get provider ids of what has exceeded the monthly limit
     *
     * @param state
     * @param vertical
     * @param transactionid
     * @return
     */
    public List<Integer> getProvidersWithExceededHardLimit(String state, String vertical, long transactionid) {
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        String selectStatement =
                "SELECT providerId " +
                        "FROM ctm.vw_monthlySalesCount " +
                        "WHERE ( " +
                        "(limitValue = ? AND limitType = 'STATE') " +
                        "OR " +
                        "limitType = 'GENERAL' " +
                        ") " +
                        "AND currentJoinCount >= maxJoins " +
                        "AND vertical = ? " +
                        "AND providerId NOT IN ( " +
                        "SELECT pm.providerId FROM `ctm`.`joins`  j " +
                        "INNER JOIN ctm.product_master pm " +
                        "ON pm.productid = j.productid " +
                        "WHERE rootid IN ( " +
                        "SELECT rootid FROM aggregator.transaction_header th " +
                        "WHERE th.transactionid = ? " +
                        ") " +
                        ")" +
                        "UNION " +
                        "SELECT providerId FROM ctm.vw_dailySalesCount " +
                        "WHERE ( " +
                        "(limitValue = ? AND limitType = 'STATE') " +
                        "OR " +
                        "limitType = 'GENERAL' " +
                        ") " +
                        "AND currentJoinCount >= maxJoins " +
                        "AND vertical = ? " +
                        "AND limitCategory = 'H' " + //consider daily limits only when it has been marked as Hard Limit
                        "AND providerId NOT IN ( " +
                        "SELECT pm.providerId FROM `ctm`.`joins`  j " +
                        "INNER JOIN ctm.product_master pm " +
                        "ON pm.productid = j.productid " +
                        "WHERE rootid IN ( " +
                        "SELECT rootid FROM aggregator.transaction_header th " +
                        "WHERE th.transactionid = ? " +
                        ") " +
                        ")"+
                        "union " +
                        "select \n" +
                        "    distinct ProviderId\n" +
                        "from\n" +
                        "    ctm.provider_properties\n" +
                        "where\n" +
                        "   (propertyId = 'MonthlyLimit' or (propertyId = 'DailyLimit' and status='H'))\n" +
                        "        and text = '0'\n" +
                        "        and curdate() between EffectiveStart and EffectiveEnd;";


        List<Integer> restrictedProviders = new ArrayList<Integer>();
        try {
            Connection conn = dbSource.getConnection();

            PreparedStatement stmt;
            ResultSet results;
            stmt = conn.prepareStatement(selectStatement);
            stmt.setString(1, state);
            stmt.setString(2, vertical);
            stmt.setLong(3, transactionid);
            stmt.setString(4, state);
            stmt.setString(5, vertical);
            stmt.setLong(6, transactionid);
            results = stmt.executeQuery();
            while (results.next()) {
                restrictedProviders.add(results.getInt("providerId"));
            }
        } catch (Exception e) {
            logger.error(transactionid + "failed to get filtered brands", e);
        } finally {
            if (dbSource != null) {
                dbSource.closeConnection();
            }
        }
        return restrictedProviders;
    }


    /**
     * Set the provider exclusion from both the request and the restrictions in the database
     *
     * @param transactionId
     */
    public List<Integer> setUpExcludedProviders(HealthPriceRequest healthPriceRequest, long transactionId) {
        List<Integer> excludedProviders = new ArrayList<Integer>();

        // Add providers that have been excluded in the request
        for (String providerId : healthPriceRequest.getBrandFilter().split(",")) {
            if (!providerId.isEmpty()) {
                excludedProviders.add(Integer.parseInt(providerId));
            }
        }

        List<Integer> providersThatHaveExceededLimit;

        if (healthPriceRequest.isOnResultsPage()) {
            // Check for soft limits
            providersThatHaveExceededLimit = getProvidersWithExceededSoftLimit(healthPriceRequest.getState(), VerticalType.HEALTH.getCode(), transactionId);
        } else {
            // Check for hard limits
            providersThatHaveExceededLimit = getProvidersWithExceededHardLimit(healthPriceRequest.getState(), VerticalType.HEALTH.getCode(), transactionId);
        }

        // Add providers that have been excluded in the database
        for (Integer providerId : new ArrayList<>(providersThatHaveExceededLimit)) {
            if (excludedProviders.contains(providerId)) {
                providersThatHaveExceededLimit.remove(providerId);
            }
        }

        healthPriceRequest.setProvidersThatHaveExceededLimit(providersThatHaveExceededLimit);
        healthPriceRequest.setExcludedProviders(excludedProviders);
        return excludedProviders;
    }

}
