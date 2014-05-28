package com.ctm.model.session;

import com.disc_au.web.go.Data;

/**
 * Extends the DATA object with some quick methods to return and set common values via xpath.
 *
 */

public class AuthenticatedData extends Data{

	public AuthenticatedData(){
		super();
	}

	public String getUid(){
		String uid = (String) get("login/user/uid");
		if(uid != null && uid.equals("")) return null;
		return uid;
	}

	public boolean isLoggedIn(){
		String userId = (String) get("login/user/uid");
		if(userId == null || userId.equals("")) return false;
		return true;
	}


	public String getAgentId(){
		String agentId = (String) get("login/user/agentId");
		if(agentId != null && agentId.equals("")) return null;
		return agentId;
	}

	public String getExtension(){
		String extension = (String) get("login/user/extension");
		if(extension != null && extension.equals("")) return null;
		return extension;
	}

	public void setExtension(String extension){
		put("login/user/extension", extension);
	}


}
