package com.ctm.model.session;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.ctm.model.simples.Role;
import com.disc_au.web.go.Data;

/**
 * Extends the DATA object with some quick methods to return and set common values via xpath.
 *
 */

public class AuthenticatedData extends Data {

	private static Logger logger = Logger.getLogger(AuthenticatedData.class.getName());

	// store the roles in java instead of data bucket
	private List<Role> simplesUserRoles;

	public AuthenticatedData(){
		super();
	}

	public String getUid(){
		String uid = (String) get("login/user/uid");
		if(uid != null && uid.isEmpty()) return null;
		return uid;
	}

	/**
	 * The ID from the simples.user row.
	 * @return login/user/simplesUid from data bucket
	 */
	public int getSimplesUid() {
		int simplesUid = -1;
		String uid = (String) get("login/user/simplesUid");
		if (uid != null && !uid.isEmpty()) {
			try {
				simplesUid = Integer.parseInt(uid);
			} catch (NumberFormatException e) {
				logger.error(e);
			}
		}
		return simplesUid;
	}

	public List<Role> getSimplesUserRoles() {
		if(simplesUserRoles == null) return new ArrayList<Role>();
		return simplesUserRoles;
	}

	public void setSimplesUserRoles(List<Role> roles) {
		this.simplesUserRoles = roles;
	}

	public boolean isLoggedIn(){
		return getUid() != null;
	}


	public String getAgentId(){
		String agentId = (String) get("login/user/agentId");
		if(agentId != null && agentId.isEmpty()) return null;
		return agentId;
	}

	public String getExtension(){
		String extension = (String) get("login/user/extension");
		if(extension != null && extension.isEmpty()) return null;
		return extension;
	}

	public void setExtension(String extension){
		put("login/user/extension", extension);
	}


}
