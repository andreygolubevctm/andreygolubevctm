/**  ========================================== */
/**  SOAPClientThread SOAP Class with WAR compatibility and OTI fix
 *   $Id$
 * (c)2013 Auto & General Holdings Pty Ltd      */

package com.ctm.web.core.soap;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.commonlogging.correlationid.CorrelationIdUtils;
import com.ctm.interfaces.common.types.CorrelationId;
import com.ctm.web.core.constants.ErrorCode;
import com.ctm.web.core.logging.XMLOutputWriter;
import com.ctm.web.core.model.soap.settings.SoapAggregatorConfiguration;
import com.ctm.web.core.model.soap.settings.SoapClientThreadConfiguration;
import com.ctm.web.core.utils.function.Action;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.security.*;
import java.security.cert.CertificateException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.logging.XMLOutputWriter.*;


/**
 * The Class SOAPClientThread with WAR compatibility and OTI fix.
 *
 * @author aransom
 * @version 1.1-OTI
 */
public class SOAPClientThread implements Runnable {

	private static final Logger LOGGER = LoggerFactory.getLogger(SOAPClientThread.class);

	public static final int HTTP_OK = 200;
	public static final int HTTP_NOT_FOUND = 404;
	private final Action beforeRun;
	private final Action afterRun;

	private SoapClientThreadConfiguration configuration;

	/** The tran id. */
	protected String tranId;

	/** The thread name. */
	protected String name;

	/** The xml. */
	protected String xml;

	/** The result xml. */
	protected String resultXML = "";

	/** The timer. */
	protected long timer; // debug timer

	public String method = "POST";

	private XsltTranslator translator;

	protected long responseTime;
	private int responseCode;

	private String debugPath;

	private SoapAggregatorConfiguration aggregatorConfiguration;

	private XMLOutputWriter writer;

	public static final String DEFAULT_CONTENT_TYPE = "text/xml; charset=\"utf-8\"";
	public static final String DEFAULT_ENCODING = "UTF-8";

	private String[] keywords = {"XML Parsing Error", "ValidatorException", "SOAPException", "XML Validation Exception", "Connection refused",
			"Read timed outIOException", "Invalid Agent Customer Id", "Invalid Agent Payment Id", "Invalid Previous Health Fund ID",
			"Invalid Partner Previous Health Fund ID", "Non-user related error", "MalformedURLException", "IOException"};

	/**
	 * Instantiates a new SOAP client thread.
	 *
	 * @param tranId
	 * @param configRoot the config root
	 * @param configuration for this thread
	 * @param xmlData the xml data
	 * @param threadName identifier for this thread
	 * @param soapConfiguration global config
	 */
	public SOAPClientThread(String tranId, String configRoot, SoapClientThreadConfiguration configuration,
							String xmlData, String threadName, SoapAggregatorConfiguration soapConfiguration, Action beforeRun, Action afterRun) {
		this.beforeRun = beforeRun;
		this.afterRun = afterRun;

		this.configuration = configuration;

		this.name = threadName;
		this.xml = xmlData;
		this.tranId = tranId;
		this.aggregatorConfiguration = soapConfiguration;

		if (configuration.getContentType() == null || configuration.getContentType().trim().length()==0){
			configuration.setContentType(DEFAULT_CONTENT_TYPE);
	}
		if (configuration.getEncoding() == null || configuration.getEncoding().trim().isEmpty()){
			configuration.setEncoding(DEFAULT_ENCODING);
	}
		translator = new XsltTranslator(configRoot, configuration.getEncoding());
		this.debugPath = soapConfiguration.getDebugPath();
	}


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

	protected void logTime(String msg) {
		logTime(msg, this.timer);
		this.timer = System.currentTimeMillis();
	}

