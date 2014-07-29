package com.ctm.model;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.formatter.JsonFormatter;
import com.ctm.model.formatter.JsonUtils;

public abstract class AbstractJsonModel implements JsonFormatter {

	private static Logger logger = Logger.getLogger(AbstractJsonModel.class.getName());

	private ArrayList<Error> errors = new ArrayList<Error>();


	/**
	 * Get the model as a JSON object for use by the JsonFormatter. Must be implemented by subclasses.
	 * @return Json object of the model
	 * @throws JSONException
	 */
	protected abstract JSONObject getJsonObject() throws JSONException;



	public ArrayList<Error> getErrors() {
		return errors;
	}
	public void addError(Error error) {
		errors.add(error);
	}



	//
	// JsonFormatter implementation
	//
	public String toJson() {
		return toJsonObject(true).toString();
	}
	public JSONObject toJsonObject() {
		return toJsonObject(false);
	}
	public JSONObject toJsonObject(boolean renderErrors) {

		try {
			// Get json object from the implementation
			JSONObject json = getJsonObject();

			// Add any errors
			if (renderErrors) {
				JsonUtils.addListToJsonObject(json, Error.JSON_COLLECTION_NAME, getErrors());
			}

			return json;
		}
		catch (JSONException e) {
			logger.error(e);

			// Return a blank object
			return new JSONObject();
		}

	}
}
