package com.ctm.model.session;

import com.ctm.web.core.model.Role;
import com.ctm.web.core.model.Rule;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

import static com.ctm.web.core.logging.LoggingArguments.kv;

/**
 * Extends the DATA object with some quick methods to return and set common values via xpath.
 *
 */

public class AuthenticatedData extends Data {

	private static final Logger LOGGER = LoggerFactory.getLogger(AuthenticatedData.class);

	// store the roles in java instead of data bucket
	private List<Role> simplesUserRoles;
	private List<Rule> getNextMessageRules;

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
				LOGGER.error("obtained invalid simples uid {}", kv("uid", uid), e);
			}
		}
		return simplesUid;
	}

	public List<Role> getSimplesUserRoles() {
		if(simplesUserRoles == null) return new ArrayList<>();
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


	public List<Rule> getGetNextMessageRules() {
		if(getNextMessageRules == null) return new ArrayList<>();
		return getNextMessageRules;
	}

	public void setGetNextMessageRules(List<Rule> getNextMessageRules) {
		this.getNextMessageRules = getNextMessageRules;
	}

	@Override
	public String toString() {
		return "AuthenticatedData{" +
				"simplesUserRoles=" + simplesUserRoles +
				", getNextMessageRules=" + getNextMessageRules +
				", xml=" + this.getXML() +
				'}';
	}
}
