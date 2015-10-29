package com.ctm.services;

import java.util.ArrayList;
import java.util.List;

import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.dao.ResultsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.RankingDetail;
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
		ArrayList<ResultProperty> properties = resultsDao.getResultPropertiesForTransaction(transactionId, null);
		return properties;

	}

	/**
	 * Returns an array of product properties stored against a transaction id.
	 * These are specific xpaths from the results set that were stored after the results were returned.
	 *
	 * @param transactionId
	 * @param productId
	 * @param property
	 * @return propertyValue
	 * @throws DaoException
	 */
	public static String getSingleResultPropertyValue(Long transactionId, String productId, String property) throws DaoException{

		ResultsDao resultsDao = new ResultsDao();
		String propertyValue = resultsDao.getSingleResultPropertyValue(transactionId, productId, property);
		return propertyValue;

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
	public static List<ResultRanking> getRankingsForTransactionId(Long transactionId, int numberOfPositionsToReturn) throws DaoException{

		RankingDetailsDao rankingDetailsDao = new RankingDetailsDao();
		List<RankingDetail> rankings = rankingDetailsDao.getLastestTopRankings(transactionId, numberOfPositionsToReturn);
		List<ResultRanking> resultRankings = new ArrayList<ResultRanking>();
		for(RankingDetail ranking : rankings){
			ResultRanking resultRanking = new ResultRanking();
			resultRanking.setTransactionId(transactionId);
			resultRanking.setProductId(ranking.getProperty("productId"));
			resultRanking.setRankPosition(ranking.getRankPosition());
			resultRankings.add(resultRanking );
		}
		return resultRankings;

	}

    public static void saveResultsProperties(List<ResultProperty> resultProperties) {
        ResultsDao resultsDao = new ResultsDao();
        resultsDao.saveResultsProperties(resultProperties);
    }

}
