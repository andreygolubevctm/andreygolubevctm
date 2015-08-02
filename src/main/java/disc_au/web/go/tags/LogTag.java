package com.disc_au.web.go.tags;

import java.text.DateFormat;
import java.util.Date;

import javax.servlet.jsp.JspException;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.Priority;

// TODO: Auto-generated Javadoc
/**
 * The Class LogTag.
 *
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class LogTag extends BaseTag {

	private Level defaultLevel = Level.INFO;
	private Level level = defaultLevel;
	private String source = "jsp";
	private Exception error = null;

	public void setLevel(String level) {
		this.level = Level.toLevel(level);
		if(this.level == null) {
			this.level =  defaultLevel;
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
		Logger logger = Logger.getLogger(source);
		if(error != null) {
			logger.log(level, bodyContent.getString(), error);
		} else {
			logger.log(level, bodyContent.getString());
		}
		level =  defaultLevel;
		source = "jsp";
		error = null;
		return SKIP_BODY;
	}
}
