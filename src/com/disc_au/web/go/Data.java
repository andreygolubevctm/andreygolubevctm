package com.disc_au.web.go;

import java.util.ArrayList;

import org.xml.sax.SAXException;
import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;

// TODO: Auto-generated Javadoc
/**
 * The Class Data.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("unchecked")
public class Data extends XmlNode {
	
	/** The NODE. */
	public static String NODE = "node";
	
	/** The TEXT. */
	public static String TEXT = "text";
	
	/** The ARRAY. */
	public static String ARRAY = "array";
	
	/** The XML. */
	public static String XML = "xml";

	/**
	 * Ensure array.
	 *
	 * @param obj the obj
	 * @return the object
	 */
	public static Object ensureArray(Object obj) {
		if (obj == null || obj instanceof ArrayList) {
			return obj;

		} else if (obj instanceof XmlNode) {
			ArrayList<XmlNode> a = new ArrayList<XmlNode>();
			a.add((XmlNode) obj);
			return a;

		} else if (obj instanceof String) {
			ArrayList<String> a = new ArrayList<String>();
			a.add((String) obj);
			return a;
		}
		return null;
	}

	/**
	 * Ensure node.
	 *
	 * @param obj the obj
	 * @return the object
	 */
	public static Object ensureNode(Object obj) {
		if (obj == null || obj instanceof XmlNode) {
			return obj;

		} else if (obj instanceof String) {
			return new XmlNode("node", (String) obj);

		} else if (obj instanceof ArrayList) {
			ArrayList a = (ArrayList) obj;
			if (a.isEmpty()) {
				return null;
			} else {
				return ensureNode(a.get(0));
			}
		}
		return null;
	}

	/**
	 * Ensure text.
	 *
	 * @param obj the obj
	 * @return the object
	 */
	public static Object ensureText(Object obj) {
		if (obj == null || obj instanceof String) {
			return obj;

		} else if (obj instanceof XmlNode) {
			return ((XmlNode) obj).getText();

		} else if (obj instanceof ArrayList) {
			ArrayList a = (ArrayList) obj;
			if (a.isEmpty()) {
				return null;
			} else {
				return ensureText(a.get(0));
			}
		}
		return null;
	}
	/**
	 * Ensure xml.
	 *
	 * @param obj the obj
	 * @return the object
	 */
	public static Object ensureXml(Object obj) {
		return ensureXml(obj,false);
	}
	/**
	 * Ensure xml.
	 *
	 * @param obj the obj
	 * @return the object
	 */
	public static Object ensureXml(Object obj, boolean escape) {
		if (obj == null) {
			return obj;

		} else if (obj instanceof XmlNode) {
			return ((XmlNode) obj).getXML(escape);

		} else if (obj instanceof String) {
			return "<text>" + (String) obj + "</text>";

		} else if (obj instanceof ArrayList) {

			StringBuffer sb = new StringBuffer();
			sb.append("<array>");
			for (Object item : (ArrayList) obj) {
				sb.append((String) ensureXml(item));
			}
			sb.append("</array>");

			return sb.toString();

		}
		return null;
	}

	/** The mode. */
	private String mode;

	/** The get xml. */
	boolean getXml = false;

	/**
	 * Instantiates a new data.
	 */
	public Data() {
		super("this");
	}

	/**
	 * Adds the document.
	 *
	 * @param doc the doc
	 */
	public void addDocument(XmlNode doc) {
		if (this.children != null) {
			this.removeChild(doc.getNodeName());
		}
		this.addChild(doc);
	}

	/* (non-Javadoc)
	 * @see com.disc_au.web.go.xml.XmlNode#get(java.lang.Object)
	 */
	@Override
	public Object get(Object objKey) {
		if (mode == null) {

			if (objKey instanceof String) {
				String key = (String) objKey;

				if (key.equals(NODE) || key.equals(TEXT) || key.equals(ARRAY)
						|| key.equals(XML)) {
					mode = key;
					return this;
				}
			}

		} else {
			Object obj = super.get(objKey);
			if (mode.equals(TEXT)) {
				mode = null;
				return ensureText(obj);
			} else if (mode.equals(NODE)) {
				mode = null;
				return ensureNode(obj);
			} else if (mode.equals(ARRAY)) {
				mode = null;
				return ensureArray(obj);
			} else if (mode.equals(XML)) {
				mode = null;
				return ensureXml(obj);
			}
			mode = null;
		}
		return super.get(objKey);
	}

	/**
	 * Parses the.
	 *
	 * @param xmlDoc the xml doc
	 * @return the string
	 */
	public String parse(String xmlDoc) {
		XmlParser p = new XmlParser();
		try {
			addDocument(p.parse(xmlDoc));
			return "true";
		} catch (SAXException e) {
			return e.getMessage();
		}
	}

	/**
	 * Removes the document.
	 *
	 * @param doc the doc
	 */
	public void removeDocument(XmlNode doc) {
		this.removeChild(doc);
	}
	
}
