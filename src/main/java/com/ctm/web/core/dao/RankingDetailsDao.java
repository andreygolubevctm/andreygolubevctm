package com.ctm.web.core.dao;

import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


@Repository
public class RankingDetailsDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(RankingDetailsDao.class);

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
						") AS rankDetails " +
						"INNER JOIN aggregator.ranking_details rd ON rd.transactionid = rankDetails.transactionid " +
						"WHERE rd.CalcSequence = rankDetails.CalcSequence AND rd.RankSequence = rankDetails.RankSequence AND rd.RankPosition = rankDetails.RankPosition " +
						"ORDER BY rd.CalcSequence desc, RankPosition ASC;"
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
		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to get ranking details by property value {}, {}, {}", kv("transactionId", transactionId), kv("property", property), kv("value", value), e);
			throw new DaoException(e);
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
		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to get latest top ranking details {}, {}", kv("transactionId", transactionId), kv("numberOfRankingsToReturn", numberOfRankingsToReturn), e);
			throw new DaoException(e);
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		return rankingDetails;

	}

}
