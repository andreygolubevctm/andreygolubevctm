package com.ctm.exceptions;


public class SendEmailException extends Exception {

	/**
	 *
	 */
	private static final long serialVersionUID = 3636469823518566163L;
	private String description;

	public SendEmailException(String message , Exception e) {
		super(message, e);
	}

	public SendEmailException(String message) {
		super(message);
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}

}
