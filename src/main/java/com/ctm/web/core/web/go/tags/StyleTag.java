package com.ctm.web.core.web.go.tags;

import java.io.IOException;

import javax.servlet.jsp.JspException;

import com.ctm.web.core.web.go.InsertMarkerCache;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

// TODO: Auto-generated Javadoc
/**
 * The Class StyleTag.
 *
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class StyleTag extends BaseTag {

	private static final Logger LOGGER = LoggerFactory.getLogger(StyleTag.class.getName());

	/** The Constant START_TAG. */
	private static final String START_TAG = "<style type=\"text/css\">";

	/** The Constant END_TAG. */
	private static final String END_TAG = "</style>";

	/**
	 * Make link tag.
	 *
	 * @param href the href
	 * @return the string
	 */
	public String makeLinkTag() {
		StringBuffer sb = new StringBuffer();
		sb.append("<link rel=\"stylesheet\" href=\"");
		//sb.append(addTimeStampToHref(this.href));
		sb.append(com.ctm.web.core.web.Utils.addBuildRevisionToUrl(href));
		sb.append("\">");
		sb.append('\n');
		return sb.toString();
	}

	private String makeConditional(String content) {
		if(this.conditional != null) {
			StringBuffer sb = new StringBuffer();
			sb.append("<!--[if " + this.conditional + "]>");
			sb.append(content);
			sb.append("<![endif]-->");
			sb.append('\n');
			return sb.toString();
		}
		return content;
	}

	/** The href. */
	private String href;

	/** The insert marker. */
	private String insertMarker;

	private String conditional;

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doAfterBody()
	 */
	@Override
	public int doAfterBody() throws JspException {

		// If we had an href, we would have skipped the body
		// So if we're here, we need to add the css code to the insert marker.
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
		if (this.insertMarker == null) {
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

		// If we have an href, add link tag to the insertMarker,
		// otherwise we'll get the css code when we process the body
		if (this.href != null && this.insertMarker != null) {
			InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(this.pageContext);
			cache.addInsertMarkerValue(this.insertMarker,makeConditional(makeLinkTag()));
			return SKIP_BODY;

		} else if (this.insertMarker == null) {

			try {
				pageContext.getOut().write(START_TAG);
			} catch (IOException e) {
				LOGGER.error("Failed to write to page. {}", kv("START_TAG", START_TAG), e);
			}
			return EVAL_BODY_INCLUDE;
		} else {
			return EVAL_BODY_BUFFERED;
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
	 * Sets the href.
	 *
	 * @param href the new href
	 */
	public void setConditional(String conditional) {
		this.conditional = conditional;
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
