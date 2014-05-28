package com.ctm.model;


public class EmailDetails {

	private String lastName = "";
	private String firstName = "";
	private int emailId;
	private String emailAddress;
	private boolean valid;
	private String hashedEmail;

	public String getLastName() {
		return lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public int getEmailId() {
		return emailId;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	public boolean isValid() {
		return valid;
	}

	public String getName() {
		if(lastName.isEmpty()) {
			return firstName;
		} else {
			return firstName  + " " + lastName;
		}
	}

	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setEmailId(int emailId) {
		this.emailId = emailId;
	}

	public void setValid(boolean valid) {
		this.valid= valid;
	}

	public String getHashedEmail() {
		return hashedEmail;
	}

	public void setHashedEmail(String hashedEmail) {
		this.hashedEmail = hashedEmail;
	}
}
