package com.ctm.services;

import java.util.ArrayList;

import com.ctm.dao.ResultsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.results.ResultRanking;

public class ResultsService {

	/**
	 * Returns an array of product properties stored against a transaction id.
	 * These are specific xpaths from the results set that were stored after the results were returned.
	 *
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<ResultProperty> getResultsPropertiesForTransactionId(Long transactionId) throws DaoException{

		ResultsDao resultsDao = new ResultsDao();
		ArrayList<ResultProperty> properties = resultsDao.getResultPropertiesForTransaction(transactionId);
		return properties;

	}

	/**
	 * Return an array of Ranking positions from a results set.
	 * The objects contain the rank position and the product id. They are sorted in ascending order.
	 *
	 * @param transactionId
	 * @param numberOfPositionsToReturn
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<ResultRanking> getRankingsForTransactionId(Long transactionId, int numberOfPositionsToReturn) throws DaoException{

		ResultsDao resultsDao = new ResultsDao();
		ArrayList<ResultRanking> rankings = resultsDao.getMostRecentRankingsForTransactionId(transactionId, numberOfPositionsToReturn);
		return rankings;

	}

}
