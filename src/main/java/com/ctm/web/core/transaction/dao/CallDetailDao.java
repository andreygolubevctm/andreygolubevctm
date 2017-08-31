package com.ctm.web.core.transaction.dao;

import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.model.CallDetail;
import com.ctm.web.core.transaction.model.TransactionLock;
import org.springframework.stereotype.Repository;

import java.sql.SQLException;

@Repository
public class CallDetailDao {

    public CallDetailDao(){

    }

    private final SqlDao<TransactionLock> sqlDao = new SqlDao<>();

    public void insert(final CallDetail callDetail) throws DaoException {
        sqlDao.update(
                new DatabaseUpdateMapping() {
                    @Override
                    public void mapParams() throws SQLException {
                        set(callDetail.getTransactionId());
                        set(callDetail.getCallIdKey());
                    }

                    @Override
                    public String getStatement() {
                        return  "INSERT INTO `aggregator`.`transaction_call_details` " +
                                "( `transactionId`, `callIdKey`,`lastUpdated`) " +
                                "VALUES (?,?, now()) " +
                                " ON DUPLICATE KEY UPDATE callIdKey=VALUES(callIdKey) , lastUpdated=VALUES(lastUpdated)";

                    }
                }
        );
    }
}
