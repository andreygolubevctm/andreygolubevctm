package com.disc_au.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;

import org.apache.log4j.Logger;

public class Dreammail {

	static Logger logger = Logger.getLogger(Dreammail.class.getName());

	public static String send(String username, String password, String servername, String rtm_url, String xml_content, String debugOn, Boolean is_exact_target) throws IOException{
		if(xml_content == null || xml_content.isEmpty()) {
			throw new IllegalArgumentException("xml content is empty");
		}
		if (rtm_url.indexOf("http") != 0) {
			rtm_url = "http://" + rtm_url;
		}
		logger.debug("DreamMail params:");
		logger.debug("Username=" +username);
		// Keep level as debug so as not to log password
		logger.debug("Password=" +password);
		logger.debug("ServerName=" +servername);
		logger.debug("Url=" +rtm_url);
		logger.debug("XML=" +xml_content);
		logger.debug("Exact Target=" + (is_exact_target == true ? "true" : "false"));

		URL url = new URL(rtm_url);
		URLConnection connection = url.openConnection();
		connection.setDoOutput(true);

		// Set the HTTP headers
		if( is_exact_target == true ) {
			connection.setRequestProperty("SOAPAction", "Create");
			connection.setRequestProperty("Content-Type", "text/xml");
		} else {
		connection.setRequestProperty("ServerName", servername);
		connection.setRequestProperty("UserName", username);
		connection.setRequestProperty("Password", password);
		}

		// Write the data
		PrintWriter out = new PrintWriter(connection.getOutputStream());
		out.print(xml_content);
		out.close();

		BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		String inputLine;
		StringBuffer resp = new StringBuffer();
		while ((inputLine = in.readLine()) != null) {
			resp.append(inputLine);
		}
		logger.debug("Result:");
		logger.debug(resp.toString());
		return resp.toString();
	}
}
