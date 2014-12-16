package com.ctm.services.car;

import org.apache.log4j.Logger;
import com.ctm.exceptions.DaoException;
import com.ctm.dao.car.CarModelDao;

public class PopularModelsService {

	private static Logger logger = Logger.getLogger(PopularModelsService.class.getName());

	/**
	 * execute() calls the CarModelDao to execute the method which updates
	 * the popular models table.
	 *
	 * @return String the datetime the last update occurred
	 */
	public String execute() {

		try {

			CarModelDao carModelDao = new CarModelDao();
			carModelDao.updatePopularModels();
			String lastUpdate = carModelDao.getLastUpdate();

			return lastUpdate;

		} catch (DaoException e) {
			logger.error(e);

			return e.getMessage();
		}
	}
}
