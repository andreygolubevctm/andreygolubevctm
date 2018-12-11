package com.ctm.web.core.exceptions;

public class SessionExpiredException extends Exception {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public SessionExpiredException(String message){
		super(message);
	}
}
