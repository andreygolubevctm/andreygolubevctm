/**  =========================================   */
/**  <go:soapaggregator> Tag Class with WAR compatibility
 *   $Id$
 * (c)2013 Auto & General Holdings Pty Ltd       */

package com.disc_au.soap;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;

/**
 * The Class SOAPAggregatorTag with WAR compatibility.
 *
 * @author aransom
 * @version 1.1
 */
@SuppressWarnings("serial")
public class SOAPAggregatorTag extends BodyTagSupport {

	Logger logger = Logger.getLogger(SOAPAggregatorTag.class.getName());

	/** The xml. */
	private String xml;

	/** The variable that will hold the result */
	private String var;

	/** The transaction id. */
	private String transactionId;

	/** The parser. */
	private XmlParser parser = new XmlParser();

	/** The config. */
	private XmlNode config;

	/** The config root. */
	private String configRoot;

	/** The timer. */
	private long timer; // debug timer

	/** The trans factory. */
	private TransformerFactory transFactory;

	private String mergeXSL = "";

	private String debugVar;


	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {
		timer = System.currentTimeMillis();
		String debugPath = (String) this.config.get("debug-dir/text()");
			logger.info("Using debug path " + debugPath);

		// Get the root folder for provider configuration
		configRoot = (String) this.config.get("config-dir/text()");

		try {
			// Create the client threads and launch each one
			HashMap<Thread, SOAPClientThread> threads = new HashMap<Thread, SOAPClientThread>();
			for (XmlNode service : config.getChildNodes("service")) {

				// Give each one a meaningful name
				String threadName = this.transactionId + " "
						+ service.getAttribute("name");

				SOAPClientThread client;

				if (service.getAttribute("type").equals("url-encoded")) {
					client = new HtmlFormClientThread(transactionId,
							configRoot, service, xml, threadName);
				} else {
					client = new SOAPClientThread(transactionId,
							configRoot, service, xml, threadName);
				}
				if (debugPath != null) {
					client.setDebugPath(debugPath);
				}

				// Add the thread to the hash map and start it off
				Thread thread = new Thread(client, threadName);
				threads.put(thread, client);
				thread.start();
			}
			logTime("Launch Client Threads");

				logger.info("Now waiting for clients to return... ");
			// Join each thread for their given timeout

			for (Thread thread : threads.keySet()) {
				try {

					long timeout = threads.get(thread).getTimeoutMillis();

					//Otherwise the aggregator times out before all the clients have had a chance too.
					timeout+= 2000; // ensure the main thread lasts slightly longer than the total of all service calls.

						logger.info("will wait "+timeout+ "ms");
					thread.join(timeout);

				} catch (InterruptedException e) {
						logger.error(e);
				}
			}
			logTime("All client Threads returned");

			// Get the merge root node
			String rootNodeName = (String) config.get("merge-root/text()");
			XmlNode resultNode = new XmlNode(rootNodeName);
			logTime("Make Result Node");

			// Append each of the client results
			for (SOAPClientThread client : threads.values()) {
				String result = client.getResultXML();
				XmlNode thisResult;

				// Check that there is content to parse
				if (result != null && !result.isEmpty()) {
					try {
						thisResult = parser.parse(result);
					} catch (Exception e) {

						thisResult = new SOAPError(SOAPError.TYPE_PARSING,
													0,
													e.getMessage(),
											client.getServiceName(),
											result);
						logError(client, "Failed to parse correctly: " + e.getMessage());
					}
				}
				// Check if the request timed out
				else if (client.getResponseTime() >= client.getTimeoutMillis()) {
					thisResult = new SOAPError(SOAPError.TYPE_TIMEOUT,
												0,
												"Client failed to return in time",
												client.getServiceName());
					logError(client, "Failed to return in time");
				}
				// Unknown problem
				else {
					thisResult = new SOAPError(SOAPError.TYPE_NO_BODY,
							0,
							"Response has no body",
							client.getServiceName());
					logError(client, "Response has no body");
				}

				thisResult.setAttribute("responseTime", String.valueOf(client.getResponseTime()));
				resultNode.addChild(thisResult);
			}

			// Write to the debug var (if passed)
			if (this.debugVar!= null) {
				this.pageContext.setAttribute(debugVar, resultNode.getXML(true),
						PageContext.PAGE_SCOPE);
			}

			logTime("Add results");

			// If we have results, run them through the merge xsl
			this.mergeXSL = (String) config.get("merge-xsl/text()");
			if (this.mergeXSL != null && this.mergeXSL != ""){
				resultNode = processMergeXSL(resultNode);
			}

			// If result var was passed - put the resulting xml in the pagecontext's
			// variable
			if (this.var!= null) {
				this.pageContext.setAttribute(var, resultNode.getXML(true),
						PageContext.PAGE_SCOPE);
				// Otherwise - just splat it to the page
			} else {
				pageContext.getOut().write(resultNode.getXML(true));
			}
			logTime("Return to the page");

		} catch (IOException e) {
			e.printStackTrace();
		}

		return super.doStartTag();
	}

