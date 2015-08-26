package com.ctm.web;

import java.net.HttpURLConnection;
import java.net.URL;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
			logger.error("{}",e.toString());
			return false;
		}
	}
}
