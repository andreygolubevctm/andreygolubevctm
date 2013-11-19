package com.disc_au.soap;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

import org.apache.commons.codec.binary.Base64;

import com.disc_au.web.go.xml.XmlNode;

public class HtmlFormClientThread extends SOAPClientThread {
	public HtmlFormClientThread(String tranId, String configRoot, XmlNode config,
			String xmlData, String name) {
		super(tranId, configRoot, config, xmlData, name);
	}

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
			URL u = new URL(this.url);

			HttpURLConnection connection = (HttpURLConnection) u
					.openConnection();
			connection.setReadTimeout(this.timeoutMillis);
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod(this.method);
			connection.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");

			// If a user and password given, encode and set the user/password
			if (this.user != null && !this.user.isEmpty()
					&& this.password != null && !this.password.isEmpty()) {

				String userPassword = this.user + ":" + this.password;
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

			System.out.println("HTMLFormClientThread "+data);

			logTime("Initialise service connection (HtmlFormClient)");
			// Send the request
			connection.setRequestProperty("Content-Length", String.valueOf(data.length()));
			Writer wout = new OutputStreamWriter(connection.getOutputStream());
			wout.write(data);
			wout.flush();
			logTime("Write to service");
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

					logTime("Receive from service");
					break;
				}
				case HTTP_NOT_FOUND: {
					SOAPError err = new SOAPError(SOAPError.TYPE_HTTP,
							((HttpURLConnection)connection).getResponseCode(),
							((HttpURLConnection)connection).getResponseMessage(),
							this.serviceName,
							this.url,
							(System.currentTimeMillis() - startTime));

					returnData.append(err.getXMLDoc());
					logTime("Receive from service");
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
						System.err.println("HTMLFormClientThread "+"Error Data: " + errorData);
						SOAPError err = new SOAPError(SOAPError.TYPE_HTTP,
									connection.getResponseCode(),
									connection.getResponseMessage(),
									this.serviceName,
									errorData.toString(),
									(System.currentTimeMillis() - startTime));

						returnData.append(err.getXMLDoc());
					}

					logTime("Receive from service");
				}
			}

			System.err.println("HTMLFormClientThread "+"Response Code: " + connection.getResponseCode());

			wout.close();
			connection.disconnect();

			this.responseTime = System.currentTimeMillis() - startTime;

		} catch (MalformedURLException e) {
			e.printStackTrace();
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), this.serviceName, "MalformedURLException", (System.currentTimeMillis() - startTime));
			returnData.append(err.getXMLDoc());

		} catch (IOException e) {
			e.printStackTrace();
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), this.serviceName, "IOException", (System.currentTimeMillis() - startTime));
			returnData.append(err.getXMLDoc());
		}

		this.responseTime = System.currentTimeMillis() - startTime;

		// Return the result
		return returnData.toString();
	}
}
