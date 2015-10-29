package com.ctm.web.core.model.formatter;

import org.json.JSONObject;

public interface JsonFormatter {

	/**
	 * Format the model into json.
	 * @return String containing json
	 */
	String toJson();

	/**
	 * Format the model into a json object (so you can manipulate/use it).
	 * @return Json object
	 */
	JSONObject toJsonObject();

}
