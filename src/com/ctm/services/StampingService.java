package com.ctm.services;

import org.apache.log4j.Logger;

import com.ctm.dao.StampingDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailMaster;
import com.ctm.model.Stamping;
/**
 * Used to write stamp to the database
 */
public class StampingService {

	private static final String MARKETING_ACTION = "toggle_marketing";

	private static Logger logger = Logger.getLogger(StampingService.class.getName());
	private StampingDao stampingDao;

	public StampingService(StampingDao stampingDao){
		this.stampingDao = stampingDao;
	}

	public StampingService(){
		this.stampingDao =  new StampingDao();
	}

	public void writeStamp(int styleCodeId, String action, String brand, String vertical, String target, String value, String operatorId, String comment, String ipAddress) {
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

		try {
			stampingDao.add(stamping);
		} catch (DaoException e) {
			logger.error("cannot write stamp" , e);
		}
	}


	public Stamping writeOptInMarketing(EmailMaster emailDetailsRequest, String operator, boolean optIn, String ipAddress) throws DaoException {
		logger.info(emailDetailsRequest.getTransactionId() + ": " + emailDetailsRequest.getEmailAddress() + " writing to stamping table optIn:" + optIn);
		String value = optIn? "on" : "off";
		return stampingDao.add( MARKETING_ACTION, emailDetailsRequest.getEmailAddress(), value, operator, emailDetailsRequest.getSource(), ipAddress);
	}


}
