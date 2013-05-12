/**  =========================================   */
/**  SOAPClientThread SOAP Class with WAR compatibility
 *   $Id$
 * (c)2013 Auto & General Holdings Pty Ltd       */

package com.disc_au.soap;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.io.StringWriter;
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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.StringTokenizer;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManagerFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.codec.binary.Base64;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.disc_au.soap.SOAPResolver;
import com.disc_au.web.go.xml.XmlNode;


/**
 * The Class SOAPClientThread with WAR compatibility.
 *
 * @author aransom
 * @version 1.1
 */
public class SOAPClientThread implements Runnable {

	public static final int HTTP_OK = 200;

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

	/** The outbound xsl. */
	protected String outboundXSL;

	/** The inbound xsl. */
	protected String inboundXSL = null;

	/** The timeout millis. */
	protected int timeoutMillis;

	/** The xml. */
	protected String xml;

	/** The trans factory. */
	protected TransformerFactory transFactory;

	/** The result xml. */
	protected String resultXML = "";

	/** The debug path. */
	protected String debugPath = null;

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

		this.transFactory = TransformerFactory.newInstance();

		this.url = (String) config.get("soap-url/text()");
		this.user = (String) config.get("soap-user/text()");
		this.password = (String) config.get("soap-password/text()");
		this.soapAction = (String) config.get("soap-action/text()");
		this.outboundXSL = this.configRoot + '/'
				+ (String) config.get("outbound-xsl/text()");

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
		System.out.println(this.name + ": " + msg + ": "
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

				if (this.clientCert != null && this.clientCertPass != null) {
					System.out.println("Using Cert: " + this.clientCert);

					try {

						// First, try on the classpath (assume given path has no leading slash)
						InputStream clientCertSourceInput = this.getClass().getClassLoader().getResourceAsStream(this.clientCert);

						// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
						if ( clientCertSourceInput == null ) {
							this.clientCert = "../" + this.clientCert;
							clientCertSourceInput = this.getClass().getClassLoader().getResourceAsStream(this.clientCert);
						}

						System.out.println("Cert Exists: " + ( clientCertSourceInput == null ? "NOOOO" : "Yep" ));

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
						System.out.println("Cert Error: 1 (No Such Algorithm)");
						e.printStackTrace();
					} catch (CertificateException e) {
						System.out.println("Cert Error: 2 (Certificate exception)");
						e.printStackTrace();
					} catch (UnrecoverableKeyException e) {
						System.out.println("Cert Error: 3 (Unrecoverable Key)");
						e.printStackTrace();
					} catch (KeyStoreException e) {
						System.out.println("Cert Error: 4 (Key Store exception)");
						e.printStackTrace();
					} catch (KeyManagementException e) {
						System.out.println("Cert Error: 5 (Key Management exception)");
						e.printStackTrace();
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
			connection.setRequestProperty("Content-Type",
					"text/xml; charset=\"utf-8\"");

			// Set the soap action (if supplied)
			if (this.soapAction != null) {
				connection.setRequestProperty("SOAPAction", this.soapAction);
			}

			// If a user and password given, encode and set the user/password
			if (this.user != null && !this.user.isEmpty()
					&& this.password != null && !this.password.isEmpty()) {

				String userPassword = this.user + ":" + this.password;
				String encoded = Base64.encodeBase64String(userPassword.getBytes());
				connection.setRequestProperty("Authorization", "Basic "
						+ encoded);
			}

			logTime("Initialise service connection");
			// Send the soap request
			Writer wout = new OutputStreamWriter(connection.getOutputStream());
			wout.write(soapRequest);
			wout.flush();
			logTime("Write to service");
			this.setResponseCode(connection.getResponseCode());

			switch (connection.getResponseCode()){
				case HTTP_OK: {
					// Receive the result
					InputStreamReader rin = new InputStreamReader(connection
							.getInputStream());
					BufferedReader response = new BufferedReader(rin);
					String line;

					while ((line = response.readLine()) != null) {
						returnData.append(line);
					}
					logTime("Receive from service");

					// Clean up the streams and the connection
					rin.close();
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

					SOAPError err = new SOAPError(SOAPError.TYPE_HTTP,
												((HttpURLConnection)connection).getResponseCode(),
												((HttpURLConnection)connection).getResponseMessage(),
												this.serviceName,
												errorData.toString());

					returnData.append(err.getXMLDoc());

				}
			}

			System.err.println("Response Code: " + ((HttpURLConnection)connection).getResponseCode());

			wout.close();
			((HttpURLConnection)connection).disconnect();

		} catch (MalformedURLException e) {
			e.printStackTrace();
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), this.serviceName);
			returnData.append(err.getXMLDoc());

		} catch (IOException e) {
			e.printStackTrace();
			SOAPError err = new SOAPError(SOAPError.TYPE_HTTP, 0, e.getMessage(), this.serviceName);
			returnData.append(err.getXMLDoc());
		}

		this.responseTime = System.currentTimeMillis() - startTime;