	/**
	 * Log error.
	 *
	 * @param client the client
	 * @param message the message
	 */
	private void logError(SOAPClientThread client, String message) {
		logger.error(client.getName() + " : " + message);
	}

	/**
	 * Log time.
	 *
	 * @param msg the message
	 */
	private void logTime(String msg) {
		logTime(msg, this.timer);
		this.timer = System.currentTimeMillis();
	}

	/**
	 * Log time.
	 *
	 * @param msg the message
	 * @param timer the timer
	 */
	private void logTime(String msg, long timer) {
		logger.info(msg + ": " + (System.currentTimeMillis() - timer)
				+ "ms ");
	}

	/**
	 * Sets the configuration xml.
	 *
	 * @param config the new configuration xml
	 * @throws JspException thrown as a result of an error parsing the cofnig xml
	 */
	public void setConfig(String config) throws JspException {
		// Load up the configuration
		try {
			this.config = this.parser.parse(config);
		} catch (SAXException e) {
			throw new JspException(e);
		}

	}

	/**
	 * Sets the transaction id.
	 *
	 * @param transactionId the new transaction id
	 */
	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	/**
	 * Sets the result variable.
	 *
	 * @param var the variable that will receive the result of the soap request
	 */
	public void setVar(String var) {
		this.var = var;
	}

	/**
	 * Sets the xml.
	 *
	 * @param xml the new xml
	 */
	public void setXml(String xml) {
		this.xml = xml;
	}

	private XmlNode processMergeXSL(XmlNode resultNode){
		try {
			this.transFactory = TransformerFactory.newInstance();
			// Make the transformer for out-bound data.
			// First, try on the classpath (assume given path has no leading slash)
			InputStream xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(configRoot + '/' + this.mergeXSL);

			// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
			if ( xsltSourceInput == null ) {
				configRoot = "../" + configRoot;
				xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(configRoot + '/' + this.mergeXSL);
			}

			Source xsltSource = new StreamSource(xsltSourceInput);
			Transformer outboundTrans = transFactory.newTransformer(xsltSource);

			// Create a stream source from the data passed
			Source xmlSource = new StreamSource(new StringReader(resultNode.getXML(true)));

			// Create a string writer to hold the result of transforming
			// the XML using the out-bound XSL
			Writer resultXML = new StringWriter();
			outboundTrans.transform(xmlSource, new StreamResult(resultXML));

			return this.parser.parse(resultXML.toString());
		} catch (TransformerConfigurationException e) {
			logger.error(e);
		} catch (TransformerException e) {
			logger.error(e);
		} catch (SAXException e) {
			logger.error(e);
		}
		return resultNode;
	}

	public void setDebugVar(String debugVar){
		this.debugVar = debugVar;
	}

}