	private void logTime(String msg, long timer) {
		//logger.info(this.name + ": " + msg + ": " + (System.currentTimeMillis() - timer) + "ms ");
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
			if (configuration.getUrl().startsWith("https")) {

				if (configuration.getSslNoHostVerify() != null && configuration.getSslNoHostVerify().equalsIgnoreCase("Y")) {
					HttpsURLConnection.setDefaultHostnameVerifier(
							(hostname, session) -> true);
				}

				u = new URL(configuration.getUrl());
				connection = (HttpsURLConnection) u.openConnection();


				if (configuration.getClientCert() !=null && configuration.getClientCertPass() != null){
					LOGGER.debug("Using Cert: " + configuration.getClientCert());
					try {

						// First, try on the classpath (assume given path has no leading slash)
						InputStream clientCertSourceInput = this.getClass().getClassLoader().getResourceAsStream(configuration.getClientCert());

						// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
						if ( clientCertSourceInput == null ) {
							configuration.setClientCert("../" + configuration.getClientCert());
							clientCertSourceInput = this.getClass().getClassLoader().getResourceAsStream(configuration.getClientCert());
						}

						LOGGER.debug("Checking if cert exists. {}" + kv("CertExists", clientCertSourceInput == null));

						String pKeyPassword = configuration.getClientCertPass();
						KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());

						KeyStore keyStore = KeyStore.getInstance("PKCS12");

						keyStore.load(clientCertSourceInput, pKeyPassword.toCharArray());
						keyManagerFactory.init(keyStore, pKeyPassword.toCharArray());

						SSLContext context = SSLContext.getInstance("TLS");
						context.init(keyManagerFactory.getKeyManagers(), null, new SecureRandom());
						SSLSocketFactory sockFact = context.getSocketFactory();

						((HttpsURLConnection) connection).setSSLSocketFactory( sockFact );

					} catch (NoSuchAlgorithmException e) {
						LOGGER.error("Cert Error: 1 (No Such Algorithm)", e);
					} catch (CertificateException e) {
						LOGGER.error("Cert Error: 2 (Certificate exception)", e);
					} catch (UnrecoverableKeyException e) {
						LOGGER.error("Cert Error: 3 (Unrecoverable Key)", e);
					} catch (KeyStoreException e) {
						LOGGER.error("Cert Error: 4 (Key Store exception)", e);
					} catch (KeyManagementException e) {
						LOGGER.error("Cert Error: 5 (Key Management exception)", e);
					}
				}

			} else {
				u = new URL(configuration.getUrl());
				connection = (HttpURLConnection) u.openConnection();

			}

			setCorrelationIdHeader(connection);

			connection.setReadTimeout(configuration.getTimeoutMillis());
			connection.setDoOutput(true);
			connection.setDoInput(true);

			((HttpURLConnection)connection).setRequestMethod(this.method);
			connection.setRequestProperty("Content-Type", configuration.getContentType());

			// Set the soap apply (if supplied)
			if (configuration.getSoapAction() != null) {
				connection.setRequestProperty("SOAPAction", configuration.getSoapAction());
			}

			// If a user and password given, encode and set the user/password
			if (configuration.getUser() != null && !configuration.getUser().isEmpty()
					&& configuration.getPassword() != null && !configuration.getPassword().isEmpty()) {

				String userPassword = configuration.getUser() + ":" + configuration.getPassword();
				String encoded = Base64.encodeBase64String(userPassword.getBytes());
				connection.setRequestProperty("Authorization", "Basic "	+ encoded);
			}

			if (configuration.getAccept() != null)
			{
				connection.setRequestProperty("Accept", configuration.getAccept());
			}

			// Send the soap request
			Writer wout = new OutputStreamWriter(connection.getOutputStream() , Charset.forName(configuration.getEncoding()));
			wout.write(soapRequest);
			wout.flush();

			this.setResponseCode(connection.getResponseCode());

			switch (connection.getResponseCode()) {
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
							configuration.getName(),
							configuration.getUrl(),
							(System.currentTimeMillis() - startTime));

