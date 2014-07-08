package com.ctm.web;

import java.net.URL;
import java.net.HttpURLConnection;

/**
 * The Class URLUtils.
 *
 * @author msmerdon
 * @version 1.0
 */

public class URLUtils {

	public static boolean exists(String URLName){
		try {
			HttpURLConnection.setFollowRedirects(false);
			HttpURLConnection con = (HttpURLConnection) new URL(URLName).openConnection();
			con.setRequestMethod("HEAD");
			return (con.getResponseCode() == HttpURLConnection.HTTP_OK);
		}
		catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
