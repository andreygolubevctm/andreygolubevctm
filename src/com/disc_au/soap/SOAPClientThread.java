/**  ========================================== */
/**  SOAPClientThread SOAP Class with WAR compatibility and OTI fix
 *   $Id$
 * (c)2013 Auto & General Holdings Pty Ltd      */

package com.disc_au.soap;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.disc_au.web.go.xml.XmlNode;


/**
 * The Class SOAPClientThread with WAR compatibility and OTI fix.
 *
 * @author aransom
 * @version 1.1-OTI
 */
public class SOAPClientThread implements Runnable {

	private Logger logger = Logger.getLogger(SOAPClientThread.class.getName());

	public static final int HTTP_OK = 200;
	public static final int HTTP_NOT_FOUND = 404;

	/** The tran id. */
	protected String tranId;

	/** The name. */
	protected String name;

	/** The url. */
	protected String url;

	/** The user. */
	protected String user;

	/** The password. */
	protected String password;

	/** The soap action. */
	protected String soapAction;

	/** The config file root path. */
	protected String configRoot;

	protected String outboundXSL;
	private String maskReqOutXSL;
	private String maskReqInXSL;
	private String maskRespInXSL;

	/** The inbound xsl. */
	protected String inboundXSL = null;

	/** The timeout millis. */
	protected int timeoutMillis;

	/** The xml. */
	protected String xml;


	/** The result xml. */
	protected String resultXML = "";

	/** The timer. */
	protected long timer; // debug timer

	public String method = "POST";

	protected String serviceName;

	protected int responseCode;

	protected long responseTime;

	protected String inboundParms;

	protected String outboundParms;

	//protected String sslCertStore;
	//protected String sslCertPass;
	protected String sslNoHostVerify;
	protected String extractElement;
	protected String clientCert;
	protected String clientCertPass;
	protected String unescapeElement;
	protected String contentType;
	private String accept;
	private SOAPOutputWriter writer;
	private XsltTranslator translator;

	public static final String DEFAULT_CONTENT_TYPE = "text/xml; charset=\"utf-8\"";


	/**
	 * Instantiates a new SOAP client thread.
	 *
	 * @param tranId the tran id
	 * @param configRoot the config root
	 * @param config the config
	 * @param xmlData the xml data
	 * @param name the name
	 */
	public SOAPClientThread(String tranId, String configRoot, XmlNode config,
			String xmlData, String name) {

		this.name = name;
		this.configRoot = configRoot;
		this.url = (String) config.get("soap-url/text()");
		this.user = (String) config.get("soap-user/text()");
		this.password = (String) config.get("soap-password/text()");
		this.soapAction = (String) config.get("soap-action/text()");
		this.outboundXSL = this.configRoot + '/'
				+ (String) config.get("outbound-xsl/text()");

		String maskInXsl = (String) config.get("maskRequestIn-xsl/text()");
		String maskOutXsl = (String) config.get("maskRequestOut-xsl/text()");
		String maskRespInXslConfig = (String) config.get("maskRespIn-xsl/text()");
		if(maskInXsl != null) {
			this.maskReqInXSL = this.configRoot + '/' + maskInXsl;
		}
		if(maskOutXsl != null) {
			this.maskReqOutXSL = this.configRoot + '/' + maskOutXsl;
		}




		if(maskRespInXslConfig != null) {
			this.maskRespInXSL = this.configRoot + '/' + maskRespInXslConfig;
		}

		this.outboundParms = (String) config.get("outbound-xsl-parms/text()");

		this.inboundXSL = this.configRoot + '/'
				+ (String) config.get("inbound-xsl/text()");

		this.inboundParms = (String) config.get("inbound-xsl-parms/text()");

		this.xml = xmlData;

		this.serviceName = config.getAttribute("name");

		if( config.hasChild("soap-method") ) {
			this.method = (String) config.get("soap-method/text()");
		}

		String timeout = (String) config.get("timeoutMillis/text()");
		setTimeoutMillis(Integer.parseInt(timeout));

		this.tranId = tranId;

		//this.sslCertStore = (String) config.get("ssl-cert-store/text()");
		//this.sslCertPass = (String) config.get("ssl-cert-password/text()");
		this.sslNoHostVerify = (String) config.get("ssl-no-host-verify/text()");
		this.clientCert = (String) config.get("ssl-client-certificate/text()");
		this.clientCertPass = (String) config.get("ssl-client-certificate-password/text()");
		this.unescapeElement = (String) config.get("unescape-element/text()");
		this.extractElement =(String) config.get("extract-element/text()");
		this.contentType =(String) config.get("content-type/text()");
		this.accept = (String) config.get("accept/text()");

		if (this.contentType == null || this.contentType.trim().length()==0){
			this.contentType = DEFAULT_CONTENT_TYPE;
	}
		translator = new XsltTranslator(this.configRoot);
		writer = new SOAPOutputWriter(this.name, translator , this.tranId);
	}

