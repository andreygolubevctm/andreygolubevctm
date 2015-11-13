package com.ctm.web.core.logging;

import org.slf4j.Logger;
import org.slf4j.MDC;

import java.text.SimpleDateFormat;
import java.util.Date;

import static ch.qos.logback.classic.ClassicConstants.FINALIZE_SESSION_MARKER;
import static com.ctm.web.core.logging.LoggingArguments.v;
import static org.slf4j.LoggerFactory.getLogger;

public class XMLOutputWriter {
	
	public static final String REQ_IN = "req_in";
	public static final String REQ_OUT = "req_out";
	public static final String RESP_IN = "resp_in";
	public static final String RESP_OUT = "resp_out";
	

	private static final String NAME_KEY = "loggerName";
	
	private static final Logger LOGGER = getLogger(XMLOutputWriter.class);
	private final String name;
	private final String loggerName;

	public XMLOutputWriter(String name, String debugPath) {
		this.name = name;
		this.loggerName = getDebugPath(debugPath) + "/" + name.replaceAll(" ", "_") + "_xml";
		MDC.put(NAME_KEY, loggerName);
	}

	public void writeXmlToFile(String maskXml, String type) {
		LOGGER.info("{} {} {}", v("name", name), v("type", type), v("message", removeLineEndings(maskXml)));
	}
	
	/**
	 * This is important this will release appenders after a few seconds always call 
	 * this when you have finished logging.
	 * @param message
	 */
	public void lastWriteXmlToFile(String message) {
		LOGGER.info(FINALIZE_SESSION_MARKER, "{} {} {}", v("name", name), v("type", RESP_OUT), v("message", removeLineEndings(message)));
	}

	public void lastWriteXmlToFile(String message, String type) {
		LOGGER.info(FINALIZE_SESSION_MARKER, "{} {} {}", v("name", name), v("type", type), v("message", removeLineEndings(message)));
	}

	private String removeLineEndings(String maskXml) {
		return maskXml.replace("\n", "").replace("\r", "");
	}

	private String getDebugPath(String debugPathLocal) {
			SimpleDateFormat sdf  = new SimpleDateFormat("yyyyMMdd-HH");
			String debugDateFolder = sdf.format(new Date());
			return debugPathLocal + "/" + debugDateFolder;
	}
	
	public String getLoggerName() {
		return loggerName;
	}
}
