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

	public static void logFatalError(Exception exception, int styleCodeId, String page , String sessionId, boolean isFatal, String transactionId) {
		String description = exception.getMessage();
		String message = exception.getMessage();
		if(exception.getCause() != null) {
			description = exception.getCause().getMessage();
		}

		if(message == null) message = "UNKNOWN";

		logFatalError(styleCodeId, page, sessionId, isFatal, message, description, transactionId);
	}

	public static void logFatalError(Exception exception, int styleCodeId, String page , String sessionId, boolean isFatal) {
		String description = exception.getMessage();
		String message = exception.getMessage();
		if(exception.getCause() != null) {
			description = exception.getCause().getMessage();
		}


		logFatalError(styleCodeId, page, sessionId, isFatal, message, description, null);
	}

	public static void logFatalError(int styleCodeId, String page , String sessionId, boolean isFatal, String message, String description, String transactionId) {
		if(message.length() > 255){
			message = message.substring(0, 255);
		}

		if(page.length() > 45) {
			page = page.substring(0, page.length() - 45);
		}

		FatalErrorDao fatalErrorDao = new FatalErrorDao();
		FatalError fatalError = new FatalError();
		fatalError.setStyleCodeId(styleCodeId);
		fatalError.setPage(page);
		fatalError.setmessage(message);
		fatalError.setDescription(description);
		fatalError.setSessionId(sessionId);
		fatalError.setTransactionId(transactionId);
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

	public static void logFatalError(Exception exception, int styleCodeId, String page , String sessionId, boolean isFatal, Long transactionId) {
		logFatalError(exception, styleCodeId, page,
				sessionId, isFatal, String.valueOf(transactionId));
	}

}
