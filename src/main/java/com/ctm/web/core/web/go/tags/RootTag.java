package com.ctm.web.core.web.go.tags;

import com.ctm.web.core.web.go.InsertMarkerCache;

import javax.servlet.jsp.JspException;
import java.io.IOException;

/**
 * The Class HtmlTag.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class RootTag extends BaseTag {
		
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
		return EVAL_PAGE;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
		InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(pageContext);
		cache.reset();
		return EVAL_BODY_BUFFERED;
	}
	public void setEncodeQuotes(String encode){
		if (encode.equalsIgnoreCase("true")){
			InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(pageContext);
			cache.setEncodeQuotes(true);
		}
	}
}
