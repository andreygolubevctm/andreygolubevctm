package com.disc_au.soap;

import com.ctm.model.settings.SoapAggregatorConfiguration;
import com.ctm.model.settings.SoapClientThreadConfiguration;
import com.ctm.utils.function.Action;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

import static com.ctm.logging.LoggingArguments.kv;

public class HtmlFormClientThread extends SOAPClientThread {

	public HtmlFormClientThread(String tranId, String configRoot,
								SoapClientThreadConfiguration configuration, String xmlData,
								String name,
								SoapAggregatorConfiguration soapConfiguration, Action beforeRun, Action afterRun) {
		super(tranId, configRoot, configuration, xmlData, name,
				soapConfiguration, beforeRun, afterRun);
	}

	private static final Logger LOGGER = LoggerFactory.getLogger(HtmlFormClientThread.class);

	/**
	 * Process request.
	 *
	 * @param soapRequest the soap request
	 * @return the string
	 */
	protected String processRequest(String soapRequest) {

		StringBuffer returnData = new StringBuffer();
		long startTime = System.currentTimeMillis();

		try {
			// We now have a request - try to connect.
			URL u = new URL(getConfiguration().getUrl());

			HttpURLConnection connection = (HttpURLConnection) u
					.openConnection();
			connection.setReadTimeout(getConfiguration().getTimeoutMillis());
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod(this.method);
			connection.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");

			// If a user and password given, encode and set the user/password
			if (getConfiguration().getUser() != null && !getConfiguration().getUser().isEmpty()
					&& getConfiguration().getPassword() != null && !getConfiguration().getPassword().isEmpty()) {

				String userPassword = getConfiguration().getUser() + ":" + getConfiguration().getPassword();
				String encoded = Base64.encodeBase64String(userPassword.getBytes());
				connection.setRequestProperty("Authentication", "Basic "
						+ encoded);
			}

			int i = soapRequest.indexOf('>');
			String data = soapRequest.substring(i+1);

			// Strip carriage returns and tabs from the xml
			data = data.replace("\n","");
			data = data.replace("\r","");
			data = data.replace("\t","");

			data = "QuoteData=" + URLEncoder.encode(data,"UTF-8");

			// Important! keep this as debug and don't enable debug logging in production
			// data may include credit card details (this is from the nib webservice)
			LOGGER.debug("[HTML Response] {}", kv("data", data));

			// Send the request
			connection.setRequestProperty("Content-Length", String.valueOf(data.length()));
			Writer wout = new OutputStreamWriter(connection.getOutputStream());
			wout.write(data);
			wout.flush();

			this.setResponseCode(connection.getResponseCode());

			switch (connection.getResponseCode()){
				case HTTP_OK: {
					// Receive the result
					InputStreamReader rin = new InputStreamReader(connection.getInputStream());
					BufferedReader response = new BufferedReader(rin);
					String line;
					while ((line = response.readLine()) != null) {
						returnData.append(line);
					}
					// Clean up the streams and the connection
					rin.close();

					break;
				}
				case HTTP_NOT_FOUND: {
					SOAPError err = new SOAPError(SOAPError.TYPE_HTTP,
							((HttpURLConnection)connection).getResponseCode(),
							((HttpURLConnection)connection).getResponseMessage(),
							getConfiguration().getName(),
							getConfiguration().getUrl(),
							(System.currentTimeMillis() - startTime));

					returnData.append(err.getXMLDoc());
					break;
				}
				// An error or some unknown condition occurred
				default: {
					StringBuffer errorData = new StringBuffer();
					BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getErrorStream()));

					String line;
					while ((line = reader.readLine()) != null) {
						errorData.append(line);
					}
					reader.close();

					// Has the service responded with XML? e.g. SOAP
					String responseContentType = connection.getContentType();
					if (responseContentType != null && responseContentType.toLowerCase().contains("text/xml")) {
						returnData.append(errorData.toString());
					}
					// Unhandled error, wrap it in our own XML
					else {
						LOGGER.error("Error Data. {}", kv("errorData", errorData));
						SOAPError err = new SOAPError(SOAPError.TYPE_HTTP,
								connection.getResponseCode(),
								connection.getResponseMessage(),
								getConfiguration().getName(),
								errorData.toString(),
								(System.currentTimeMillis() - startTime));

						returnData.append(err.getXMLDoc());
					}

				}
			}

			wout.close();
			connection.disconnect();

			this.responseTime = System.currentTimeMillis() - startTime;

		} catch ( IOException e) {
			LOGGER.error("failed to processRequest", e);
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), getConfiguration().getName(), e.getClass().getName(), (System.currentTimeMillis() - startTime));
			returnData.append(err.getXMLDoc());

		}

		this.responseTime = System.currentTimeMillis() - startTime;

		// Return the result
		return returnData.toString();
	}
}
