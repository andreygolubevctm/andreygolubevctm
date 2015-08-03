package com.ctm.services;

import com.ctm.dao.ScrapesDao;
import com.ctm.exceptions.DaoException;

public class ScrapesService {

	public static String getCallCentreHours() throws DaoException {
		ScrapesDao scrapesDao = new ScrapesDao();
		return scrapesDao.getScrapeHtml(135);

	}

}
