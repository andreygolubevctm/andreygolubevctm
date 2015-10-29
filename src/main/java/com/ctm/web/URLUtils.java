package com.ctm.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.HttpURLConnection;
import java.net.URL;

import static com.ctm.web.core.logging.LoggingArguments.kv;

/**
 * The Class URLUtils.
 *
 * @author msmerdon
 * @version 1.0
 */

public class URLUtils {

	private static final Logger LOGGER = LoggerFactory.getLogger(URLUtils.class);

	public static boolean exists(String URLName){
		try {
			HttpURLConnection.setFollowRedirects(false);
			HttpURLConnection con = (HttpURLConnection) new URL(URLName).openConnection();
			con.setRequestMethod("HEAD");
			return (con.getResponseCode() == HttpURLConnection.HTTP_OK);
		}
		catch (Exception e) {
			LOGGER.error("Failed to check url. {}",kv("URLName",URLName),e);
			return false;
		}
	}
}
