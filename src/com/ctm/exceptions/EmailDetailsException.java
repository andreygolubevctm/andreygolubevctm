package com.ctm.exceptions;

public class EmailDetailsException extends Exception {

	/**
	 *
	 */
	private static final long serialVersionUID = 6753030154052436572L;

	public EmailDetailsException(String message, Exception e) {
		super(message, e);
	}

}
