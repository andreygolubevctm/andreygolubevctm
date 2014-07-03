package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.results.ResultRanking;

public class ResultsDao {

	/**
	 * Returns an array of product properties stored against a transaction id.
	 * These are specific xpaths from the results set that were stored after the results were returned.
	 *
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<ResultProperty> getResultPropertiesForTransaction(Long transactionId) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<ResultProperty> properties = new ArrayList<ResultProperty>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT transactionId, productId, property, value " +
				"FROM aggregator.results_properties rp " +
				"WHERE rp.transactionId = ? ; "
			);

			stmt.setLong(1, transactionId);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {

				ResultProperty property = new ResultProperty();
				property.setTransactionId(result.getLong("transactionId"));
				property.setProductId(result.getString("productId"));
				property.setProperty(result.getString("property"));
				property.setValue(result.getString("value"));
				properties.add(property);

			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return properties;
	}


	/**
	 * Return an array of Ranking positions from a results set.
	 * The objects contain the rank position and the product id. They are sorted in ascending order.
	 *
	 * @param transactionId
	 * @param numberOfRankingsToReturn
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<ResultRanking> getMostRecentRankingsForTransactionId(long transactionId, int numberOfRankingsToReturn) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<ResultRanking> rankings = new ArrayList<ResultRanking>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT TransactionId AS transactionId, Property AS productId, Value AS textValue, RankPosition as rankPosition " +
				"FROM aggregator.ranking_details " +
				"WHERE TransactionId = ? AND "+
					"CalcSequence = (SELECT MAX(CalcSequence) FROM aggregator.ranking_details WHERE TransactionId = ?) AND " +
					"RankSequence = (SELECT MAX(RankSequence) FROM aggregator.ranking_details WHERE TransactionId = ?) AND " +
					"RankPosition < ? " +
				"ORDER BY rankPosition ASC; "
			);

			stmt.setLong(1, transactionId);
			stmt.setLong(2, transactionId);
			stmt.setLong(3, transactionId);
			stmt.setInt(4, numberOfRankingsToReturn);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {

				ResultRanking ranking = new ResultRanking();
				ranking.setTransactionId(result.getLong("transactionId"));
				ranking.setProductId(result.getString("textValue"));
				ranking.setRankPosition(result.getInt("rankPosition"));
				rankings.add(ranking);

			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return rankings;
	}

}
