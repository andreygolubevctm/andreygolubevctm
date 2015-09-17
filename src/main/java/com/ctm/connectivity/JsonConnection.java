package com.ctm.connectivity;

import com.ctm.connectivity.exception.ConnectionException;
import com.google.json.JsonSanitizer;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JsonConnection {

	private static final Logger logger = LoggerFactory.getLogger(JsonConnection.class.getName());
	private final SimpleConnection conn;

	public JsonConnection() {
		this.conn = new SimpleConnection();
	}

	public JsonConnection(SimpleConnection conn) {
		this.conn = conn;
	}

	public void setHasCorrelationId(boolean hasCorrelationId) {
		conn.setHasCorrelationId(hasCorrelationId);
	}

	/**
	 * Returns the JSON object from a specified URL. A null value is returned if there is a connectivity problem or a JSON parsing problem.
	 *
	 * @param url
	 * @return
	 */
	public JSONObject get(String url) {
		try {
			String jsonString = conn.get(url);
			if(jsonString == null) return null;

			//
			// This is here to clean up A&G's web service
			//
			String preparseString = jsonString.toString();
			// TODO TEMP CLEAN UP - make this smarter
			preparseString = preparseString.replace("<!--", "");
			preparseString = preparseString.replace("-->", "");
			preparseString = preparseString.trim();

			JSONObject json = new JSONObject(preparseString);
			return json;
		}
		catch (JSONException  e) {
			logger.error(url+" json exception: "+e);
		}
		catch (Exception e){
			logger.error(url+": "+e);
		}

		return null;
	}

	public JSONObject post(String url, String postBody) {
		return post(url, postBody, true);
	}

	public JSONObject post(String url, String postBody, Boolean sanitize) {
		try {
			conn.setRequestMethod("POST");
			conn.setPostBody(postBody);

			String jsonString = null;
			try {
				jsonString = conn.get(url);
			} catch (ConnectionException e) {
				logger.error("Failed to call json", e);
			}

			JSONObject json;

			if(sanitize) {
				json = sanitizeJson(jsonString);
			} else {
				json = new JSONObject(jsonString);
			}

			return json;
		}
		catch (JSONException e) {
			logger.error(url + ": json exception: " + e);
		}
		catch (Exception e){
			logger.error(url + ": " + e);
		}

		return null;
	}

	public JSONArray postArray(String url, String postBody) {
		return postArray(url, postBody, true);
	}

	public JSONArray postArray(String url, String postBody, Boolean sanitize) {
		try {
			conn.setRequestMethod("POST");
			conn.setPostBody(postBody);

			String jsonString = null;
			try {
				jsonString = conn.get(url);
				logger.debug(jsonString);
			} catch (ConnectionException e) {
				logger.error("Failed to call json", e);
				return null;
			}
			JSONArray json;

			if(sanitize) {
				json = sanitizeJsonArray(jsonString);
			} else {
				json = new JSONArray(jsonString);
			}

			return json;
		}
		catch (JSONException e) {
			logger.error(url + ": json array exception: " + e);
		}
		catch (Exception e){
			logger.error(url + ": " + e);
		}

		return null;
	}

	public static JSONObject sanitizeJson(String jsonString){
		JSONObject json = new JSONObject();

		try {
			json = new JSONObject(JsonSanitizer.sanitize(jsonString));
		} catch(JSONException e) {
			logger.error(": json exception: " + e);
		}

		return json;
	}

	public static JSONArray sanitizeJsonArray(String jsonString){
		JSONArray json = new JSONArray();

		try {
			json = new JSONArray(JsonSanitizer.sanitize(jsonString));
		} catch(JSONException e) {
			logger.error(": json exception: " + e);
		}

		return json;
	}
	
}
