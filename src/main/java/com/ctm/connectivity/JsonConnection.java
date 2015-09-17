package com.ctm.connectivity;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.google.json.JsonSanitizer;

import static com.ctm.logging.LoggingArguments.kv;

public class JsonConnection {

	private static final Logger LOGGER = LoggerFactory.getLogger(JsonConnection.class);
	public SimpleConnection conn = null;



	public JsonConnection() {
		conn = new SimpleConnection();
	}

	/**
	 * Returns the JSON object from a specified URL. A null value is returned if there is a connectivity problem or a JSON parsing problem.
	 *
	 * @param url
	 * @return
	 */
	public JSONObject get(String url) {
		try {
			if (conn == null) {
				conn = new SimpleConnection();
			}

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
		catch (Exception e){
			LOGGER.error("Error making json get {}", kv(url, url), e);
		}

		return null;
	}

	public JSONObject post(String url, String postBody) {
		return post(url, postBody, true);
	}

	public JSONObject post(String url, String postBody, Boolean sanitize) {
		try {
			if (conn == null) {
				conn = new SimpleConnection();
			}

			conn.setRequestMethod("POST");
			conn.setPostBody(postBody);

			String jsonString = conn.get(url);

			if(jsonString == null) return null;

			JSONObject json;

			if(sanitize) {
				json = sanitizeJson(jsonString);
			} else {
				json = new JSONObject(jsonString);
			}

			return json;
		}
		catch (Exception e){
			LOGGER.error("Error making json post", kv("url", url), kv("postBody", postBody), kv("sanitize", sanitize), e);
		}

		return null;
	}

	public JSONArray postArray(String url, String postBody) {
		return postArray(url, postBody, true);
	}

	public JSONArray postArray(String url, String postBody, Boolean sanitize) {
		try {
			if (conn == null) {
				conn = new SimpleConnection();
			}

			conn.setRequestMethod("POST");
			conn.setPostBody(postBody);

			String jsonString = conn.get(url);

			LOGGER.trace("Posting json request {}", kv("request", jsonString));

			if(jsonString == null) return null;

			JSONArray json;

			if(sanitize) {
				json = sanitizeJsonArray(jsonString);
			} else {
				json = new JSONArray(jsonString);
			}

			return json;
		}
		catch (Exception e){
			LOGGER.error("Error making json array post {},{},{}", kv("url", url), kv("postBody", postBody),
				kv("sanitize", sanitize), e);
		}

		return null;
	}

	public static JSONObject sanitizeJson(String jsonString){
		JSONObject json = new JSONObject();

		try {
			json = new JSONObject(JsonSanitizer.sanitize(jsonString));
		} catch(JSONException e) {
			LOGGER.error("Error sanitizing json object {}", kv("json", jsonString), e);
		}

		return json;
	}

	public static JSONArray sanitizeJsonArray(String jsonString){
		JSONArray json = new JSONArray();

		try {
			json = new JSONArray(JsonSanitizer.sanitize(jsonString));
		} catch(JSONException e) {
			LOGGER.error("Error sanitizing json array {}", kv("json", jsonString), e);
		}

		return json;
	}
	
}
