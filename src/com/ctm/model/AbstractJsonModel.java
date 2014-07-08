package com.ctm.model;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import com.ctm.model.formatter.JsonFormatter;

public abstract class AbstractJsonModel implements JsonFormatter {
	private static Logger logger = Logger.getLogger(AbstractJsonModel.class.getName());



	/**
	 * Get the model as a JSON object for use by the JsonFormatter. Must be implemented by subclasses.
	 * @return Json object of the model
	 * @throws JSONException
	 */
	protected abstract JSONObject getJsonObject() throws JSONException;



	//
	// JsonFormatter implementation
	//
	public String toJson() {
		return toJsonObject().toString();
	}
	public JSONObject toJsonObject() {

		try {
			return getJsonObject();
		}
		catch (JSONException e) {
			logger.error(e.getMessage());

			// Return a blank object
			return new JSONObject();
		}

	}
}
