package com.ctm.statistics;

import com.ctm.web.core.dao.StatisticsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.statistics.dao.StatisticDetail;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;
import java.util.List;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class StatisticsService {

	private static final Logger LOGGER = LoggerFactory.getLogger(StatisticsService.class);
	private final StatisticsDao dao;

	public StatisticsService() {
		dao = new StatisticsDao();
	}

	/**
	 * Write statistics to statistic_master, statistic_details, and statistic_description
	 * @param statisticDetailsResults The statistics details to write
	 * @param transactionId the transaction that these statistic will be written against
	 * @return calcSequence that was created in aggregator.statistic_master
	 * @throws SQLException
	 **/
	public int writeStatistics(List<StatisticDetail> statisticDetailsResults, long transactionId)  {
		int calcSequence = 0;
		try {
			calcSequence = dao.getNextCalcSequence(transactionId);
			dao.insertIntoStatisticsMaster(transactionId, calcSequence);
			dao.insertDetails(statisticDetailsResults, transactionId, calcSequence);
		} catch (DaoException e) {
			LOGGER.error("Failed to write to database. {}" , kv("statisticDetailsResults",statisticDetailsResults));
		}
		return calcSequence;
	}

}
