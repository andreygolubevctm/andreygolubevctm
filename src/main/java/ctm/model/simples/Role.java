package com.ctm.model.simples;

/**
 * "Role" represents the simples.role database table.
 */
public class Role {
	// These role codes come from simples.role database table
	public final static int ROLE_CONSULTANT_INBOUND = 1;
	public final static int ROLE_CONSULTANT_OUTBOUND_TOP = 2;
	public final static int ROLE_CONSULTANT_OUTBOUND_BOTTOM = 3;
	public final static int ROLE_CALL_CENTRE_TEAM_LEAD = 4;
	public final static int ROLE_CTM_IT = 5;

	private int id;
	private boolean isAdmin;
	private boolean canSeeMessageQueue;
	private boolean isDeveloper;


	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public boolean isAdmin() {
		return isAdmin;
	}
	public void setAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}
	public boolean canSeeMessageQueue() {
		return canSeeMessageQueue;
	}
	public void setCanSeeMessageQueue(boolean canSeeMessageQueue) {
		this.canSeeMessageQueue = canSeeMessageQueue;
	}
	public boolean isDeveloper() {
		return isDeveloper;
	}
	public void setDeveloper(boolean isDeveloper) {
		this.isDeveloper = isDeveloper;
	}
}
