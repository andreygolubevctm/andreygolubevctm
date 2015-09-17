package com.ctm.services.competition;

import com.ctm.dao.competition.CompetitionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.services.ApplicationService;
import org.apache.commons.lang3.tuple.Pair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;

public class CompetitionService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CompetitionService.class);

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
			LOGGER.error("Failed to determine if competition is active competitionId={},{}", kv("competitionId", competitionId), kv("serverDate", serverDate), e);
		}

		return compActive;
	}

	public static boolean addCompetitionEntry(Integer competitionId, Integer emailId, List<Pair<String, String>> items) {
		try {
			CompetitionDao.addCompetitionEntry(competitionId, emailId, items);
			return true;
		} catch (DaoException e) {
			return false;
		}
	}


}