		// Return the result
		return returnData.toString();
	}

	/* (non-Javadoc)
	 * @see java.lang.Runnable#run()
	 */

	@SuppressWarnings("unused")
	public void run() {

		this.timer = System.currentTimeMillis();

		writeFile(this.xml, "req_in");

		// Translate the page xml to be suitable for the client
		String soapRequest = translate(this.outboundXSL, this.xml, this.outboundParms);

		writeFile(soapRequest, "req_out");

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



			writeFile(soapResponse, "resp_in");

			// do we need to translate it?
			if (this.inboundXSL != null) {

				System.out.println(tranId + ":" + this.name + ":"
						+ soapResponse);

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
						String before = soapResponse.substring(0,startIdx);
						String after = soapResponse.substring(endIdx);
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


				// First, try on the classpath (assume given path has no leading slash)
//System.out.println("TESTING FOR XSL SOURCE INPUT ON CLASSPATH: " + this.inboundXSL);
				InputStream xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(this.inboundXSL);

				// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
				if ( xsltSourceInput == null ) {
					this.inboundXSL = "../" + this.inboundXSL;
//System.out.println("TESTING FOR XSL SOURCE INPUT ON HIERARCHY: " + this.inboundXSL);
					xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(this.inboundXSL);
				}

				Source inboundXSLSource = new StreamSource(xsltSourceInput);
//System.out.println("TESTING FOR SYSTEM ID ON CLASSPATH: " + this.getClass().getClassLoader().getResource(this.configRoot).toString());
				inboundXSLSource.setSystemId(this.getClass().getClassLoader().getResource(this.configRoot).toString());
				this.setResultXML(translate(inboundXSLSource,
						soapResponse, this.inboundParms,this.xml));
				logTime("Translate inbound XSL");
			} else {
				this.setResultXML(soapResponse);
			}
			writeFile(this.resultXML, "resp_out");
		}
	}

	/**
	 * Sets the debug path.
	 *
	 * @param debugPath the new debug path
	 */
	public void setDebugPath(String debugPath) {
		this.debugPath = debugPath;
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


	/**
	 * Translate.
	 *
	 * @param xsl the xsl
	 * @param xml the xml
	 * @param parms the parms to pass to the xsl template
	 * @return the string
	 */
	@SuppressWarnings("unused")
	private String translate(File xsl, String xml, String parms) {
		Source xsltSource = new StreamSource(xsl);
		return  translate(xsltSource, xml, parms, null);
	}

	/**
	 * Translate.
	 *
	 * @param xsl the xsl
	 * @param xml the xml
	 * @param parms the parms to pass to the xsl template
	 * @param requestXml the request xml
	 * @return the string
	 */
	@SuppressWarnings("unused")
	private String translate(File xsl, String xml, String parms, String requestXml) {
		Source xsltSource = new StreamSource(xsl);
		return  translate(xsltSource, xml, parms, requestXml);
	}

	/**
	 * Translate.
	 *
	 * @param xslFile path to the xsl file
	 * @param xml the xml
	 * @param parms the parms to pass to the xsl template
	 * @return the string
	 */
	private String translate(String xslFile, String xml, String parms) {
		return  translate(xslFile, xml, parms, null);
	}

	/**
	 * Translate.
	 *
	 * @param xslFile path to the xsl file
	 * @param xml the xml
	 * @param parms the parms to pass to the xsl template
	 * @param requestXml the request xml
	 * @return the string
	 */
	private String translate(String xslFile, String xml, String parms, String requestXml) {
		// First, try on the classpath (assume given path has no leading slash)
//System.out.println("TESTING FOR XSL SOURCE INPUT ON CLASSPATH: " + xslFile);
		InputStream xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(xslFile);

		// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
		if ( xsltSourceInput == null ) {
			this.configRoot = "../" + this.configRoot;
			xslFile = "../" + xslFile;
//System.out.println("TESTING FOR XSL SOURCE INPUT ON HIERARCHY: " + xslFile);
			xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(xslFile);
		}

		Source xsltSource = new StreamSource(xsltSourceInput);
//System.out.println("TESTING FOR SYSTEM ID ON CLASSPATH: " + xslFile.replaceFirst("^(.+/)[^/]+$", "$1"));
		URL systemId = this.getClass().getClassLoader().getResource(xslFile.replaceFirst("^(.+/)[^/]+$", "$1"));

		if ( systemId != null ) {
			xsltSource.setSystemId(systemId.toString());
		} else {
			System.out.println("WARNING: No SystemID for given XSL " + xslFile);
		}

		return  translate(xsltSource, xml, parms, requestXml);
	}

	/**
	 * Translate.
	 *
	 * @param xsltSource the xslt source
	 * @param xml the xml
	 * @param parms the parms to pass to the xsl template
	 * @param requestXml the request xml
	 * @return the string
	 */
	private String translate(Source xsltSource, String xml, String parms, String requestXml) {
		try {
			// Make the transformer for out-bound data.
			this.transFactory.setURIResolver(new SOAPResolver());
			Transformer trans = this.transFactory.newTransformer(xsltSource);

			// Fail if XSL load was unsuccessful
			if ( trans == null ) {
				return "";
			}

			// If paramaters passed iterate through them
			// The voodoo following splits the string from parm1=A&parm2=B&parm3=C into
			// the 3 parms
			if (parms !=null ){
				StringTokenizer st = new StringTokenizer(parms, ",");
				while (st.hasMoreElements()){
					StringTokenizer st1 = new StringTokenizer(st.nextToken(), "=");
					String name = st1.nextToken();
					if (st1.hasMoreTokens()){
						trans.setParameter(name, st1.nextToken());
					}

				}
			}

			// Do we have a request NodeList that should be passed to the template
			if (requestXml!=null) {
				NodeList req = createRequestNodeList(requestXml);
				if (req != null){
					trans.setParameter("request", req);
				}
			}

			// Add today's date
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			trans.setParameter("today",sdf.format(new Date()));

			// Add the transaction Id
			if (this.tranId!=null){
				trans.setParameter("transactionId",this.tranId);
			}
			// Create a stream source from the data passed
			Source xmlSource = new StreamSource(new StringReader(xml));

			// Create a string writer to hold the result of transforming
			// the XML using the out-bound XSL
			Writer soapRequest = new StringWriter();
			trans.transform(xmlSource, new StreamResult(soapRequest));

			return soapRequest.toString();
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		}
		return "";
	}

	/**
	 * Write file.
	 *
	 * @param data the data
	 * @param fileType the file type
	 */
	private void writeFile(String data, String fileType) {
		if (this.debugPath != null) {
			SimpleDateFormat sdf  = new SimpleDateFormat("yyyyMMdd-HH");
			String debugDateFolder = sdf.format(new Date());

			// First, try on the classpath (assume given path has no leading slash)
//System.out.println("TESTING FOR DEBUG PATH ROOT ON CLASSPATH: " + debugPath);
			URL debugPathURL = this.getClass().getClassLoader().getResource(debugPath);

			// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
			if ( debugPathURL == null ) {
				debugPath = "../" + debugPath;
//System.out.println("TESTING FOR DEBUG PATH ROOT ON HIERARCHY: " + debugPath);
				debugPathURL = this.getClass().getClassLoader().getResource(debugPath);
			}

			String debugFolder = (debugPathURL.toString() + debugDateFolder).replaceFirst("^file:", "");
//System.out.println("GOT DEBUG FOLDER: " + debugFolder);

			File dbf = new File(debugFolder);
			if (!dbf.exists() || !dbf.isDirectory()) {
				dbf.mkdir();
			}

			String filename = debugFolder + "/" + this.name.replace(' ', '_')
					+ "_" + fileType + "_"
					+ String.valueOf(System.currentTimeMillis()) + ".xml";
			FileWriter w;

			try {
//System.out.println("ATTEMPTING TO WRITE DEBUG FILE: " + filename);
				w = new FileWriter(filename);
				w.write(data);
				w.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
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
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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

	@SuppressWarnings("unused")
	private SSLSocketFactory getSSLSocketFactory(String certStore, String pass){
		try {
			certStore = "/aggregator/certs/truststore.ts";
			pass="aggregator";

			KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());

			// First, try on the classpath (assume given path has no leading slash)
			InputStream certStoreSourceInput = this.getClass().getClassLoader().getResourceAsStream(certStore);

			// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
			if ( certStoreSourceInput == null ) {
				certStore = "../" + certStore;
				certStoreSourceInput = this.getClass().getClassLoader().getResourceAsStream(certStore);
			}

			System.out.println("Cert Store found? " + ( certStoreSourceInput == null ? "NOOOO" : "Yep" ));
			keyStore.load(certStoreSourceInput, pass.toCharArray());

			TrustManagerFactory tmf =
			TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
			tmf.init(keyStore);
			SSLContext ctx = SSLContext.getInstance("TLS");

			ctx.init(null, tmf.getTrustManagers(), null);
			return ctx.getSocketFactory();
		} catch (KeyManagementException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (KeyStoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (CertificateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	/**
	private SSLSocketFactory getSSLSocketFactory(){
		TrustManager[] trustAllCerts = new TrustManager[] {
				new X509TrustManager() {
					public X509Certificate[] getAcceptedIssuers() {
						return null;
					}

					public void checkClientTrusted(X509Certificate[] certs, String authType) {
						System.out.println("authType is " + authType);
						System.out.println("cert issuers");
						for (int i = 0; i < certs.length; i++) {
							System.out.println("\t" + certs[i].getIssuerX500Principal().getName());
							System.out.println("\t" + certs[i].getIssuerDN().getName());
						}
					}

					public void checkServerTrusted(X509Certificate[] certs, String authType) {
						System.out.println("authType is " + authType);
						System.out.println("cert issuers");
						for (int i = 0; i < certs.length; i++) {
							System.out.println("\t" + certs[i].getIssuerX500Principal().getName());
							System.out.println("\t" + certs[i].getIssuerDN().getName());
						}
					}
				}
		};
		try {
			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new java.security.SecureRandom());
			return sc.getSocketFactory();
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
		return null;
	}
	**/
}
