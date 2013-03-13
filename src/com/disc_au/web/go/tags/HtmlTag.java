package com.disc_au.web.go.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;

import com.disc_au.web.go.InsertMarkerCache;
/**
 * The Class HtmlTag.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class HtmlTag extends BaseTag {
	
	/** The Constant START_TAG. */
	private static final String START_TAG = "<html>";
	
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
}
