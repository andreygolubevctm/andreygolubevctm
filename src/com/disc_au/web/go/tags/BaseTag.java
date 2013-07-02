/**  =========================================   */
/**  Gadget Object Framework: Base Tag Class
 *   $Id$
 * ©2012 Auto & General Holdings Pty Ltd         */

package com.disc_au.web.go.tags;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyTagSupport;

// TODO: Auto-generated Javadoc
/**
 * The Class BaseTag.
 * 
 * @author aransom
 * @version 1.0
 */

public class BaseTag extends BodyTagSupport {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	/**
	 * Adds the time stamp to href.
	 *
	 * @param href the href
	 * @return the string
	 */
	public static String addTimeStampToHref(String href) {
		// Get the timestamp
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		String ts = df.format(System.currentTimeMillis());

		// Check if the href is in the format xxx.js? or xxx.js (add a ? or a &
		// appropriately)
		String tsSep = (href.indexOf("?") > -1) ? "&" : "?";
		StringBuffer sb = new StringBuffer(href);

		sb.append(tsSep).append("ts=").append(ts);
		return sb.toString();
	}

	/** The xpath. */
	private String xpath;

	/** The root tag. */
	private HtmlTag rootTag;

	/**
	 * Gets the root tag.
	 *
	 * @return the root tag
	 */
	public HtmlTag getRootTag() {
		if (this.rootTag == null) {
			this.rootTag = (HtmlTag) findAncestorWithClass(this, HtmlTag.class);

			if (this.rootTag == null) {
				System.err
						.println("No Root HTML Tag found. To Use the GO tools your web page must use the gadget objects html tag as the root (e.g. <go:html>)");
			}
		}
		return this.rootTag;
	}

	/**
	 * Gets the xpath.
	 *
	 * @return the xpath
	 */
	public String getXpath() {
		return xpath;
	}

	/**
	 * Sets the xpath.
	 *
	 * @param xpath the new xpath
	 */
	public void setXpath(String xpath) {
		this.xpath = xpath;
	}
}
