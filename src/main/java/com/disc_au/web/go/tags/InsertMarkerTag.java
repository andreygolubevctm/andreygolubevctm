package com.disc_au.web.go.tags;

import com.disc_au.web.go.InsertMarker;
import com.disc_au.web.go.InsertMarkerCache;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.jsp.JspException;
import java.io.IOException;

import static com.ctm.web.core.logging.LoggingArguments.kv;

// TODO: Auto-generated Javadoc
/**
 * The Class InsertMarkerTag.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("serial")
public class InsertMarkerTag extends BaseTag {

	private static final Logger LOGGER = LoggerFactory.getLogger(InsertMarkerTag.class.getName());

	/** The format. */
	private InsertMarker.Format format;
	
	/** The name. */
	private String name;
	
	/** The delim. */
	private String delim;

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
		InsertMarkerCache cache = InsertMarkerCache.getInsertMarkerCache(this.pageContext); 
		InsertMarker marker = cache.getInsertMarker(this.name, this.format);

		if (this.delim != null) {
			marker.setDelim(this.delim);
		}
		try {
			String markerComment;
			switch (marker.getFormat()) {
			case JSON:
			case SCRIPT:
				markerComment = "//--INSERT:" + marker.getName() + "--//";
				break;
			case STYLE:
				markerComment = "/*--INSERT:" + marker.getName() + "--*/";
				break;
			default:
				markerComment = "<!--INSERT:" + marker.getName() + "-->";
			}

			pageContext.getOut().write(markerComment);
		} catch (IOException e) {
			LOGGER.error("Failed to write marker to page. {}" , kv("marker", marker), e);
		}
		return SKIP_BODY;
	}

	/**
	 * Sets the delim.
	 *
	 * @param delim the new delim
	 */
	public void setDelim(String delim) {
		this.delim = delim;
	}

	/**
	 * Sets the format.
	 *
	 * @param format the new format
	 */
	public void setFormat(String format) {
		this.format = InsertMarker.Format.valueOf(format);
	}

	/**
	 * Sets the name.
	 *
	 * @param name the new name
	 */
	public void setName(String name) {
		this.name = name;
	}
}
