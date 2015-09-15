package com.ctm.connectivity;

import com.ctm.connectivity.exception.ConnectionException;
import com.ctm.utils.RequestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class SimpleConnection {

	private static final Logger logger = LoggerFactory.getLogger(SimpleConnection.class.getName());

	private int connectTimeout = 1000;
	private int readTimeout = 1000;
	private String requestMethod = "GET";
	private String contentType = null;
	private String postBody = null;



	public SimpleConnection() {
	}

	/**
	 * Returns the content from the specified url as a string - A null value is returned if any failures occur whilst trying to return the value.
	 *
	 * @param url
	 * @return
	 */
	public String get(String url) throws ConnectionException {
		try {
			URL u = new URL(url);
			HttpURLConnection c = (HttpURLConnection) u.openConnection();
			RequestUtils.setCorrelationIdHeader(c);
			c.setRequestMethod(getRequestMethod());
			c.setRequestProperty("Content-length", "0");
			c.setUseCaches(false);
			c.setAllowUserInteraction(false);
			c.setConnectTimeout(getConnectTimeout());
			c.setReadTimeout(getReadTimeout());

			if (getContentType() != null) {
				c.setRequestProperty("Content-Type", getContentType());
			}

			if (getPostBody() != null) {
				c.setDoOutput(true);

				OutputStream os = c.getOutputStream();
				BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
				writer.write(getPostBody());
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
					logger.error(url + ": Status code error " + status + " " + message);
			}
		}
		catch (Exception e) {
			throw new ConnectionException(url+": "+e , e);
		}
		return null;
	}

	/**
	 * Get the timeout value for the connection.
	 * @return Timeout in milliseconds
	 */
	public int getConnectTimeout() {
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
	public int getReadTimeout() {
		return readTimeout;
	}

	/**
	 * Set the timeout of the request read.
	 * @param timeout milliseconds e.g. 1000 for 1 second
	 */
	public void setReadTimeout(int timeout) {
		this.readTimeout = timeout;
	}

	public String getRequestMethod() {
		return requestMethod;
	}

	public void setRequestMethod(String requestMethod) {
		this.requestMethod = requestMethod;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getPostBody() {
		return postBody;
	}

	public void setPostBody(String postBody) {
		this.postBody = postBody;
	}
}
