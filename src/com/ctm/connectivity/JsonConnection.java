package com.ctm.connectivity;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonConnection {

	private static Logger logger = Logger.getLogger(JsonConnection.class.getName());
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
		catch (JSONException e) {
			logger.error(url+" json exception: "+e);
		}
		catch (Exception e){
			logger.error(url+": "+e);
		}

		return null;
	}

	public JSONObject post(String url, String postBody) {
		try {
			if (conn == null) {
				conn = new SimpleConnection();
			}

			conn.setRequestMethod("POST");
			conn.setPostBody(postBody);

			String jsonString = conn.get(url);

			if(jsonString == null) return null;

			JSONObject json = new JSONObject(jsonString);
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
		try {
			if (conn == null) {
				conn = new SimpleConnection();
			}

			conn.setRequestMethod("POST");
			conn.setPostBody(postBody);

			String jsonString = conn.get(url);

			logger.debug(jsonString);

			if(jsonString == null) return null;

			JSONArray json = new JSONArray(jsonString);

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
}
