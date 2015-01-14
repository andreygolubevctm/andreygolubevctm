package com.ctm.model.session;

import com.disc_au.web.go.Data;

/**
 * Extends the DATA object with some quick methods to return and set common values via xpath.
 *
 */

public class AuthenticatedData extends Data {

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
	 * @return
	 */
	public Integer getSimplesUid() {
		String uid = (String) get("login/user/simplesUid");
		if (uid == null || uid.equals("")) return null;
		return Integer.parseInt(uid);
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
