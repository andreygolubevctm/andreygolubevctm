package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

@Repository
public class RankingMasterDao {

    private static final Logger LOGGER = LoggerFactory.getLogger(RankingMasterDao.class);
    private SimpleDatabaseConnection dbSource;

    public RankingMasterDao() {
        this.dbSource = new SimpleDatabaseConnection();
    };

    public String getLatestRankingMasterValue(Long transactionId, String rankBy) throws DaoException {
        String latestValue = null;
        try {
            PreparedStatement stmt;
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT RankBy " +
                            "FROM aggregator.ranking_master " +
                            "WHERE TransactionId = ? " +
                            "and RankBy like ? " +
                            "ORDER BY RankSequence desc, lastUpdated desc " +
                            "LIMIT 1;"
            );
            stmt.setLong(1 , transactionId);
            stmt.setString(2, rankBy + "%");
            ResultSet resultSet = stmt.executeQuery();
            if(resultSet.next()){
                resultSet.first();
                latestValue = resultSet.getString("RankBy");
            }
        } catch (Exception e) {
            LOGGER.error("Failed to retrieve latest RankingMaster record for transactionId: {}, rankBy: {} ", transactionId, rankBy, e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
        return latestValue;
    }
}
