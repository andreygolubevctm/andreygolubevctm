package com.ctm.web.health.exceptions;


public class HealthAltPriceException extends Exception{

	private static final long serialVersionUID = 1L;

	public HealthAltPriceException(String message){
		super(message);
	}

	public HealthAltPriceException(String message, Throwable t) {
		super(message, t);
}
}
