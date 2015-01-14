package com.ctm.exceptions;

public class TokenSecurityException extends RuntimeException {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public TokenSecurityException(String message){
		super(message);
	}
	
	public TokenSecurityException(String message , Throwable e){
		super(message, e);
	}
}
