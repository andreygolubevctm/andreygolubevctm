/**  =========================================   */
/**  <go:call> Tag Class with iSeries env variable support
 *   $Id: CallTag.java 3390 2013-07-02 07:22:37Z xplooy $
 * (c)2012 Auto & General Holdings Pty Ltd       */

package com.disc_au.web.go.tags;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.sql.DataSource;

import com.disc_au.web.go.CallCenterHours;

import static com.disc_au.web.go.CallCenterHours.MORNING_HOUR;
import static com.disc_au.web.go.CallCenterHours.AFTERNOON_HOUR;
import static com.disc_au.web.go.CallCenterHours.EVENING_HOUR;

/**
 * Tag to get the call centre hours.
 *
 * @author aransom
 * @version 1.3
 */

@SuppressWarnings("serial")
public class CallCenterHoursTag extends BaseTag {

	private int hour;
	private String callBackVar;
	private String vertical;

	public void setVertical(String vertical) {
		this.vertical = vertical;
	}

	public void setTimeOfDay(char time) {
		switch (time) {
			case 'M':
				this.hour = MORNING_HOUR;
				break;
			case 'A':
				this.hour = AFTERNOON_HOUR;
				break;
			case 'E':
				this.hour = EVENING_HOUR;
				break;
		}
	}

	public void setCallBackVar(String callBackVar) {
		this.callBackVar = callBackVar;
	}
	/** The xml var. */

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doEndTag()
	 */
	@Override
	public int doEndTag() throws JspException {
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			// Look up our data source
			DataSource ds = (DataSource) envCtx.lookup("jdbc/ctm");
			CallCenterHours callCenterHours = new CallCenterHours(vertical, ds);
			this.pageContext.setAttribute(callBackVar, callCenterHours.getNextAvailableDate(hour), PageContext.PAGE_SCOPE);
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return EVAL_PAGE;
	}

}
