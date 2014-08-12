package com.ctm.model;

public class AccessTouch extends Touch {

	private AccessCheck accessCheck;
	private int expired;

	public static enum AccessCheck {
		LOCKED (0),
		NO_TOUCHES (1),
		EXPIRED (2),
		UNLOCKED (3),
		ONLINE(5),
		MATCHING_OPERATOR(5),
		SUMMITTED(6);

		private final int code;

		AccessCheck(int code) {
			this.code = code;
		}

		public int getCode() {
			return code;
		}
	}

	public AccessCheck getAccessCheck() {
		return this.accessCheck;
	}

	public void setAccessCheck(AccessCheck accessCheck) {
		this.accessCheck = accessCheck;
	}

	public void setExpired(int expired) {
		this.expired = expired;
	}

	public int getExpired() {
		return expired;
	}

}
