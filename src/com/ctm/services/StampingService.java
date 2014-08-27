package com.ctm.services;

import org.apache.log4j.Logger;

import com.ctm.dao.StampingDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Stamping;
/**
 * Used to write stamp to the database
 */
public class StampingService {

	private static Logger logger = Logger.getLogger(StampingService.class.getName());

	public static void writeStamp(int styleCodeId, String action, String brand, String vertical, String target, String value, String operatorId, String comment, String ipAddress) {
		Stamping stamping = new Stamping();

		stamping.setStyleCodeId(styleCodeId);
		stamping.setAction(action);
		stamping.setBrand(brand);
		stamping.setVertical(vertical);
		stamping.setTarget(target);
		stamping.setValue(value);
		stamping.setOperatorId(operatorId);
		stamping.setComment(comment);
		stamping.setIpAddress(ipAddress);

		StampingDao stampingDao = new StampingDao();
		try {
			stampingDao.add(stamping);
		} catch (DaoException e) {
			logger.error("cannot write stamp" , e);
		}
	}

}
