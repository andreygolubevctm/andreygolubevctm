package com.ctm.web.core.web.go;

import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.core.web.go.xml.XmlParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.NumberUtils;
import org.xml.sax.SAXException;

import javax.annotation.Nullable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

// TODO: Auto-generated Javadoc
/**
 * The Class Data.
 *
 * @author aransom
 * @version 1.0
 */

public class Data extends XmlNode implements Comparable<Data> {

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

	public <T extends Object> T createObjectFromData( T  object, String xpath){
		Class<? extends Object> c = object.getClass();
        Object node = get(xpath);
        if(node != null && node instanceof XmlNode) {
            ArrayList<XmlNode> childNodes = ((XmlNode) node).getChildren();
            mapClass(object, c, childNodes);
        }
		return object;
	}

	private <T extends Object> void mapClass(T object, Class<? extends Object> c, ArrayList<XmlNode> childNodes) {
        for (Field field : c.getDeclaredFields()) {
            String value = getValueFromDataBucket(field.getName(), childNodes);
            if (value != null) {
                callSetField(object, field, value);
            }
        }
        if( c.getSuperclass() != null) {
            mapClass(object, c.getSuperclass(), childNodes);
        }
    }

    private <T extends Object> void callSetField(Object object, Field field, String value) {
		try {
			boolean isAccessible = field.isAccessible();
			field.setAccessible(true);
            Object convertedValue = convertValue(field.getType(), value);
            if(convertedValue != null) {
                field.set(object, convertedValue);
            }
			field.setAccessible(isAccessible);
		} catch (IllegalAccessException | ParseException e)  {
			e.printStackTrace();
		}
	}

	private Object convertValue(Class<?> type, String param) throws ParseException {
		Object value = null;
        Method valueOf = null;
        try {
             valueOf = type.getMethod("valueOf", String.class);
        } catch ( ReflectiveOperationException e) {
            // all good;
        }
		try {
			if( type == Integer.class){
				value =  !param.isEmpty() ? new Integer(param) : null;
			} else if( type == int.class ){
				value =  param != null && !param.isEmpty() ? Integer.parseInt(param) : 0;
			}else if( type == float.class  || type == Float.class){
				value =  Float.parseFloat(param);
			}else if( type == long.class  || type == Long.class){
				value =  Long.parseLong(param);
			}else if( type == BigDecimal.class){
				value =  new BigDecimal(param);
			} else if( type == String.class){
				value =  param;
            } else if(valueOf != null){
				try {
					value = valueOf.invoke(null, param);
				} catch ( ReflectiveOperationException e) {
					// ignore
				}
			}

		} catch(NumberFormatException ne){
			if(type!=null){
				throw new NumberFormatException("the type of " + type.getName()+"."+value +" is '"+ type.getName() + "' which is not suitable for value '"+value+"'");
			}
		}
		return value;
	}


	private String getValueFromDataBucket(String paramName, ArrayList<XmlNode> childNodes) {
		for(XmlNode node : childNodes){
			if(node.getNodeName().equals(paramName)){
				return node.getText();
			}
		}
		return null;
	}

}

