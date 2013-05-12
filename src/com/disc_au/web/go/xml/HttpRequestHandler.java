package com.disc_au.web.go.xml;

import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;

import com.disc_au.web.go.Gadget;

// TODO: Auto-generated Javadoc
/**
 * The Class HttpRequestHandler.
 *
 * @author aransom
 * @version 1.0
 */

public class HttpRequestHandler {

	/**
	 * Creates the xml node.
	 *
	 * @param req the req
	 * @return the xml node
	 */
	public static XmlNode createXmlNode(HttpServletRequest req) {
		return updateXmlNode(new XmlNode("data"), req);

	}

	/**
	 * Update xml node.
	 *
	 * @param node the node
	 * @param req the req
	 * @param trimWhiteSpace boolean to remove white space
	 * @return the xml node
	 */
	public static XmlNode updateXmlNode(XmlNode node, HttpServletRequest req, boolean trimWhiteSpace) {
		Enumeration<String> en = req.getParameterNames();
		while (en.hasMoreElements()) {
			String name = en.nextElement();
			for (String value : req.getParameterValues(name)) {
				String xpath = Gadget.getXpathFromName(name);
				if(trimWhiteSpace) {
					value = value.trim();
				}
				node.put(xpath + "/text()", value);
			}
		}
		return node;
	}

	/**
	 * Update xml node.
	 *
	 * @param node the node
	 * @param req the req
	 * @return the xml node
	 */
	public static XmlNode updateXmlNode(XmlNode node, HttpServletRequest req) {
		return updateXmlNode(node, req, false);
	}
}
