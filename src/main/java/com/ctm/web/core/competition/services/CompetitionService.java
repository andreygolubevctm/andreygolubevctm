package com.ctm.web.core.competition.services;

import com.ctm.web.core.competition.dao.CompetitionDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.ApplicationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

import static com.ctm.web.core.logging.LoggingArguments.kv;

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
}