	/**
	 * Gets the name.
	 *
	 * @return the name
	 */
	public String getName() {
		return this.name;
	}

	/**
	 * Gets the result xml.
	 *
	 * @return the result xml
	 */
	public String getResultXML() {
		return resultXML;
	}

	/**
	 * Gets the timeout millis.
	 *
	 * @return the timeout millis
	 */
	public int getTimeoutMillis() {
		return timeoutMillis;
	}

	/**
	 * Log time.
	 *
	 * @param msg the msg
	 */
	protected void logTime(String msg) {
		logTime(msg, this.timer);
		this.timer = System.currentTimeMillis();
	}

	/**
	 * Log time.
	 *
	 * @param msg the msg
	 * @param timer the timer
	 */
	private void logTime(String msg, long timer) {
		logger.info(this.name + ": " + msg + ": "
				+ (System.currentTimeMillis() - timer) + "ms ");
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
			// We now have a soap request - try to connect.
			URL u;
			HttpURLConnection connection;
			if (this.url.startsWith("https")) {

/**				if (this.sslCertStore != null && this.sslCertPass != null) {
					SSLSocketFactory sf = this.getSSLSocketFactory(this.sslCertStore, this.sslCertPass);
					if (sf !=null){
						HttpsURLConnection.setDefaultSSLSocketFactory(sf);
					}
				}
**/
				if (this.sslNoHostVerify != null && this.sslNoHostVerify.equalsIgnoreCase("Y")) {
					HttpsURLConnection.setDefaultHostnameVerifier(
							new HostnameVerifier() {
								public boolean verify(String hostname,SSLSession session) {
									return true;
								}

					});
				}

				u = new URL(this.url);
				connection = (HttpsURLConnection) u.openConnection();

				if (this.clientCert !=null && this.clientCertPass != null){
					logger.info("Using Cert: "+this.clientCert);
					try {

						// First, try on the classpath (assume given path has no leading slash)
						InputStream clientCertSourceInput = this.getClass().getClassLoader().getResourceAsStream(this.clientCert);

						// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
						if ( clientCertSourceInput == null ) {
							this.clientCert = "../" + this.clientCert;
							clientCertSourceInput = this.getClass().getClassLoader().getResourceAsStream(this.clientCert);
						}

						logger.info("Cert Exists: " + ( clientCertSourceInput == null ? "NOOOO" : "Yep" ));

						String pKeyPassword = this.clientCertPass;
						//KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance("SunX509");
						KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());

						KeyStore keyStore = KeyStore.getInstance("PKCS12");

						keyStore.load(clientCertSourceInput, pKeyPassword.toCharArray());
						keyManagerFactory.init(keyStore, pKeyPassword.toCharArray());

						SSLContext context = SSLContext.getInstance("TLS");
						context.init(keyManagerFactory.getKeyManagers(), null, new SecureRandom());
						SSLSocketFactory sockFact = context.getSocketFactory();

						((HttpsURLConnection) connection).setSSLSocketFactory( sockFact );

					} catch (NoSuchAlgorithmException e) {
						logger.error("Cert Error: 1 (No Such Algorithm)", e);
					} catch (CertificateException e) {
						logger.error("Cert Error: 2 (Certificate exception)", e);
					} catch (UnrecoverableKeyException e) {
						logger.error("Cert Error: 3 (Unrecoverable Key)", e);
					} catch (KeyStoreException e) {
						logger.error("Cert Error: 4 (Key Store exception)", e);
					} catch (KeyManagementException e) {
						logger.error("Cert Error: 5 (Key Management exception)", e);
					}
				}

			} else {
				u = new URL(this.url);
				connection = (HttpURLConnection) u.openConnection();

			}

