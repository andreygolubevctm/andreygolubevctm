package com.disc_au.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class Dreammail {

	private static final Logger LOGGER = LoggerFactory.getLogger(Dreammail.class);

	public static String send(String username, String password, String servername, String rtm_url, String xml_content, String debugOn, Boolean is_exact_target) throws IOException{
		if(xml_content == null || xml_content.isEmpty()) {
			throw new IllegalArgumentException("xml content is empty");
		}
		if (rtm_url.indexOf("http") != 0) {
			rtm_url = "http://" + rtm_url;
		}
		LOGGER.debug("[Email] Message sent. {} ", kv("xml_content", xml_content));

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
		OutputStream os = connection.getOutputStream();
		BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
		writer.write(xml_content);
		writer.flush();
		writer.close();
		os.close();

		BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		String inputLine;
		StringBuffer resp = new StringBuffer();
		while ((inputLine = in.readLine()) != null) {
			resp.append(inputLine);
		}

		LOGGER.debug("[Email] Message received. {}", kv("resp", resp));
		return resp.toString();
	}
}
