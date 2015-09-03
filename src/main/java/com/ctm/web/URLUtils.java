package com.ctm.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.HttpURLConnection;
import java.net.URL;

import static com.ctm.logging.LoggingArguments.kv;

/**
 * The Class URLUtils.
 *
 * @author msmerdon
 * @version 1.0
 */

public class URLUtils {

	private static final Logger logger = LoggerFactory.getLogger(URLUtils.class.getName());

	public static boolean exists(String URLName){
		try {
			HttpURLConnection.setFollowRedirects(false);
			HttpURLConnection con = (HttpURLConnection) new URL(URLName).openConnection();
			con.setRequestMethod("HEAD");
			return (con.getResponseCode() == HttpURLConnection.HTTP_OK);
		}
		catch (Exception e) {
			logger.error("Failed to check url. {}",kv("URLName",URLName),e);
			return false;
		}
	}
}
