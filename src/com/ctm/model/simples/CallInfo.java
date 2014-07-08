package com.ctm.model.simples;

import java.util.ArrayList;

public class CallInfo {
	private ArrayList<String> vdns = new ArrayList<String>();
	private int direction;
	private int state = -1;

	public static final int DIRECTION_INBOUND = 1;
	public static final int DIRECTION_OUTBOUND = 2;
	public static final int DIRECTION_INTERNAL = 3;

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

	public int getDirection() {
		return direction;
	}
	public void setDirection(int direction) {
		this.direction = direction;
	}

	public int getState() {
		return state;
	}
	public void setState(int state) {
		this.state = state;
	}
}
