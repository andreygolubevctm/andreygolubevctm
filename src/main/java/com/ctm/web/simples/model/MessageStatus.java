package com.ctm.web.simples.model;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

/**
 * "MessageStatus" represents the simples.message_status database table.
 *
 */
public class MessageStatus extends AbstractJsonModel {
	// These status codes come from simples.message_status database table

	//parent statues
	public final static int STATUS_NEW = 1;
	public final static int STATUS_COMPLETED = 2;
	public final static int STATUS_INPROGRESS = 3;
	public final static int STATUS_POSTPONED = 4;
	public final static int STATUS_ASSIGNED = 5;
	public final static int STATUS_UNSUCCESSFUL = 6;
	public final static int STATUS_ABANDONED = 7;
	public final static int STATUS_COMPLETED_AS_PM = 31;
	public final static int STATUS_CHANGED_TIME_FOR_PM = 32;
	public final static int STATUS_REMOVED_FROM_PM = 33;
	public final static int STATUS_INPROGRESS_FOR_PM = 35;

	//common sub statues
	public final static int STATUS_DONOTCONTACT = 9;
	public final static int STATUS_INVALIDLEAD = 10;
	public final static int STATUS_CONVERTEDTOSALE = 11;
	public final static int STATUS_WARMTRANSFER = 14;
	public final static int STATUS_ALREADYCUSTOMER = 16;
	public final static int STATUS_DUPLICATELEAD = 24;
	public final static int STATUS_OVERSEASCOVER = 25;
	public final static int STATUS_INVALID_FAILJOIN = 34;

	private int id;
	private String status;

	//
	// Accessors
	//

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("id", getId());
		json.put("status", getStatus());

		return json;
	}
}
