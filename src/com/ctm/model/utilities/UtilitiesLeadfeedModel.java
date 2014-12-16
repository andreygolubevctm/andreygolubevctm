package com.ctm.model.utilities;

import java.util.Date;
import java.text.SimpleDateFormat;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;


public class UtilitiesLeadfeedModel extends AbstractJsonModel {

	private long transactionId;
	private String firstName;
	private String lastName;
	private String email;
	private String homePhone;
	private String mobile;
	private String postcode;
	private String salesRep = "CompareTheMarket";
	private String signature = "123";


	public long getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}

	public String getHomePhone() {
		return homePhone;
	}
	public void setHomePhone(String homePhone) {
		this.homePhone = homePhone;
	}

	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getPostcode() {
		return postcode;
	}
	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getSalesRep() {
		return salesRep;
	}

	public String getSignature() {
		return signature;
	}


	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("ref_no", getTransactionId());
		json.put("create_time", new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(new Date().getTime()));
		json.put("first_name", getFirstName());
		json.put("last_name", getLastName());
		if (getHomePhone() != null) {
			json.put("home_phone", getHomePhone());
		}
		if (getMobile() != null) {
			json.put("mobile", getMobile());
		}
		json.put("post_code", getPostcode());
		json.put("sales_rep", getSalesRep());
		json.put("signature", getSignature());

		return json;
	}

}
