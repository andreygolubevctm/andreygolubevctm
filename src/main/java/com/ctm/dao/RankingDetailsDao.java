package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import org.slf4j.Logger; import org.slf4j.LoggerFactory;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.RankingDetail;

public class RankingDetailsDao {

	private static final Logger logger = LoggerFactory.getLogger(RankingDetailsDao.class.getName());

	private SimpleDatabaseConnection dbSource;

	public RankingDetailsDao() {
		this.dbSource = new SimpleDatabaseConnection();
	};
	
	public List<RankingDetail> getDetailsByPropertyValue(Long transactionId, String property, String value) throws DaoException {
		List<RankingDetail> rankingDetails= new ArrayList<RankingDetail>();
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
					stmt = conn.prepareStatement(
						"SELECT rd.TransactionId AS transactionId, rd.Property, rd.Value, rd.RankPosition " +
						"FROM ( " +
							"SELECT transactionid, CalcSequence, RankSequence, RankPosition " +
							"FROM aggregator.ranking_details " +
							"WHERE TransactionId = ? " +
							"AND Property = ? " +
							"AND Value = ? " +
							"ORDER BY CalcSequence, RankPosition ASC " +
						") AS rankDetails " +
						"INNER JOIN aggregator.ranking_details rd ON rd.transactionid = rankDetails.transactionid " +
						"WHERE rd.CalcSequence = rankDetails.CalcSequence AND rd.RankSequence = rankDetails.RankSequence AND rd.RankPosition = rankDetails.RankPosition;"
					);

				stmt.setLong(1 , transactionId);
				stmt.setString(2 , property);
				stmt.setString(3 , value);

				ResultSet resultSet = stmt.executeQuery();

				long currentPosition = -1;
				RankingDetail rankingDetail = null;

				while (resultSet.next()) {
					int rankPosition = resultSet.getInt("RankPosition");
					if(rankPosition != currentPosition){
						rankingDetail = new RankingDetail();
						rankingDetail.setRankPosition(rankPosition);
						rankingDetail.setTransactionId(resultSet.getLong("transactionId"));
						rankingDetails.add(rankingDetail);
						currentPosition = rankPosition;
					}
					rankingDetail.addProperty(resultSet.getString("Property") , resultSet.getString("Value"));
				}
			}
		} catch (SQLException e) {
			logger.error("failed to get ranking details" , e);
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			logger.error("failed to get ranking details" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return rankingDetails;
	}

	public List<RankingDetail> getLastestTopFiveRankings(Long transactionId) throws DaoException {
		return getLastestTopRankings(transactionId , 5);
	}

	public List<RankingDetail> getLastestTopRankings(Long transactionId, int numberOfRankingsToReturn) throws DaoException {

		List<RankingDetail> rankingDetails= new ArrayList<RankingDetail>();
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
					stmt = conn.prepareStatement(
					"SELECT TransactionId AS transactionId, Property, Value, RankPosition " +
					"FROM aggregator.ranking_details rd " +
					"WHERE rd.TransactionId = ? " +
					"AND rd.CalcSequence = ( " +
					"SELECT MAX(CalcSequence) " +
					"FROM aggregator.ranking_details " +
					"WHERE TransactionId = rd.TransactionId " +
					") " +
					"AND RankSequence = ( " +
					"SELECT MAX(RankSequence) " +
					"FROM aggregator.ranking_details " +
					"WHERE TransactionId = rd.TransactionId " +
					") " +
					" AND RankPosition < ? " +
					"ORDER BY RankPosition ASC; "
				);

				stmt.setLong(1 , transactionId);
				stmt.setInt(2 , numberOfRankingsToReturn);

				ResultSet resultSet = stmt.executeQuery();

				long currentPosition = -1;
				RankingDetail rankingDetail = null;

				while (resultSet.next()) {
					int rankPosition = resultSet.getInt("RankPosition");
					if(rankPosition != currentPosition){
						rankingDetail = new RankingDetail();
						rankingDetail.setRankPosition(rankPosition);
						rankingDetail.setTransactionId(resultSet.getLong("transactionId"));
						rankingDetails.add(rankingDetail);
						currentPosition = rankPosition;
					}
					rankingDetail.addProperty(resultSet.getString("Property") , resultSet.getString("Value"));
				}
			}
		} catch (SQLException e) {
			logger.error("failed to get ranking details" , e);
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			logger.error("failed to get ranking details" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return rankingDetails;

	}

}
