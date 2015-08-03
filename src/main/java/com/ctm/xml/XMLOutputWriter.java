package com.ctm.xml;

import static org.slf4j.LoggerFactory.getLogger;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.MDC;

import static ch.qos.logback.classic.ClassicConstants.FINALIZE_SESSION_MARKER;

public class XMLOutputWriter {
	
	public static final String REQ_IN = "req_in";
	public static final String REQ_OUT = "req_out";
	public static final String RESP_IN = "resp_in";
	public static final String RESP_OUT = "resp_out";
	

	private static final String NAME_KEY = "loggerName";
	
	private static final Logger logger = getLogger(XMLOutputWriter.class);
	private final String name;

	public XMLOutputWriter(String name, String debugPath) {
		this.name = name;
		String loggerName =  getDebugPath(debugPath) + "/" + name.replaceAll(" ", "_") + "_xml";
		MDC.put(NAME_KEY, loggerName);
	}

	public void writeXmlToFile(String maskXml, String type) {
		logger.info(createLogString(maskXml, type));
	}
	
	/**
	 * This is important this will release appenders after a few seconds always call 
	 * this when you have finished logging.
	 * @param message
	 * @param type
	 * @param transactionId
	 */
	public void lastWriteXmlToFile(String message) {
		logger.info(FINALIZE_SESSION_MARKER, createLogString(message, RESP_OUT));
	}

	private String createLogString(String maskXml, String type) {
		return name + " "+ type + " " + maskXml.replace("\n", "").replace("\r", "");
	}
	
	private String getDebugPath(String debugPathLocal) {
			SimpleDateFormat sdf  = new SimpleDateFormat("yyyyMMdd-HH");
			String debugDateFolder = sdf.format(new Date());
			return debugPathLocal + "/" + debugDateFolder;
	}
	

}
