package com.ctm.web.validation;

public class ValidationError {

	public static final String INVALID = "INVALID VALUE";
	public static final String REQUIRED = "ELEMENT REQUIRED";

	private String elementXpath;
	private String message;
	private String elements;

	public String getElementXpath() {
		return elementXpath;
	}

	public String getMessage() {
		return message;
	}

	public void setElementXpath(String elementXpath) {
		this.elementXpath = elementXpath;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void setElements(String elements) {
		this.elements = elements;
	}

	public String getElements() {
		return elements;
	}

}
