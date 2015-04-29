package com.ctm.dao.transaction;

import com.ctm.dao.DatabaseUpdateMapping;
import com.ctm.dao.SqlDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.transaction.TransactionLock;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;

public class TransactionLockDao {

    private final SqlDao<TransactionLock> sqlDao = new SqlDao<>();

    public void insert(final Long transactionId ,  final String operatorId) throws DaoException {
        sqlDao.insert(
                new DatabaseUpdateMapping(){
                    @Override
                    public void handleParams(PreparedStatement stmt) throws SQLException {
                        stmt.setLong(1, transactionId);
                        stmt.setString(2, operatorId);
                    }
                },
                "INSERT INTO `aggregator`.`transaction_locks` " +
                "( `transactionId`, `operatorId`, lockDateTime) " +
                "VALUES (?,?, now())" +
                " ON DUPLICATE KEY UPDATE operatorId=VALUES(operatorId), lockDateTime=VALUES(lockDateTime);"
        );
    }

    public TransactionLock getLatest(final long transactionId) throws DaoException {
        return sqlDao.get(
                new DatabaseQueryMapping<TransactionLock> (){
                    @Override
                    public void handleParams(PreparedStatement stmt) throws SQLException {
                        stmt.setLong(1, transactionId);
                    }

                    @Override
                    public TransactionLock handleResult(ResultSet rs) throws SQLException {
                        TransactionLock transactionLock = new TransactionLock();
                        transactionLock.operatorId = rs.getString("operatorId");
                        Calendar start = Calendar.getInstance();
                        start.setTimeInMillis( rs.getTimestamp("lockDateTime").getTime() );
                        transactionLock.lockDateTime = start.getTime();
                        return transactionLock;
                    }
                }, "SELECT operatorId, lockDateTime \n" +
                        "FROM aggregator.transaction_locks \n" +
                        "WHERE transactionId = ? \n" +
                        "AND TIMESTAMP(NOW() - INTERVAL 2 MINUTE) < TIMESTAMP(lockDateTime) \n" +
                        "LIMIT 1;"
        );
    }

    public void cleanupOldLocks() throws DaoException {
        sqlDao.update(
                "DELETE FROM aggregator.transaction_locks " +
                "WHERE TIMESTAMP(NOW() - INTERVAL 7 DAY ) > TIMESTAMP(lockDateTime);");
    }
}