			connection.setReadTimeout(this.timeoutMillis);
			connection.setDoOutput(true);
			connection.setDoInput(true);

			((HttpURLConnection)connection).setRequestMethod(this.method);
			connection.setRequestProperty("Content-Type", this.contentType);

			// Set the soap action (if supplied)
			if (this.soapAction != null) {
				connection.setRequestProperty("SOAPAction", this.soapAction);
			}

			// If a user and password given, encode and set the user/password
			if (this.user != null && !this.user.isEmpty()
					&& this.password != null && !this.password.isEmpty()) {

				String userPassword = this.user + ":" + this.password;
				String encoded = Base64.encodeBase64String(userPassword.getBytes());
				connection.setRequestProperty("Authorization", "Basic "	+ encoded);
			}

			if (this.accept != null)
			{
				connection.setRequestProperty("Accept", this.accept);
			}

			logTime("Initialise service connection (SOAPClient)");
			// Send the soap request
			Writer wout = new OutputStreamWriter(connection.getOutputStream());
			wout.write(soapRequest);
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
					logger.info(connection.getResponseCode());
					// Important! keep this as debug and don't enable debug logging in production
					// as this response may include credit card details (this is from the nib webservice)
					logger.debug(connection.getResponseMessage());

					StringBuffer errorData = new StringBuffer();
					BufferedReader reader = new BufferedReader(new InputStreamReader(((HttpURLConnection)connection).getErrorStream()));
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
					SOAPError err = new SOAPError(SOAPError.TYPE_HTTP,
												((HttpURLConnection)connection).getResponseCode(),
												((HttpURLConnection)connection).getResponseMessage(),
												this.serviceName,
							errorData.toString(),
							(System.currentTimeMillis() - startTime));

