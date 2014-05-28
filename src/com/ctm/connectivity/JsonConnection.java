package com.ctm.connectivity;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonConnection {

	private static Logger logger = Logger.getLogger(JsonConnection.class.getName());

	public JsonConnection(){

	}

	/**
	 * Returns the JSON object from a specified URL. A null value is returned if there is a connectivity problem or a JSON parsing problem.
	 *
	 * @param url
	 * @return
	 */
	public JSONObject get(String url) {
		try {
			SimpleConnection conn = new SimpleConnection();
			String jsonString = conn.get(url);
			if(jsonString == null) return null;
			String preparseString = jsonString.toString();
			// TODO TEMP CLEAN UP - make this smarter
			preparseString = preparseString.replace("<!--", "");
			preparseString = preparseString.replace("-->", "");
			preparseString = preparseString.trim();

			JSONObject json = new JSONObject(preparseString);

			return json;


		} catch (JSONException e) {
			logger.error(url+" json exception: "+e);
		} catch (Exception e){
			logger.error(url+": "+e);
		}
		return null;
	}
}
