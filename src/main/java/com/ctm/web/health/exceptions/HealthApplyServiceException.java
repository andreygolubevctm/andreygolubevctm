package com.ctm.web.health.exceptions;


public class HealthApplyServiceException extends Exception{

	private static final long serialVersionUID = 1L;

	public HealthApplyServiceException(String message){
		super(message);
	}

	public HealthApplyServiceException(String message, Throwable t) {
		super(message, t);
}
}
