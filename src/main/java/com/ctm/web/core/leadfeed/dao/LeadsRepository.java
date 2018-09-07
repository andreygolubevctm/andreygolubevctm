package com.ctm.web.core.leadfeed.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.leadfeed.config.LeadsConfig;
import com.ctm.web.core.model.leadfeed.LeadFeedRootTransaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

/**
 * Queries to retrieve data related to populating LeadFeedData instances. Primarily to allow easier mocking, secondarily
 * for SOC/SR.
 */
@Repository
public class LeadsRepository {

    @Autowired
    private SimpleDatabaseConnection dbSource;
    @Autowired
    private LeadsConfig config;

    /**
     * For a given vertical and brand, retrieve basic transaction details of any type defined in config which have are
     * no older than a configured period and no sooner than a configured period on a per lead-type basis.
     *
     * e.g. All leads less than 30 minutes old and:
     *  - for best price, no less than 10 minutes old
     *  - for callback, no less than 5 minutes old
     *  - etc
     *
     *  Result set contains:
     *  - rootId: the "parent" id of a group of transactions
     *  - transactionId: o_O
     *  - type: the lead type
     *  - styleCode: ctm|choosi|etc
     *  - ipAddress: the client's IP address
     *
     * @see LeadsConfig
     *
     * @param verticalCode
     * @param brandCodeId
     * @return
     * @throws NamingException
     * @throws SQLException
     */
    public ResultSet getRawTransactions(String verticalCode, Integer brandCodeId) throws NamingException, SQLException {
        PreparedStatement stmt;


        stmt = dbSource.getConnection().prepareStatement(
                "SELECT h.rootId AS rootId, h.TransactionId AS transactionId, t.type AS type, h.styleCode, h.ipAddress " +
                        "FROM aggregator.transaction_header AS h " +
                        "LEFT JOIN ctm.touches AS t ON t.transaction_id = h.TransactionId AND t.type IN  (" + String.join(", ", config.getLeadTypes()) + ") " +
                        "WHERE h.ProductType = ? AND h.styleCodeId = ? " +
                        // Next line is important as it greatly reduces the size of the recordset and query speed overall
                        "AND t.date >= DATE(CURRENT_DATE - INTERVAL " + config.getLeadExpiryTime() + " MINUTE) " +
                        "AND t.transaction_id IS NOT NULL AND t.type IS NOT NULL " +
                        "AND CONCAT_WS(' ', t.date, t.time) <= TIMESTAMP(CURRENT_TIMESTAMP - INTERVAL " + getLeadTypeDelayStatement() + " MINUTE) " +
                        "ORDER BY RootId ASC, transactionId ASC, t.date ASC, t.time ASC;"
        );
        stmt.setString(1, verticalCode);
        stmt.setInt(2, brandCodeId);
        return stmt.executeQuery();

    }

    /**
     * For a given set of transaction IDs, retrieve an aggregated result set containing:
     *
     * - transactionId: o_O
     * - leadNo: identifies which lead the transaction belongs to
     * - leadInfo: a double-pipe separated list of details relatng to the lead (potentially empty)
     * - brandCode: ctm|choosi|etc
     * - followupIntended: Y|N
     * - propensityScore: null, DUPLICATE, double, string
     * - productId: which product the customer was looking at when the lead was generated
     * - moreInfoProductCode: which products the customer requested more info for
     *
     * @param tran
     * @param activeLeadProviders
     * @return
     * @throws SQLException
     * @throws NamingException
     */
    public ResultSet getAggregateLeadData(LeadFeedRootTransaction tran, String activeLeadProviders) throws SQLException, NamingException {
        PreparedStatement stmt;
        stmt = dbSource.getConnection().prepareStatement(
                "SELECT r.TransactionId AS transactionId, p1.Value AS leadNo, " +
                        "p2.Value AS leadInfo, p3.Value AS brandCode, p4.Value AS followupIntended, p5.Value AS propensityScore," +
                        "p1.productId, t.productCode AS moreInfoProductCode, " +
                        // This sub-select will count all leads for the rootID which will eliminate
                        // sending duplicates for transactions that span more than one reporting
                        // period - ie greater than the delay to source leads (in previous select)
                        "(SELECT COUNT(type) FROM ctm.touches WHERE transaction_id IN (" +
                        "		SELECT TransactionId FROM aggregator.transaction_header " +
                        "		WHERE rootId = '" + tran.getId() + "'" +
                        "	) " +
                        "	AND type IN (" + String.join(", ", config.getLeadTypes()) + ")" +
                        ") AS existingLeadCount " +
                        "FROM aggregator.ranking_details AS r " +
                        "LEFT JOIN aggregator.results_properties AS p5 " +
                        "	ON p5.transactionId = r.TransactionId AND p5.productId = r.Value AND p5.property = 'propensityScore' " +
                        "LEFT JOIN aggregator.results_properties AS p1 " +
                        "	ON p1.transactionId = r.TransactionId AND p1.productId = r.Value AND p1.property = 'leadNo' " +
                        "LEFT JOIN aggregator.results_properties AS p2  " +
                        "	ON p2.transactionId = r.TransactionId AND p2.productId = r.Value AND p2.property = 'leadfeedinfo' " +
                        "LEFT JOIN aggregator.results_properties AS p3  " +
                        "	ON p3.transactionId = r.TransactionId AND p3.productId = r.Value AND p3.property = 'brandCode' " +
                        "LEFT JOIN aggregator.results_properties AS p4  " +
                        "	ON p4.transactionId = r.TransactionId AND p4.productId = r.Value AND p4.property = 'followupIntended' " +
                        " left join (select tp.productCode, t.transaction_id as transactionId from ctm.touches t join ctm.touches_products tp on t.id = tp.touchesId where t.type = 'MoreInfo') as t " +
                        " on t.transactionId = r.transactionId and t.productCode = r.value and r.property = 'productId' " +
                        // minimise the execution plan's initial resultset based on a smaller set of IDs.
                        "WHERE r.TransactionId >= " + tran.getMinTransactionId() + " AND r.TransactionId <= " + tran.getMaxTransactionId() + " " +
                        "	AND r.TransactionId IN (" + tran.toString() + ") " +
                        "	AND r.RankPosition = 0 " +
                        "	AND r.Value REGEXP '" + activeLeadProviders + "' " +
                        "	AND p2.Value IS NOT NULL AND p2.Value != '' " +
                        "GROUP BY transactionId, leadNo, leadInfo, brandCode " +
                        "HAVING existingLeadCount = 0 " +
                        "ORDER BY r.TransactionId ASC, r.RankSequence DESC;"
        );

        return stmt.executeQuery();
    }


    /**
     * Build a SQL `CASE` statement for lead type delays to insert into the query in `getRawTransactions`.
     *
     * Basically just a helper.
     *
     * @return
     */
    protected String getLeadTypeDelayStatement() {
        Map<String, Long> delays = config.getLeadTypeDelays();
        StringBuilder substatement = new StringBuilder(" CASE ");
        for (Map.Entry<String, Long> leadType : delays.entrySet()) {
            substatement.append(" WHEN type = " + leadType.getKey() + " THEN " + leadType.getValue());
        }
        return substatement.append(" ELSE 0 END ").toString();
    }

    /**
     * External access to close the database connection.
     */
    public void close(){
        dbSource.closeConnection();
    }
}
