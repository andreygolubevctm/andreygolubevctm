package com.ctm.web.core.connectivity;


import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.commonlogging.correlationid.CorrelationIdUtils;
import com.ctm.interfaces.common.types.CorrelationId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class SimpleConnection {

	private static final Logger LOGGER = LoggerFactory.getLogger(SimpleConnection.class);

	private int connectTimeout = 1000;
	private int readTimeout = 1000;
	private String requestMethod = "GET";
	private String contentType = null;
	private String postBody = null;
	private boolean hasCorrelationId = false;

	public SimpleConnection() {
	}

	/**
	 * Returns the content from the specified url as a string. Return null if any failures occur whilst trying to return the value.
	 *
	 * @param url to call
	 * @return outcome of url call
	 */
	public String get(String url) {
		try {
			URL u = new URL(url);
			HttpURLConnection c = (HttpURLConnection) u.openConnection();
			if(hasCorrelationId) {
				final Optional<CorrelationId> correlationId = LoggingVariables.getCorrelationId();
				correlationId.ifPresent(cId -> CorrelationIdUtils.setCorrelationIdRequestHeader(c, cId));
			}
			c.setRequestMethod(getRequestMethod());
			c.setRequestProperty("Content-length", "0");
			c.setUseCaches(false);
			c.setAllowUserInteraction(false);
			c.setConnectTimeout(getConnectTimeout());
			c.setReadTimeout(getReadTimeout());

			if (getContentType() != null) {
				c.setRequestProperty("Content-Type", getContentType());
			}

			if (postBody != null) {
				c.setDoOutput(true);

				OutputStream os = c.getOutputStream();
				BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
				writer.write(postBody);
				writer.flush();
				writer.close();
				os.close();
			}

			c.connect();

			int status = c.getResponseCode();

			switch (status) {
				case 200:
				case 201:
					BufferedReader br = new BufferedReader(new InputStreamReader(c.getInputStream(), "UTF-8"));
					StringBuilder sb = new StringBuilder();
					String line;
					while ((line = br.readLine()) != null) {
						sb.append(line+"\n");
					}
					br.close();
					return sb.toString();
				default:
					String message = c.getResponseMessage();
					LOGGER.debug("Request returned error {}", kv("status", status), kv("message", message));
			}
		}
		catch (MalformedURLException e) {
			LOGGER.error("Invalid URL {}", kv("url", url), e);
		}
		catch (Exception e) {
			LOGGER.error("Error performing get request {}", kv("url", url), e);
		}
		return null;
	}

	/**
	 * Get the timeout value for the connection.
	 * @return Timeout in milliseconds
	 */
	private int getConnectTimeout() {
		return connectTimeout;
	}

	/**
	 * Set the timeout of the request connection.
	 * @param timeout milliseconds e.g. 1000 for 1 second
	 */
	public void setConnectTimeout(int timeout) {
		this.connectTimeout = timeout;
	}

	/**
	 * Get the timeout value for the request read.
	 * @return Timeout in milliseconds
	 */
	private int getReadTimeout() {
		return readTimeout;
	}

	/**
	 * Set the timeout of the request read.
	 * @param timeout milliseconds e.g. 1000 for 1 second
	 */
	public void setReadTimeout(int timeout) {
		this.readTimeout = timeout;
	}

	private String getRequestMethod() {
		return requestMethod;
	}

	public void setRequestMethod(String requestMethod) {
		this.requestMethod = requestMethod;
	}

	private String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}


	public void setPostBody(String postBody) {
		this.postBody = postBody;
	}

	public void setHasCorrelationId(boolean hasCorrelationId) {
		this.hasCorrelationId = hasCorrelationId;
	}
}
