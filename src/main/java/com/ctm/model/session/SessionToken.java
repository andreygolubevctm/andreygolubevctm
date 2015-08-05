package com.ctm.model.session;

public class SessionToken {

	public static enum IdentityType {
		LDAP{
			public String toString() {
				return "LDAP";
			}
		},
		EMAIL_MASTER{
			public String toString() {
				return "EMAIL_MASTER";
			}
		}
	};

	private int id;
	private String token;
	private IdentityType identityType;
	private String identity;

	public SessionToken(){

	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public IdentityType getIdentityType() {
		return identityType;
	}

	public void setIdentityType(IdentityType identityType) {
		this.identityType = identityType;
	}

	public String getIdentity() {
		return identity;
	}

	public void setIdentity(String identity) {
		this.identity = identity;
	}

}
