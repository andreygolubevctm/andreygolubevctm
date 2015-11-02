package com.ctm.web.simples.dao;


import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.common.utils.StringUtils;
import com.ctm.web.simples.model.ConfirmationOperator;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class SimplesTransactionDao {

    /**
     * Check the transactions chained from the provided RootId and find any confirmation (sold) information.
     * @return Valid object or null
     */
    public ConfirmationOperator getConfirmationFromTransactionChain(List<Long> rootIds) throws DaoException {
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        if (rootIds == null || rootIds.isEmpty()) {
            return null;
        }
        try {
            PreparedStatement stmt;

            stmt = dbSource.getConnection().prepareStatement(
                    "Select transactionId, operator_id, CONCAT(date, ' ', time)  AS datetime from ( " +
                            "	SELECT th.transactionId, tc.operator_id, tc.date, tc.time " +
                            "	FROM aggregator.transaction_header th " +
                            "	JOIN ctm.touches tc ON th.transactionID = tc.transaction_Id AND tc.`type` = 'C' " +
                            "	WHERE rootID in ( " + StringUtils.sqlQuestionMarkStringBuilder(rootIds.size()) + " ) " +
                            "	UNION ALL " +
                            "	SELECT th.transactionId, tc.operator_id, tc.`date`, tc.`time` " +
                            "	FROM aggregator.transaction_header2_cold th " +
                            "	JOIN ctm.touches tc ON th.transactionID = tc.transaction_Id AND tc.`type` = 'C' " +
                            "	WHERE rootID in ( " + StringUtils.sqlQuestionMarkStringBuilder(rootIds.size()) + " )" +
                            ")a ORDER  BY date DESC ,time desc;"
            );
            int i=1;
            for (long rootId : rootIds) {
                stmt.setLong(i++,rootId);
            }
            for (long rootId : rootIds) {
                stmt.setLong(i++,rootId);
            }

            ResultSet results = stmt.executeQuery();

            if (results.next()) {
                ConfirmationOperator confirmationOperator = new ConfirmationOperator();
                confirmationOperator.setTransactionId(results.getLong("transactionId"));
                confirmationOperator.setOperator(results.getString("operator_id"));
                confirmationOperator.setDatetime(results.getTimestamp("datetime"));
                return confirmationOperator;
            }
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }

        return null;
    }

}
