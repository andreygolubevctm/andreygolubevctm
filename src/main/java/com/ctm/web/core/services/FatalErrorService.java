package com.ctm.web.core.services;

import com.ctm.web.core.dao.FatalErrorDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.FatalError;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Used to log errors to the database
 */
public class FatalErrorService {

	private static final Logger LOGGER = LoggerFactory.getLogger(FatalErrorService.class);
	public String sessionId;
	public String page;
	public int styleCodeId;
	public Long transactionId;
	public String property;

	public FatalErrorService(){
		this.sessionId = "";
	}

	public FatalErrorService(String sessionId){
		this.sessionId = sessionId;
	}

	public static void logFatalError(Exception exception, int styleCodeId, String page , String sessionId, boolean isFatal, String transactionId) {
		String message = exception.getMessage();
		if(message == null) message = "UNKNOWN";
		String data = ExceptionUtils.getStackTrace(exception);
		logFatalError(styleCodeId, page, sessionId, isFatal, message, getDescription(exception), transactionId, data, "");
	}

	public void logFatalError(Exception exception, int styleCodeId, String page , boolean isFatal, String transactionId) {
		logFatalError(exception, styleCodeId,  page , this.sessionId,  isFatal,  transactionId);
	}

	public static void logFatalError(Exception exception, int styleCodeId, String page , String sessionId, boolean isFatal) {
		String message = exception.getMessage();
		String data = ExceptionUtils.getStackTrace(exception);
		logFatalError(styleCodeId, page, sessionId, isFatal, message, getDescription(exception), null, data, "");
	}

	public static void logFatalError(int styleCodeId, String page , String sessionId, boolean isFatal, String message, String description, String transactionId, String data, String property) {
		if(message.length() > 255){
			message = message.substring(0, 255);
		}

		if(page.length() > 45) {
			page = page.substring(0, page.length() - 45);
		}

		FatalError fatalError = new FatalError();
		fatalError.setStyleCodeId(styleCodeId);
		fatalError.setPage(page);
		fatalError.setmessage(message);
		fatalError.setDescription(description);
		fatalError.setSessionId(sessionId);
		fatalError.setTransactionId(transactionId);
		fatalError.setData(data);
		fatalError.setProperty(property);
		if(isFatal) {
			fatalError.setFatal("1");
		} else {
			fatalError.setFatal("0");
		}
        logFatalError(fatalError);
	}


    public static void logFatalError(FatalError fatalError) {
        FatalErrorDao fatalErrorDao = new FatalErrorDao();
        try {
            fatalErrorDao.add(fatalError);
        } catch (DaoException e) {
            LOGGER.error("Cannot log to fatal error table {}", kv("fatalError", fatalError), e);
        }
    }

	public static void logFatalError(Exception exception, int styleCodeId, String page , String sessionId, boolean isFatal, Long transactionId) {
		logFatalError(exception, styleCodeId, page,
				sessionId, isFatal, String.valueOf(transactionId));
	}

	public void logFatalError(Exception exception, int styleCodeId, String page, boolean isFatal, Long transactionId) {
		logFatalError(exception, styleCodeId, page, this.sessionId, isFatal, transactionId);
	}

	public void logFatalError(int styleCodeId, String page, boolean isFatal, String message, String description, Long transactionId) {
		logFatalError(styleCodeId, page, this.sessionId, isFatal, message, description, String.valueOf(transactionId), "" , this.property);
	}

	public void logFatalError(int styleCodeId, String page, boolean isFatal, String message, String description, String transactionId) {
		logFatalError(styleCodeId, page, this.sessionId, isFatal, message, description, transactionId, "" , this.property);
	}

	public static void logFatalError(int styleCodeId, String page, String sessionId, boolean isFatal, String message, String description, String transactionId) {
		logFatalError(styleCodeId, page, sessionId, isFatal, message, description, transactionId, "" , "");
}

	public void logFatalError(Exception exception, String message, boolean isFatal) {
		message += " exception:" + exception.getMessage();
		String data = ExceptionUtils.getStackTrace(exception);
		logFatalError(styleCodeId, page, sessionId, isFatal, message, getDescription(exception), String.valueOf(transactionId), data, this.property);
}

	private static String getDescription(Exception exception) {
		String description = exception.getMessage();
		if(exception.getCause() != null) {
			description = " cause:" + exception.getCause().getMessage();
		}
		return description;
	}
}
