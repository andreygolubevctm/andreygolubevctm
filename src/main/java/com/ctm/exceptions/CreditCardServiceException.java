package com.ctm.exceptions;

public class CreditCardServiceException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public CreditCardServiceException(String message){
		super(message);
	}
}
