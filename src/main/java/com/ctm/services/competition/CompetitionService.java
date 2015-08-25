package com.ctm.services.competition;

import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger; import org.slf4j.LoggerFactory;

import com.ctm.dao.competition.CompetitionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.services.ApplicationService;

public class CompetitionService {

	private static final Logger logger = LoggerFactory.getLogger(CompetitionService.class.getName());

	/**
	 * isActive - returns whether the nominated competition exists and is active
	 *
	 * @param request
	 * @param competitionId
	 * @return
	 */
	public static Boolean isActive(HttpServletRequest request, Integer competitionId) {

		Boolean compActive = false;

		try {
			Brand brand = ApplicationService.getBrandFromRequest(request);
			compActive = CompetitionDao.isActive(brand.getId(), competitionId);

		} catch (DaoException e) {
			logger.error("{}",e);
		}

		return compActive;
	}
}
