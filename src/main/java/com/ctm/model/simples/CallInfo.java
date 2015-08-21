package com.ctm.model.simples;

import java.util.ArrayList;

public class CallInfo {
	private ArrayList<String> vdns = new ArrayList<String>();
	private String direction;
	private int state = -1;
	private String callId;
	private String customerPhoneNo;

	public static final String DIRECTION_INBOUND = "I";
	public static final String DIRECTION_OUTBOUND = "O";
	public static final String DIRECTION_INTERNAL = "N";

	public static final int STATE_INACTIVE = 0;
	public static final int STATE_ACTIVE = 1;
	public static final int STATE_HELD = 2;
	public static final int STATE_RINGING = 4;


	public ArrayList<String> getVdns() {
		return vdns;
	}
	public void addVdn(String vdn) {
		this.vdns.add(vdn);
	}

	public String getDirection() {
		return direction;
	}
	public void setDirection(String direction) {
		this.direction = direction;
	}

	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}

	public String getCustomerPhoneNo() {
		return customerPhoneNo;
	}

	public void setCustomerPhoneNo(String customerPhoneNo) {
		this.customerPhoneNo = customerPhoneNo;
	}

	public String getCallId() {
		return callId;
	}

	public void setCallId(String callId) {
		this.callId = callId;
	}
}
