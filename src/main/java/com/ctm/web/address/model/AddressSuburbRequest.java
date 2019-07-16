package com.ctm.web.address.model;

public class AddressSuburbRequest {
	private String addressLine;
  private String postCodeOrSuburb;

  public AddressSuburbRequest(String addressLine, String postCodeOrSuburb) {
    this.addressLine = addressLine;
    this.postCodeOrSuburb = postCodeOrSuburb;
	}

	public String getAddressLine() {
		return addressLine;
	}

	public void setAddressLine(String addressLine) {
		this.addressLine = addressLine;
	}

  	public String getPostCodeOrSuburb() {
		return postCodeOrSuburb;
	}

	public void setPostCodeOrSuburb(String postCodeOrSuburb) {
		this.postCodeOrSuburb = postCodeOrSuburb;
	}
}
