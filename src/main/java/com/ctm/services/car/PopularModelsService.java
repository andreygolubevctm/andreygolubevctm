package com.ctm.services.car;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ctm.exceptions.DaoException;
import com.ctm.dao.car.CarModelDao;

public class PopularModelsService {

	private static final Logger LOGGER = LoggerFactory.getLogger(PopularModelsService.class);

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
			LOGGER.error("Error updating popular models", e);
			return e.getMessage();
		}
	}
}
