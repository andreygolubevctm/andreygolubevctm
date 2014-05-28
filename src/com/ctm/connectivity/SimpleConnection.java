package com.ctm.connectivity;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.apache.log4j.Logger;

public class SimpleConnection {

	private static Logger logger = Logger.getLogger(JsonConnection.class.getName());

	private static int TIMEOUT = 1000;

	public SimpleConnection(){

	}

	/**
	 * Returns the content from the specified url as a string - A null value is returned if any failures occur whilst trying to return the value.
	 *
	 * @param url
	 * @return
	 */
	public String get(String url) {
		try {
			URL u = new URL(url);
			HttpURLConnection c = (HttpURLConnection) u.openConnection();
			c.setRequestMethod("GET");
			c.setRequestProperty("Content-length", "0");
			c.setUseCaches(false);
			c.setAllowUserInteraction(false);
			c.setConnectTimeout(TIMEOUT);
			c.setReadTimeout(TIMEOUT);
			c.connect();
			int status = c.getResponseCode();

			switch (status) {
				case 200:
				case 201:
					BufferedReader br = new BufferedReader(new InputStreamReader(c.getInputStream()));
					StringBuilder sb = new StringBuilder();
					String line;
					while ((line = br.readLine()) != null) {
						sb.append(line+"\n");
					}
					br.close();
					return sb.toString();
				default:
					logger.error(url+": Status code error "+status);
			}

		} catch (MalformedURLException e) {
			logger.error(url+": "+e);
		} catch (IOException e) {
			logger.error(url+": "+e);
		} catch (Exception e){
			logger.error(url+": "+e);
		}
		return null;
	}
}
