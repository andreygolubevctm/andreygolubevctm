/**  =========================================   */
/**  Gadget Object Framework: HtmlTag Class
 *   $Id$
 * (c)2012 Auto & General Holdings Pty Ltd       */

package com.ctm.web.core.web.go.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;

import com.ctm.web.core.web.go.InsertMarkerCache;
/**
 * The Class HtmlTag.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class HtmlTag extends BaseTag {
	
	/** The Constant START_TAG. */
	private static String START_TAG = "<!--[if lt IE 7]><html class=\"no-js ie lt-ie10 lt-ie9 lt-ie8 lt-ie7\" lang=\"en\"> <![endif]-->"
									+ "<!--[if IE 7]>   <html class=\"no-js ie ie7 lt-ie10 lt-ie9 lt-ie8\" lang=\"en\"> <![endif]-->"
									+ "<!--[if IE 8]>   <html class=\"no-js ie ie8 lt-ie10 lt-ie9\" lang=\"en\"> <![endif]-->"
									+ "<!--[if IE 9]>   <html class=\"no-js ie ie9 lt-ie10\" lang=\"en\"> <![endif]-->"
									+ "<!--[if !IE]><!--><html class=\"no-js\" lang=\"en\"> <!--<![endif]-->";
	
	/** The Constant END_TAG. */
	private static final String END_TAG = "</html>";
	
	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */
	@Override
	public int doAfterBody() throws JspException {
		try {
			InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(this.pageContext);
			
			String body = cache.applyInserts(bodyContent.getString());

			bodyContent.getEnclosingWriter().write(body);

		} catch (IOException e) {
			throw new JspException(e);
		}
		return SKIP_BODY;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doEndTag()
	 */
	@Override
	public int doEndTag() throws JspException {
		try {
			pageContext.getOut().write(END_TAG);
		} catch (IOException e) {
			throw new JspException(e);
		}
		return EVAL_PAGE;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
		try {
			InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(pageContext);
			cache.reset();
			
			pageContext.getOut().write(START_TAG);
		} catch (IOException e) {
			throw new JspException(e);
		}
		return EVAL_BODY_BUFFERED;
	}

	public void setStartTag(String starttag){
		START_TAG = starttag;
	}
}
