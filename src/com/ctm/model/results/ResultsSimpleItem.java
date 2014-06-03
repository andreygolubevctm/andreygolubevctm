package com.ctm.model.results;

import org.json.simple.JSONObject;

public class ResultsSimpleItem {

	private String name;
	private String resultPath;

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

	public String toString(){
		JSONObject json = new JSONObject();
		json.put("n", this.name);
		json.put("p", this.resultPath);
		return json.toString();
	}


}