					returnData.append(err.getXMLDoc());
					}

					logTime("Receive from service");
				}
			}

			logger.warn("Response Code: " + ((HttpURLConnection)connection).getResponseCode());

			wout.close();
			((HttpURLConnection)connection).disconnect();

		} catch (MalformedURLException e) {
			logger.error("failed to process request" , e);
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), this.serviceName, "MalformedURLException", (System.currentTimeMillis() - startTime));
			returnData.append(err.getXMLDoc());

		} catch (IOException e) {
			logger.error("failed to process request" , e);
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), this.serviceName, "IOException", (System.currentTimeMillis() - startTime));
			returnData.append(err.getXMLDoc());
		}

		this.responseTime = System.currentTimeMillis() - startTime;

		// Return the result
		return returnData.toString();
	}

	public void run() {
		this.timer = System.currentTimeMillis();

		writer.writeXmlToFile(this.xml, "req_in" , this.maskReqInXSL);

		Map<String , Object> params = new HashMap<String , Object>();
		if (this.tranId!=null){
			params.put("transactionId",this.tranId);
		}

		// Set the soap action (if supplied)
		if (this.soapAction != null) {
			params.put("SoapAction", this.soapAction);
		}
		if (this.url != null) {
			params.put("SoapUrl", this.url);
		}

		// Translate the page xml to be suitable for the client
		String soapRequest = translator.translate(this.outboundXSL, this.xml, this.outboundParms , params , true);

		writer.writeXmlToFile(soapRequest, "req_out" , this.maskReqOutXSL);

		logTime("Translate outbound XSL");

		// Determine if the only thing written to the soapRequest is the header
		int i = soapRequest.indexOf('<',2);
		if (i > -1 ) {


			// Send the soap request off for processing
			String soapResponse = processRequest(soapRequest);

			if (this.extractElement!=null && this.extractElement.length() > 0){
				int startPos = soapResponse.indexOf("<"+this.extractElement+">");
				int endPos = soapResponse.lastIndexOf("</"+this.extractElement+">");

				if (startPos>-1 && endPos > -1){
					soapResponse=soapResponse.substring(startPos, endPos+this.extractElement.length()+3);
				}
			}

			writer.writeXmlToFile(soapResponse, "resp_in" , this.maskRespInXSL);

			// do we need to translate it?
			if (this.inboundXSL != null) {
				// Important! keep this as debug and don't enable debug logging in production
				// as this response may include credit card details (this is from the nib webservice)
				logger.debug(this.name + ":" + soapResponse);

				// The following ugliness had to be added to get OTI working ..
				//REVISE: oh please do - we need something better than this.... :(
				if (this.unescapeElement != null){
					String startElement="<"+this.unescapeElement+">";
					int startIdx = soapResponse.indexOf(startElement);
					if (startIdx > -1){
						startIdx += startElement.length();
					}
					String endElement="</"+this.unescapeElement+">";

					int endIdx = soapResponse.lastIndexOf(endElement);

					if (startIdx >-1 && endIdx > -1){
						String unescapeData = soapResponse.substring(startIdx,endIdx);

						unescapeData = unescapeData.replaceAll("&lt;", "<")
												.replaceAll("&gt;", ">")
												.replaceAll("&quot;", "\"")
												.replaceAll("&amp;", "&");
						if (unescapeData.startsWith("<?")){
							int endOfHeader = unescapeData.indexOf("?>");
							if (endOfHeader > -1) {
								unescapeData = unescapeData.substring(endOfHeader+2);
							}
						}

						soapResponse = soapResponse.substring(0,startIdx)
									+ unescapeData
									+ soapResponse.substring(endIdx);

					}


				}

				if (this.xml!=null) {
					NodeList req = createRequestNodeList(this.xml);
					params.put("request", req);
				}

				setResultXML(translator.translate(this.inboundXSL,
						soapResponse, this.inboundParms, params , false));
				logTime("Translate inbound XSL");
			} else {
				this.setResultXML(soapResponse);
			}

			writer.writeXmlToFile(this.resultXML, "resp_out" , null);
		}
	}

	/**
	 * Sets the debug path.
	 *
	 * @param debugPath the new debug path
	 */
	public void setDebugPath(String debugPath) {
		writer.setDebugPath(debugPath);
	}

	/**
	 * Sets the result xml.
	 *
	 * @param resultXML the new result xml
	 */
	public void setResultXML(String resultXML) {
		this.resultXML = resultXML;
	}

	// SETTERS AND GETTERS..
	/**
	 * Sets the timeout millis.
	 *
	 * @param timeoutMillis the new timeout millis
	 */
	public void setTimeoutMillis(int timeoutMillis) {
		this.timeoutMillis = timeoutMillis;
	}

	private NodeList createRequestNodeList(String requestXml){
		try {

			InputSource inputSource = new InputSource(new StringReader(requestXml));

			DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder;

			docBuilder = docBuilderFactory.newDocumentBuilder();
			Document doc = docBuilder.parse(inputSource);

			NodeList nodeList = doc.getElementsByTagName("quote");
			if (nodeList == null || nodeList.getLength()==0){
				nodeList = doc.getChildNodes();
			}
			if (nodeList != null){
				return nodeList;
			}
		} catch (ParserConfigurationException e) {
			logger.error("failed to createRequestNodeList" , e);
		} catch (SAXException e) {
			logger.error("failed to createRequestNodeList" , e);
		} catch (IOException e) {
			logger.error("failed to createRequestNodeList" , e);
		}
		return null;
	}

	public void setResponseCode(int responseCode) {
		this.responseCode = responseCode;
	}

	public int getResponseCode() {
		return responseCode;
	}
	public String getServiceName(){
		return this.serviceName;
	}
	public long getResponseTime(){
		return this.responseTime;
	}
			}
