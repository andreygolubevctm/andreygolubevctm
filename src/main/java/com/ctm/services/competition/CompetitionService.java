package com.ctm.services.competition;

import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.dao.competition.CompetitionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.services.ApplicationService;

import java.util.Date;

import static com.ctm.logging.LoggingArguments.kv;

public class CompetitionService {

	private static final Logger logger = LoggerFactory.getLogger(CompetitionService.class);

	/**
	 * isActive - returns whether the nominated competition exists and is active
	 *
	 * @param request
	 * @param competitionId
	 * @return
	 */
	public static Boolean isActive(HttpServletRequest request, Integer competitionId) {
		Boolean compActive = false;
		Date serverDate = ApplicationService.getApplicationDate(request);

		try {
			Brand brand = ApplicationService.getBrandFromRequest(request);
			compActive = CompetitionDao.isActive(brand.getId(), competitionId, serverDate);
		} catch (DaoException e) {
			logger.error("Failed to determine if competition is active competitionId={},{}", kv("competitionId", competitionId), kv("serverDate", serverDate), e);
			// Failed to determine if competition is active competitionId=abc 2345, serverDate=
		}

		return compActive;
	}
}
