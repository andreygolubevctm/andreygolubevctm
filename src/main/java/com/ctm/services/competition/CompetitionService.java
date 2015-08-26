package com.ctm.services.competition;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;

import com.ctm.dao.competition.CompetitionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.services.ApplicationService;

import java.util.Date;

public class CompetitionService {

	private static Logger logger = Logger.getLogger(CompetitionService.class.getName());

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
			logger.error(e);
		}

		return compActive;
	}
}
