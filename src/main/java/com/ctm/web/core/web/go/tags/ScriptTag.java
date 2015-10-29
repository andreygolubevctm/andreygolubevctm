package com.ctm.web.core.web.go.tags;

import com.ctm.web.core.web.Utils;
import com.ctm.web.core.web.go.InsertMarkerCache;

import javax.servlet.jsp.JspException;
import java.io.IOException;

// TODO: Auto-generated Javadoc
/**
 * The Class ScriptTag.
 *
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class ScriptTag extends BaseTag {

	/** The Constant START_TAG. */
	private static final String START_TAG = "<script type=\"text/javascript\">";

	/** The Constant END_TAG. */
	private static final String END_TAG = "</script>";

	/**
	 * Make script tag.
	 *
	 * @param href the href
	 * @return the string
	 */
	public static String makeScriptTag(String href) {
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\" src=\"");
		//sb.append(addTimeStampToHref(href));
		sb.append(Utils.addBuildRevisionToUrl(href));
		sb.append("\"></script>");
		sb.append('\n');
		return sb.toString();
	}

	/** The href. */
	private String href;

	/** The insert marker. */
	private String insertMarker;

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */
	@Override
	public int doAfterBody() throws JspException {

		// If an insert variable has been specified
		// Add the code to it, and clear the body.
		if (this.insertMarker != null) {
			InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(this.pageContext);
			cache.addInsertMarkerValue(this.insertMarker, bodyContent.getString());

			bodyContent.clearBody();
			return SKIP_BODY;
		}
		return EVAL_PAGE;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doEndTag()
	 */
	@Override
	public int doEndTag() throws JspException {

		// If inline and we don't have an href, write the end tag
		if (this.insertMarker == null && this.href == null) {
			try {
				pageContext.getOut().write(END_TAG);
			} catch (IOException e) {
				throw new JspException(e);
			}
		}
		this.init();
		return EVAL_PAGE;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
		try {
			// If no insertMarker means we're going to insert the code inline
			if (this.insertMarker == null) {

				// Inline and we have an href, add the <script> tag and skip the
				// body
				if (this.href != null) {
					pageContext.getOut().write(makeScriptTag(this.href));
					return SKIP_BODY;

					// Inline without an href just do the start tag
				} else {
					pageContext.getOut().write(START_TAG);
					return EVAL_BODY_INCLUDE;
				}
			} else {
				// Add to a variable and href present
				if (this.href != null) {
					InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(this.pageContext);
					cache.addInsertMarkerValue(this.insertMarker, makeScriptTag(this.href));
					return SKIP_BODY;

					// Add to variable but no href: Do nothing here .. we'll get
					// the code in the afterBody event
				} else {
					return EVAL_BODY_BUFFERED;
				}
			}

		} catch (IOException e) {
			throw new JspException(e);
		}
	}

	/**
	 * Gets the href.
	 *
	 * @return the href
	 */
	public String getHref() {
		return href;
	}

	/**
	 * Inits the.
	 */
	public void init() {
		this.href = null;
		this.insertMarker = null;
	}

	/**
	 * Sets the href.
	 *
	 * @param href the new href
	 */
	public void setHref(String href) {
		this.href = href;
	}

	/**
	 * Sets the marker.
	 *
	 * @param insertMarker the new marker
	 */
	public void setMarker(String insertMarker) {
		this.insertMarker = insertMarker;
	}
}
