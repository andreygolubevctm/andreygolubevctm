package com.ctm.web.core.transaction.dao;

import com.ctm.web.core.dao.DatabaseQueryMapping;
import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.model.TransactionLock;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;

public class TransactionLockDao {

    private final SqlDao<TransactionLock> sqlDao = new SqlDao<>();

    public void insert(final Long transactionId ,  final String operatorId) throws DaoException {
        sqlDao.update(
                new DatabaseUpdateMapping() {
                    @Override
                    public void mapParams() throws SQLException {
                        set(transactionId);
                        set(operatorId);
                    }

                    @Override
                    public String getStatement() {
                        return  "INSERT INTO `aggregator`.`transaction_locks` " +
                                "( `transactionId`, `operatorId`, lockDateTime) " +
                                "VALUES (?,?, now())" +
                                " ON DUPLICATE KEY UPDATE operatorId=VALUES(operatorId), lockDateTime=VALUES(lockDateTime);";
                    }
                }
        );
    }

    public TransactionLock getLatest(final long transactionId) throws DaoException {
        return sqlDao.get(
                new DatabaseQueryMapping<TransactionLock> (){
                    @Override
                    public void mapParams() throws SQLException {
                        set(transactionId);
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

    public void unlock(final long transactionId) throws DaoException {
        sqlDao.update(
            new DatabaseUpdateMapping() {
                @Override
                protected void mapParams() throws SQLException {
                    set(transactionId);
                }

                @Override
                public String getStatement() {
                    return "DELETE FROM aggregator.transaction_locks " +
                            "WHERE transactionId = ?;";
                }
            });
    }
}
