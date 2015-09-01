package com.disc_au.web.go.tags;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.jsp.JspException;

// TODO: Auto-generated Javadoc
/**
 * The Class LogTag.
 *
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class LogTag extends BaseTag {

	private LogLevel defaultLevel = LogLevel.INFO;
	private LogLevel level = defaultLevel;
	private String source = "jsp";
	private Exception error = null;

	public void setLevel(String level) {
		this.level = defaultLevel;
		try {
			this.level = LogLevel.valueOf(level);
		} catch (Exception ex) {
			// Invalid enum string passed in, will default to
		}
	}

	public void setSource(String source) {
		this.source = source;
	}

	public void setError(Exception error) {
		this.error = error;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */
	@Override
	public int doAfterBody() throws JspException {
		Logger logger = LoggerFactory.getLogger(source);
		switch (level) {
			case TRACE:
				if(error != null) {
					logger.trace(String.valueOf(bodyContent.getString()), error);
				} else {
					logger.trace(String.valueOf(bodyContent.getString()));
				}
				break;
			case DEBUG:
				if(error != null) {
					logger.debug(String.valueOf(bodyContent.getString()), error);
				} else {
					logger.debug(String.valueOf(bodyContent.getString()));
				}
				break;
			case INFO:
				if(error != null) {
					logger.info(String.valueOf(bodyContent.getString()), error);
				} else {
					logger.info(String.valueOf(bodyContent.getString()));
				}
				break;
			case WARN:
				if(error != null) {
					logger.warn(String.valueOf(bodyContent.getString()), error);
				} else {
					logger.warn(String.valueOf(bodyContent.getString()));
				}
				break;
			case ERROR:
				if(error != null) {
					logger.error(String.valueOf(bodyContent.getString()), error);
				} else {
					logger.error(String.valueOf(bodyContent.getString()));
				}
				break;
			default:
				if(error != null) {
					logger.debug(String.valueOf(bodyContent.getString()), error);
				} else {
					logger.debug(String.valueOf(bodyContent.getString()));
				}
				break;
		}
		level =  defaultLevel;
		source = "jsp";
		error = null;
		return SKIP_BODY;
	}

	public enum Level {

	}
}
