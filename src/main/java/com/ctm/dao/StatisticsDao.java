package com.ctm.dao;


import com.ctm.exceptions.DaoException;
import com.ctm.statistics.dao.StatisticDescription;
import com.ctm.statistics.dao.StatisticDetail;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StatisticsDao {

    private final SqlDao sqlDao = new SqlDao();

    public void insertDetails(List<StatisticDetail> statisticDetailsResults, final long transactionId, final int calcSequence) throws DaoException {
        if (statisticDetailsResults != null) {
                List<DatabaseUpdateMapping> databaseMappings = new ArrayList<>();
                List<DatabaseUpdateMapping> databaseMappingsDescriptions = new ArrayList<>();

                for (StatisticDetail statisticDetail : statisticDetailsResults) {
                    // build up the batch insert
                    DatabaseUpdateMapping mapping= new DatabaseUpdateMapping(){

                        @Override
                        protected void mapParams() throws SQLException {
                            set(transactionId);
                            set(calcSequence);
                            set(statisticDetail.getServiceId());
                            set(statisticDetail.getProductId());
                            set(statisticDetail.getResponseTime());
                            set(statisticDetail.getResponseMessage());
                        }

                        @Override
                        public String getStatement() {
                            return null;
                        }
                    };
                    databaseMappings.add(mapping);

                    if (statisticDetail.getStatisticDescription() != null) {
                        StatisticDescription statisticDescription = statisticDetail.getStatisticDescription();
                        mapping= new DatabaseUpdateMapping(){

                            @Override
                            protected void mapParams() throws SQLException {
                                set(transactionId);
                                set(calcSequence);
                                set(statisticDetail.getServiceId());
                                set(statisticDescription.getErrorType());
                                set(statisticDescription.getErrorMessage());
                                set(statisticDescription.getErrorDetail());
                            }

                            @Override
                            public String getStatement() {
                                return null;
                            }
                        };
                        databaseMappingsDescriptions.add(mapping);
                    }
                }
                sqlDao.executeBatch(databaseMappings, "INSERT INTO aggregator.statistic_details (TransactionId,CalcSequence,ServiceId,ProductId,ResponseTime,ResponseMessage) " +
                        "VALUES (?,?,?,?,?,?)");

                if (!databaseMappingsDescriptions.isEmpty()) {
                    sqlDao.executeBatch(databaseMappingsDescriptions, "INSERT INTO aggregator.statistic_description (TransactionId,CalcSequence,ServiceId,ErrorType, ErrorMessage, ErrorDetail) " +
                            "VALUES (?,?,?,?,?,?)");
                }
            }
    }

    public void insertIntoStatisticsMaster(final long transactionId, final int calcSequence) throws DaoException {
        sqlDao.update(new DatabaseUpdateMapping() {
            @Override
            protected void mapParams() throws SQLException {
                set(transactionId);
                set(calcSequence);
            }

            @Override
            public String getStatement() {
                return "INSERT INTO aggregator.statistic_master (TransactionId,CalcSequence,TransactionDate,TransactionTime) " +
                        "VALUES (?,?,CURRENT_DATE,CURRENT_TIME)";
            }
        });
    }

    public int getNextCalcSequence(final long transactionId) throws DaoException {
        int calcSequence = 1;
        calcSequence += new SqlDao<Integer>().get(new DatabaseQueryMapping<Integer>() {

            @Override
            protected void mapParams() throws SQLException {
                set(transactionId);
            }

            @Override
            public Integer handleResult(ResultSet rs) throws SQLException {
                return rs.getInt("calcSequence");
            }
        } , "SELECT max(CalcSequence) AS calcSequence " +
                        "FROM aggregator.statistic_master " +
                        "WHERE TransactionId=?;");
        return calcSequence;
    }
}
