package com.ctm.web.core.exceptions;

public class UploaderException extends Exception {

	/**
	 *
	 */
	private static final long serialVersionUID = 1;

	public UploaderException(String message, Exception e) {
		super(message , e);
	}

	public UploaderException(String message) {
		super(message);
	}

}
