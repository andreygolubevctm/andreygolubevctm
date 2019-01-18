package com.ctm.web.core.exceptions;

public class SessionExpiredException extends Exception {

	/**
	 * Exception created to provide a distinction from SessionException which often results in error logs being written.
	 * Where applicable this exception should only result in info/debug level logs.
	 */
	private static final long serialVersionUID = 1L;

	public SessionExpiredException(String message){
		super(message);
	}
}
