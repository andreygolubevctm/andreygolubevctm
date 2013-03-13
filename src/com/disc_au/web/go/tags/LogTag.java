package com.disc_au.web.go.tags;

import java.text.DateFormat;
import java.util.Date;

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

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */
	@Override
	public int doAfterBody() throws JspException {
		StringBuffer sb = new StringBuffer();

		sb.append(DateFormat.getInstance().format(new Date()));
		sb.append(":\t");
		sb.append(bodyContent.getString());
		System.out.println(sb.toString());

		return SKIP_BODY;
	}
}
