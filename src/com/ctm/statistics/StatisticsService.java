package com.ctm.statistics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.ctm.statistics.dao.StatisticDescription;
import com.ctm.statistics.dao.StatisticDetail;

public class StatisticsService {

	private static Logger logger = Logger.getLogger(StatisticsService.class.getName());

	private DataSource ds;

	public StatisticsService() {
		Context initCtx;
		try {
			initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			// Look up our data source
			ds = (DataSource) envCtx.lookup("jdbc/aggregator");
		} catch (NamingException e) {
			logger.error("Failed to get InitialContext for jdbc/aggregator" , e);
		}
	}

	/**
	 * Write statistics to statistic_master, statistic_details, and statistic_description
	 * @param statisticDetailsResults
	 * @param tranId the transaction that these statistic will be written against
	 * @return calcSequence that was created in aggregator.statistic_master
	 * @throws SQLException
	 **/
	public int writeStatistics(List<StatisticDetail> statisticDetailsResults , int tranId) throws SQLException {
		Connection conn = null;
		int calcSequence = 1;
		try {
			PreparedStatement stmt;
			conn = ds.getConnection();
			stmt = conn.prepareStatement(
				"SELECT max(CalcSequence) AS calcSequence " +
				"FROM aggregator.statistic_master " +
				"WHERE TransactionId=?;" ,
				java.sql.Statement.RETURN_GENERATED_KEYS
			);

			stmt.setInt(1, tranId);
			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				calcSequence += result.getInt("calcSequence") ;
			}

			stmt = conn.prepareStatement(
				"INSERT INTO aggregator.statistic_master (TransactionId,CalcSequence,TransactionDate,TransactionTime) " +
				"VALUES (?,?,CURRENT_DATE,CURRENT_TIME)"
				, java.sql.Statement.RETURN_GENERATED_KEYS
			);

			stmt.setInt(1, tranId);
			stmt.setInt(2, calcSequence);
			stmt.executeUpdate();


			if (statisticDetailsResults != null) {
				PreparedStatement stmtDetails = null;
				PreparedStatement stmtDescription = null;

				stmtDetails = conn.prepareStatement(
						"INSERT INTO aggregator.statistic_details (TransactionId,CalcSequence,ServiceId,ProductId,ResponseTime,ResponseMessage) " +
						"VALUES (?,?,?,?,?,?)"
					);

				for(StatisticDetail statisticDetail : statisticDetailsResults) {

					stmtDetails.setInt(1, tranId);
					stmtDetails.setInt(2, calcSequence);
					stmtDetails.setString(3, statisticDetail.getServiceId());
					stmtDetails.setString(4, statisticDetail.getProductId());
					stmtDetails.setString(5, statisticDetail.getResponseTime());
					stmtDetails.setString(6, statisticDetail.getResponseMessage());

					// build up the batch insert
					stmtDetails.addBatch();

					if (statisticDetail.getStatisticDescription() != null) {
						StatisticDescription statisticDescription = statisticDetail.getStatisticDescription();

						if (stmtDescription == null)
						{
							stmtDescription = conn.prepareStatement(
									"INSERT INTO aggregator.statistic_description (TransactionId,CalcSequence,ServiceId,ErrorType, ErrorMessage, ErrorDetail) " +
									"VALUES (?,?,?,?,?,?)"
							);
						}

						stmtDescription.setInt(1, tranId);
						stmtDescription.setInt(2, calcSequence);
						stmtDescription.setString(3, statisticDetail.getServiceId());
						stmtDescription.setString(4, statisticDescription.getErrorType());
						stmtDescription.setString(5, statisticDescription.getErrorMessage());
						stmtDescription.setString(6, statisticDescription.getErrorDetail());

						// build up the batch insert
						stmtDescription.addBatch();
					}
				}

				stmtDetails.executeBatch();

				if (stmtDescription != null)
				{
					stmtDescription.executeBatch();
				}
			}
		} finally {
			if(conn != null) {
				conn.close();
			}
		}
		return calcSequence;
	}

}
