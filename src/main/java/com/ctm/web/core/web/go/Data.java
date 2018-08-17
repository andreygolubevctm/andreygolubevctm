package com.ctm.web.core.web.go;

import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.core.web.go.xml.XmlParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.NumberUtils;
import org.xml.sax.SAXException;

import javax.annotation.Nullable;
import java.io.Serializable;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.Objects;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

// TODO: Auto-generated Javadoc
/**
 * The Class Data.
 *
 * @author aransom
 * @version 1.0
 */

public class Data extends XmlNode implements Comparable<Data>, Serializable {

	private static final long serialVersionUID = 1L;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

	private static final Logger LOGGER = LoggerFactory.getLogger(Data.class.getName());

	/** The NODE. */
	public static String NODE = "node";

	/** The TEXT. */
	public static String TEXT = "text";

	/** The ARRAY. */
	public static String ARRAY = "array";

	/** The XML. */
	public static String XML = "xml";

	private Date lastSessionTouch;

	/**
	 * Ensure array.
	 *
	 * @param obj the obj
	 * @return the object
	 */
	public static ArrayList<?> ensureArray(Object obj) {
		if (obj instanceof ArrayList) {
			return (ArrayList<?>)obj;

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
	public static XmlNode ensureNode(Object obj) {
		if (obj instanceof XmlNode) {
			return (XmlNode)obj;

		} else if (obj instanceof String) {
			return new XmlNode("node", (String) obj);

		} else if (obj instanceof ArrayList) {
			@SuppressWarnings("rawtypes")
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
	public static String ensureText(Object obj) {
		if (obj instanceof String) {
			return (String)obj;

		} else if (obj instanceof XmlNode) {
			return ((XmlNode) obj).getText();

		} else if (obj instanceof ArrayList) {
			@SuppressWarnings("rawtypes")
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
	@SuppressWarnings("rawtypes")
	public static String ensureXml(Object obj, boolean escape) {
		if (obj instanceof XmlNode) {
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

	/** The mode can be one of NODE TEXT ARRAY or XML */
	private String mode = "";

	/** The get xml. */
	boolean getXml = false;

	/**
	 * Instantiates a new data.
	 */
	public Data() {
		super("this");
		setLastSessionTouch(new Date());
	}

	/**
	 * Adds the document.
	 *
	 * @param doc the doc
	 */
	public void addDocument(XmlNode doc) {
		if (getChildren() != null) {
			this.removeChild(doc.getNodeName());
		}
		this.addChild(doc);
	}

	/* (non-Javadoc)
	 * @see com.disc_au.web.go.xml.XmlNode#get(java.lang.Object)
	 */
	@Override
	public Object get(Object objKey) {
		if (mode.isEmpty()) {

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
				mode = "";
				return ensureText(obj);
			} else if (mode.equals(NODE)) {
				mode = "";
				return ensureNode(obj);
			} else if (mode.equals(ARRAY)) {
				mode = "";
				return ensureArray(obj);
			} else if (mode.equals(XML)) {
				mode  = "";
				return ensureXml(obj);
			}
			mode  = "";
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
	public synchronized void removeDocument(XmlNode doc) {
		this.removeChild(doc);
	}

	/**
	 * Session touch is used with the session data service
	 * @return
	 */
	public Date getLastSessionTouch() {
		return lastSessionTouch;
	}

	public void setLastSessionTouch(Date lastTouch) {
		this.lastSessionTouch = lastTouch;
	}

	public int compareTo(Data other) {
		final int BEFORE = -1;
		final int EQUAL = 0;
		final int AFTER = 1;

		if (this.lastSessionTouch.before(other.getLastSessionTouch())) return BEFORE;
		if (this.lastSessionTouch.after(other.getLastSessionTouch())) return AFTER;
		return EQUAL;
	}

	/**
	 * if xpath value is empty return empty string instead of null
	 */
	public String getStringNotNull(String xpath) {
		Object obj = get(xpath);
		String value = "";
		if (obj instanceof String) {
			value = (String) obj;
		}
		return value;
	}

	@Nullable
	public String getString(String xpath) {
		Object obj = get(xpath);
		String value = null;
		if (obj instanceof String) {
			value = (String) obj;
		}
		return value;
	}

	@Nullable
	public Long getLong(String xpath) {
		return getNumber(xpath, Long.class);
	}

	@Nullable
	public Integer getInteger(String xpath) {
		return getNumber(xpath, Integer.class);
	}

	@Nullable
	public Double getDouble(String xpath) {
		return getNumber(xpath, Double.class);
	}

	/* (non-Javadoc)
	 * @see java.util.Map#put(java.lang.Object, java.lang.Object)
	 */

	public synchronized Object putInteger(String key, @Nullable Integer value) {
		return put(key, String.valueOf(value));
	}

	public synchronized Object putDouble(String key,@Nullable Double annualAmount) {
		return put(key, String.valueOf(annualAmount));
	}

	private <T extends Number> T getNumber(String xpath, Class<T> targetClass) {
		T value= null;
		String valueString = getString(xpath);
		try {
			if(valueString != null && !valueString.isEmpty()){
				value = NumberUtils.parseNumber(getString(xpath), targetClass);
			}
		} catch (NumberFormatException e) {
			LOGGER.info("Failed to convert value to number. {}", kv("xpath", xpath), e);
		}
		return value;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (!(o instanceof Data)) return false;
		if (!super.equals(o)) return false;
		Data data = (Data) o;
		return getXml == data.getXml &&
				Objects.equals(getLastSessionTouch(), data.getLastSessionTouch()) &&
				Objects.equals(mode, data.mode);
	}

	@Override
	public int hashCode() {

		return Objects.hash(super.hashCode(), getLastSessionTouch(), mode, getXml);
	}
}

