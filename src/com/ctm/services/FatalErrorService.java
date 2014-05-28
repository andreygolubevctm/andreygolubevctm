package com.ctm.services;

import org.apache.log4j.Logger;

import com.ctm.dao.FatalErrorDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.FatalError;
/**
 * Used to log errors to the database
 */
public class FatalErrorService {

	private static Logger logger = Logger.getLogger(FatalErrorService.class.getName());

	public static void logFatalError(Exception exception, int styleCodeId, String page , String sessionId, boolean isFatal) {
		FatalErrorDao fatalErrorDao = new FatalErrorDao();
		FatalError fatalError = new FatalError();
		fatalError.setStyleCodeId(styleCodeId);
		fatalError.setPage(page);
		fatalError.setmessage(exception.getMessage());
		if(exception.getCause() != null) {
			fatalError.setDescription(exception.getCause().getMessage());
		}
		fatalError.setSessionId(sessionId);
		if(isFatal) {
			fatalError.setFatal("1");
		} else {
			fatalError.setFatal("0");
		}
		try {
			fatalErrorDao.add(fatalError);
		} catch (DaoException e) {
			logger.fatal("cannot log to fatal error table" , e);
		}
	}

}
