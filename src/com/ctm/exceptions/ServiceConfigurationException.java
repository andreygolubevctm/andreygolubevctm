package com.ctm.exceptions;

public class ServiceConfigurationException extends Exception{

	private static final long serialVersionUID = 1L;

	public ServiceConfigurationException(String message){
		super(message);
	}

	public ServiceConfigurationException(String message, Throwable t) {
		super(message, t);
	}
}

