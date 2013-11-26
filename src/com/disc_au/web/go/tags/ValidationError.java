package com.disc_au.web.go.tags;

public class ValidationError {

	public static final String INVALID = "INVALID VALUE";
	public static final String REQUIRED = "ELEMENT REQUIRED";

	private String elementName;
	private String message;

	public String getElementName() {
		return elementName;
	}

	public String getMessage() {
		return message;
	}

	public void setElementName(String elementName) {
		this.elementName = elementName;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
