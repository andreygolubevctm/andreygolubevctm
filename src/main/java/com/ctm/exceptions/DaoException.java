package com.ctm.exceptions;


public class DaoException extends Exception{

	private static final long serialVersionUID = 1L;

	public DaoException(String message){
		super(message);
	}

	public DaoException(String message, Throwable t) {
		super(message, t);
	}

	public DaoException(Throwable t) {
		super(t);
	}
}
