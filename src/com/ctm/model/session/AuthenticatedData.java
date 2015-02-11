package com.ctm.model.session;

import com.disc_au.web.go.Data;
import org.apache.log4j.Logger;

/**
 * Extends the DATA object with some quick methods to return and set common values via xpath.
 *
 */

public class AuthenticatedData extends Data {

	private static Logger logger = Logger.getLogger(AuthenticatedData.class.getName());

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
