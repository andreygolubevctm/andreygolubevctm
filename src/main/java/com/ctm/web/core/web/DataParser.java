package com.ctm.web.core.web;

import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


/**
 * class to map legacy Data object to a class using reflection
 *
 */

public class DataParser  {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

	private static final Logger LOGGER = LoggerFactory.getLogger(DataParser.class.getName());

	public static <T extends Object> T createObjectFromData(Data data , Class<? extends Object> c, String xpath){
		T object  = newObject(c);
		if(object != null) {
			Object node = data.get(xpath);
			if (node != null && node instanceof XmlNode) {
				ArrayList<XmlNode> childNodes = ((XmlNode) node).getChildren();
				mapClass(object, c, childNodes, xpath, data);
			}
		} else {
			LOGGER.warn("could not create class. {}", kv("class" , c));
		}
		return object;
	}

	private static <T extends Object> T newObject(Class<?> c) {
		T object = null;
		Constructor<?>[] constructors = c.getDeclaredConstructors();
		for(Constructor con : constructors){
			if(con.getParameterCount() == 0) {
				try {
					boolean isAccessible = con.isAccessible();
					con.setAccessible(true);
					object = (T) con.newInstance(null);
					con.setAccessible(isAccessible);
				} catch (ReflectiveOperationException e) {
					LOGGER.warn("Failed to create {}", kv("c", c),  e);
				}
			}
		}
		return object;
	}

	private static <T extends Object> void mapClass(T object, Class<? extends Object> c, ArrayList<XmlNode> childNodes, String xpath, Data data) {
		for (Field field : c.getDeclaredFields()) {
			String fieldName = field.getName();
			XmlNode value = getValueFromDataBucket(fieldName, childNodes);
			if(value != null && value.getChildren() != null && !value.getChildren().isEmpty()){
				Object  fieldObject = createObjectFromData( data ,field.getType(), xpath + "/" + fieldName);
				if(fieldObject != null) {
					try {
						setField(object, field, fieldObject);
					} catch (IllegalAccessException e) {
						LOGGER.warn("Failed to map object" , e);
					}
				}
			}else if (value !=null && value.getText() != null) {
				callSetField(object, field, value.getText());
			}
		}
		if( c.getSuperclass() != null) {
			mapClass(object, c.getSuperclass(), childNodes, xpath, data);
		}
	}

	private static <T extends Object> void setField(T object, Field field, Object fieldObject) throws IllegalAccessException {
		boolean fieldIsAccessible = field.isAccessible();
		field.setAccessible(true);
		field.set(object, fieldObject);
		field.setAccessible(fieldIsAccessible);
	}

	private static <T extends Object> void callSetField(Object object, Field field, String value) {
		try {
			Object convertedValue = convertValue(field.getType(), value);
			if(convertedValue != null) {
				setField(object, field, convertedValue);
			}
		} catch (IllegalAccessException | ParseException e)  {
			LOGGER.warn("Failed to map {}", kv("field", field),  e);
		}
	}



	private static XmlNode getValueFromDataBucket(String paramName, ArrayList<XmlNode> childNodes) {
		for(XmlNode node : childNodes){
			if(node.getNodeName().equals(paramName)){
				return node;
			}
		}
		return null;
	}

	private static Object convertValue(Class<?> type, String param) throws ParseException {
		Object value = null;
		Method valueOf = null;
		try {
			valueOf = type.getMethod("valueOf", String.class);
		} catch ( ReflectiveOperationException e) {
			// all good just means there is no valueOf method;
		}
		try {
			if( type == int.class ){
				value =  param != null && !param.isEmpty() ? Integer.parseInt(param) : 0;
			}else if( type == float.class ){
				value =  Float.parseFloat(param);
			}else if( type == long.class  ){
				value =  Long.parseLong(param);
			}else if( type.equals(BigDecimal.class)){
				value =  new BigDecimal(param);
			} else if( type == String.class){
				value =  param;
			} else if(valueOf != null && valueOf.getReturnType().equals(type)
					&& ((valueOf.getModifiers() & java.lang.reflect.Modifier.STATIC) != 0)){
				value = valueOf.invoke(null, param);
			} else if( type == LocalDate.class) {
				value = LocalDate.parse(param, DATE_TIME_FORMATTER);
			}

		} catch(Exception e){
			LOGGER.warn("Failed to map object . {}" , e);
		}
		return value;
	}

}

