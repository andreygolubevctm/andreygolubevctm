package com.ctm.web.core.results.model;

import org.json.simple.JSONObject;

public class ResultsSimpleItem {

	private String name;
	private String resultPath;
	private String className;

	public ResultsSimpleItem(){

	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSetResultPath() {
		return resultPath;
	}

	public void setResultPath(String resultPath) {
		this.resultPath = resultPath;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public String toString(){
		JSONObject json = new JSONObject();
		json.put("n", this.name);
		json.put("p", this.resultPath);
		json.put("c", this.className);
		return json.toString();
	}


}
