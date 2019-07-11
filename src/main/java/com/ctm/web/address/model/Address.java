package com.ctm.web.address.model;

public class Address {
	private String suburb;
  	private String postcode;
  	private String state;

	public String getSuburb() {
		return suburb;
	}

	public void setSuburb(String suburb) {
		this.suburb = suburb;
  }

    public String getPostCode() {
		return postcode;
	}

	public void setPostCode(String postcode) {
		this.postcode = postcode;
  }

    public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
  }
  
}
