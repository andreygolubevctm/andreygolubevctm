package com.ctm.web.core.services;

import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.dao.RankingMasterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.results.dao.ResultsDao;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.results.model.ResultRanking;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringJoiner;

public class ResultsService {

    public static final List<String> VERTICAL_LIST = Arrays.asList("car", "home");
    public static final List<String> PROVIDER_LIST = Arrays.asList("REIN","WOOL");
    public static final String MONTHLY_PAYMENT_FREQUENCY = "monthly";
    public static final String RANKED_BY_PRICE = "price";

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
     * @return
     * @throws DaoException
     */
    public static ArrayList<ResultProperty> getResultsPropertiesForTransactionId(Long transactionId, String productId) throws DaoException{

        ResultsDao resultsDao = new ResultsDao();
        ArrayList<ResultProperty> properties = resultsDao.getResultPropertiesForTransaction(transactionId, productId);
        return properties;

    }

    public static String getQuoteUrl(Long transactionId, String productId, String property, String providerCode, String vertical) throws DaoException {
        String propertyValue = getSingleResultPropertyValue(transactionId, productId, property);
        StringJoiner sj = new StringJoiner("&");
        sj.add(propertyValue);
        if(VERTICAL_LIST.contains(vertical) && PROVIDER_LIST.contains(providerCode)){
            //get latest payment frequency selected by user
            RankingMasterDao rankingMasterDao = new RankingMasterDao();
            String paymentFrequency = null;
            try {
                paymentFrequency = rankingMasterDao.getLatestRankingMasterValue(transactionId, RANKED_BY_PRICE);
            } catch(DaoException de) {
                paymentFrequency = "";
            }
            sj.add(paymentFrequency.toLowerCase().contains(MONTHLY_PAYMENT_FREQUENCY) ? "pf=m" : "pf=a");
        }
        return sj.toString();
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

    public static void saveResultsProperties(List<ResultProperty> resultProperties) throws Exception {
        ResultsDao resultsDao = new ResultsDao();
        resultsDao.saveResultsProperties(resultProperties);
    }

}