					returnData.append(err.getXMLDoc());
					break;
				}
				// An error or some unknown condition occurred
				default: {

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
								configuration.getName(),
								errorData.toString(),
								(System.currentTimeMillis() - startTime));

					returnData.append(err.getXMLDoc());
					}

					logTime("Receive from service");
				}
			}

			wout.close();
			((HttpURLConnection)connection).disconnect();

		} catch (MalformedURLException e) {
			LOGGER.error("failed to process request" , e);
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), configuration.getName(), "MalformedURLException", (System.currentTimeMillis() - startTime));
			returnData.append(err.getXMLDoc());

		} catch (IOException e) {
			LOGGER.error("failed to process request: "+getConfiguration().getUrl() , e);
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), configuration.getName(), "IOException", (System.currentTimeMillis() - startTime));
			returnData.append(err.getXMLDoc());
		}

		this.responseTime = System.currentTimeMillis() - startTime;

		// Return the result
		return returnData.toString();
	}


	protected void setCorrelationIdHeader(URLConnection connection) {
		if(aggregatorConfiguration.isSendCorrelationId()) {
			final Optional<CorrelationId> correlationId = LoggingVariables.getCorrelationId();
			correlationId.ifPresent(cId -> CorrelationIdUtils.setCorrelationIdRequestHeader(connection, cId));
		}
	}

	private String matchKeywords(String soapResponse) {
		String errorData = "";
		for(String keyword : keywords) {
			if (soapResponse.toLowerCase().indexOf(keyword.toLowerCase()) != -1) {
				SOAPError err = new SOAPError(SOAPError.TYPE_HTTP,
						500,
						ErrorCode.MK_20004.getErrorCode(),
						configuration.getName(),
						"",
						0);

				LOGGER.debug("MK-20004 Soap error found. {},{}" , kv("soapResponse", soapResponse), kv("name", this.name));

				errorData = err.getXMLDoc();

				break;
			}
		}

		if(errorData.isEmpty()) {
			return soapResponse;
		}
		return errorData;
	}

	private String maskXml(String xml, String maskingXslt) {
		if(maskingXslt != null && !maskingXslt.isEmpty()) {
			Map<String , Object> params = new HashMap<String , Object>();
			if (this.tranId!=null){
				params.put("transactionId",this.tranId);
			}
			LOGGER.debug("masking file content. {}" + kv("maskingXslt", maskingXslt));
			xml = translator.translate(maskingXslt, xml, null,  params , false);
		}
		return xml;
	}

	public void run() {
		beforeRun.apply();
		this.timer = System.currentTimeMillis();
		if(aggregatorConfiguration.isWriteToFile()){
			writer = new XMLOutputWriter(this.name , debugPath);
			writer.writeXmlToFile(maskXml(this.xml , configuration.getMaskReqInXSL()) , REQ_IN);
		}

		Map<String, Object> params = new HashMap<>();
		if (this.tranId != null) {
			params.put("transactionId", this.tranId);
		}

		// Set the soap apply (if supplied)
		if (configuration.getSoapAction() != null) {
			params.put("SoapAction", configuration.getSoapAction());
		}
		if (configuration.getUrl() != null) {
			params.put("SoapUrl", configuration.getUrl());
		}

		// Translate the page xml to be suitable for the client
		String soapRequest = translator.translate(configuration.getOutboundXsl(), this.xml, configuration.getOutboundParms(), params, true);

		if(aggregatorConfiguration.isWriteToFile()){
			writer.writeXmlToFile(maskXml(soapRequest , configuration.getMaskReqInXSL()), REQ_OUT);
		}

		// Determine if the only thing written to the soapRequest is the header
		// 2015-01-15 LK This check for the < is from the original commit in 2012. Keeping it as legacy just so we don't break anything.
		int i = soapRequest.indexOf('<',2);
		if (i > -1 || soapRequest.trim().startsWith("{")) {

			// Send the soap request off for processing
			String soapResponse = processRequest(soapRequest);

			if (configuration.getExtractElement()!=null && configuration.getExtractElement().length() > 0){
				int startPos = soapResponse.indexOf("<"+configuration.getExtractElement()+">");
				int endPos = soapResponse.lastIndexOf("</"+configuration.getExtractElement()+">");

				if (startPos>-1 && endPos > -1){
					soapResponse=soapResponse.substring(startPos, endPos+configuration.getExtractElement().length()+3);
				}
			}

			if(aggregatorConfiguration.isWriteToFile()){
				writer.writeXmlToFile(maskXml(soapResponse , configuration.getMaskReqInXSL()), RESP_IN);
			}

			soapResponse = matchKeywords(soapResponse);

			// do we need to translate it?
			if (configuration.getInboundXSL() != null) {

				// The following ugliness had to be added to get OTI working ..
				//REVISE: oh please do - we need something better than this.... :(
				if (configuration.getUnescapeElement() != null){
					String startElement="<"+configuration.getUnescapeElement()+">";
					int startIdx = soapResponse.indexOf(startElement);
					if (startIdx > -1){
						startIdx += startElement.length();
					}
					String endElement="</"+configuration.getUnescapeElement()+">";

					int endIdx = soapResponse.lastIndexOf(endElement);

					if (startIdx >-1 && endIdx > -1) {
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

				if (this.xml != null) {
					NodeList req = createRequestNodeList(this.xml);
					params.put("request", req);
				}

				setResultXML(translator.translate(configuration.getInboundXSL(),
						soapResponse, configuration.getInboundParms(), params , false));
			} else {
				this.setResultXML(soapResponse);
			}

			if(aggregatorConfiguration.isWriteToFile()){
				writer.lastWriteXmlToFile(this.resultXML);
		}
	}
		afterRun.apply();
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
			LOGGER.error("failed to createRequestNodeList" , e);
		} catch (SAXException e) {
			LOGGER.error("failed to createRequestNodeList" , e);
		} catch (IOException e) {
			LOGGER.error("failed to createRequestNodeList" , e);
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
		return configuration.getName();
	}
	public long getResponseTime(){
		return this.responseTime;
	}

	public long getTimeoutMillis() {
		return configuration.getTimeoutMillis();
			}

	public SoapClientThreadConfiguration getConfiguration(){
		return configuration;
	}

	public String toString(){
		return "SOAPClientThread:{" +
				"'tranId'='"+tranId+"'" +
				",'name'='"+name+"'" +
				",'configuration'='"+configuration+"'" +
				"}";
	}

}
