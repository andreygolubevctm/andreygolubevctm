package com.ctm.web.core.model;

import java.io.Serializable;
import java.util.Objects;

/**
 * "Role" represents the simples.role database table.
 */
public class Role implements Serializable {
	private static final long serialVersionUID = 1L;
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

	@Override
	public String toString() {
		return "Role{" +
				"id=" + id +
				", isAdmin=" + isAdmin +
				", canSeeMessageQueue=" + canSeeMessageQueue +
				", isDeveloper=" + isDeveloper +
				'}';
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (!(o instanceof Role)) return false;
		Role role = (Role) o;
		return getId() == role.getId() &&
				isAdmin() == role.isAdmin() &&
				canSeeMessageQueue == role.canSeeMessageQueue &&
				isDeveloper() == role.isDeveloper();
	}

	@Override
	public int hashCode() {

		return Objects.hash(getId(), isAdmin(), canSeeMessageQueue, isDeveloper());
	}
}
