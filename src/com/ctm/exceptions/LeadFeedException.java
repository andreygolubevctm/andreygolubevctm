package com.ctm.exceptions;


public class LeadFeedException extends Exception{

	private static final long serialVersionUID = 1L;

	public LeadFeedException(String message){
		super(message);
	}

	public LeadFeedException(String message, Throwable t) {
		super(message, t);
}
}
