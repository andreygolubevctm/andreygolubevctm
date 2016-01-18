package com.ctm.web.core.model;

import com.ctm.web.core.model.formatter.JsonFormatter;
import com.ctm.web.core.model.formatter.JsonUtils;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;

@JsonIgnoreProperties({"errors"})
public abstract class AbstractJsonModel implements JsonFormatter {

	private static final Logger LOGGER = LoggerFactory.getLogger(AbstractJsonModel.class);

	private ArrayList<com.ctm.web.core.model.Error> errors = new ArrayList<>();


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
			LOGGER.error("failed to create json object", e);

			// Return a blank object
			return new JSONObject();
		}

	}
}
