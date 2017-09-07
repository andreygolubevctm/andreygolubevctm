package com.ctm.web.core.web;

import com.ctm.web.core.model.Touch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class Dreammail {

	private static final Logger LOGGER = LoggerFactory.getLogger(Dreammail.class);

	public static String send(String username, String password, String servername, String rtm_url, String xml_content, String debugOn, Boolean is_exact_target ,String transactionId, String emailTemplate) throws Exception {

		StringBuffer resp;
		try {
			Utils.createBPTouches(transactionId, Touch.TouchType.BP_EMAIL_STARTED, xml_content,true);
			LOGGER.info("BPEMAIL Sending email for: {} {} {} {}",
					kv("transactionId", transactionId), kv("emailTemplate", emailTemplate),
					kv("exactTarget", is_exact_target), kv("rtm_url", rtm_url));
			if(xml_content == null || xml_content.isEmpty()) {
				throw new IllegalArgumentException("xml content is empty");
			}
			if (rtm_url.indexOf("http") != 0) {
				rtm_url = "http://" + rtm_url;
			}
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
			resp = new StringBuffer();
			while ((inputLine = in.readLine()) != null) {
				resp.append(inputLine);
			}
			LOGGER.info("BPEMAIL Email successfully sent for: {} {} {} {} {}" ,
					kv("transactionId", transactionId), kv("emailTemplate", emailTemplate),
					kv("exactTarget", is_exact_target), kv("emailProviderResponse", resp), kv("rtm_url", rtm_url));
			Utils.createBPTouches(transactionId, Touch.TouchType.BP_EMAIL_END,xml_content, true);
		}
		catch(Exception e){
			LOGGER.error("BPEMAIL Caught exception sending email for: {} {} {} {} {}" ,
					kv("transactionId", transactionId), kv("emailTemplate", emailTemplate),
					kv("exactTarget", is_exact_target), kv("caughtException", e.getMessage()), kv("rtm_url", rtm_url));
			throw e;
		}
		return resp.toString();
	}
}
