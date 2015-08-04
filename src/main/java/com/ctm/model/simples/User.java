package com.ctm.model.simples;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

public class User extends AbstractJsonModel {

	private int id;
	private String displayName;
	private String extension;
	private String username;
	private Date modified;
	private boolean available;
	private boolean loggedIn;
	private List<Role> roles;
	private List<Rule> rules;

	//
	// Accessors
	//

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}

	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getExtension() {
		return extension;
	}
	public void setExtension(String extension) {
		this.extension = extension;
	}

	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}

	public Date getModified() {
		return modified;
	}
	public void setModified(Date modified) {
		this.modified = modified;
	}

	public boolean getAvailable() {
		return available;
	}
	public void setAvailable(boolean available) {
		this.available = available;
	}

	public boolean getLoggedIn() {
		return loggedIn;
	}
	public void setLoggedIn(boolean loggedIn) {
		this.loggedIn = loggedIn;
	}

	public List<Role> getRoles() {
		if(roles == null) return new ArrayList<Role>();
		return roles;
	}
	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}
	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("id", getId());
		json.put("displayName", getDisplayName());
		json.put("extension", getExtension());
		json.put("username", getUsername());
		json.put("modified", getModified());
		json.put("available", getAvailable());
		json.put("loggedIn", getLoggedIn());
		return json;
	}

	public List<Rule> getRules() {
		return rules;
	}

	public void setRules(List<Rule> rules) {
		this.rules = rules;
	}
}
