/**  =========================================   */
/**  <go:soapaggregator> Tag Class with WAR compatibility
 *   $Id$
 * (c)2013 Auto & General Holdings Pty Ltd       */

package com.ctm.web.core.soap;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.interfaces.common.types.BrandCode;
import com.ctm.interfaces.common.types.CorrelationId;
import com.ctm.interfaces.common.types.TransactionId;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.soap.settings.SoapAggregatorConfiguration;
import com.ctm.web.core.model.soap.settings.SoapClientThreadConfiguration;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.validation.SchemaValidation;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.core.web.go.xml.XmlParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.services.EnvironmentService.Environment.*;
import static java.lang.Long.parseLong;

/**
 * The Class SOAPAggregatorTag with WAR compatibility.
 *
 * @author aransom
 * @version 1.1
 */
@SuppressWarnings("serial")
public class SOAPAggregatorTag extends TagSupport {

	private static final Logger LOGGER = LoggerFactory.getLogger(SOAPAggregatorTag.class.getName());

	private SoapAggregatorConfiguration configuration;
	private String configDbKey;
	private String verticalCode;
	private String manuallySetProviderIds = "";
	private String xml;
	/** The variable that will hold the result */
	private String var;
	private String transactionId;
	private String debugVar;
	private SchemaValidation schemaValidation = new SchemaValidation();
	private String isValidVar;
	private String authToken = null;

	private boolean continueOnValidationError;
	private Brand brand;
	private Optional<CorrelationId> correlationIdMaybe = Optional.empty();
	private boolean sendCorrelationId;

	@SuppressWarnings("unused")
	// used in go.tld
	public void setContinueOnValidationError(boolean continueOnValidationError) {
		this.continueOnValidationError = continueOnValidationError;
	}
	@SuppressWarnings("unused")
	// used in go.tld
	public void setSendCorrelationId(boolean sendCorrelationId) {
		this.sendCorrelationId = sendCorrelationId;
	}

	@SuppressWarnings("unused")
	// used in go.tld
	public void setValidationErrorsVar(String validationErrorsVar) {
		schemaValidation.setValidationErrorsVar(validationErrorsVar);
	}

	public void setIsValidVar(String isValidVar) {
		this.isValidVar = isValidVar;
	}

	public void setAuthToken(String authToken){
		this.authToken = authToken;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.TagSupport#doStartTag()
	 */
	@Override
	public int doEndTag() throws JspException {
		String debugXml = null;
		String resultXml = null;
		try {
			correlationIdMaybe = LoggingVariables.getCorrelationId();
			configuration.setSendCorrelationId(sendCorrelationId);
			XmlParser parser = new XmlParser();

			setUpConfiguration();

		/* validate the xml if a xsd has been specified in the config */
			boolean valid = true;

			try {
			valid = schemaValidation.validateSchema(this.pageContext , this.xml, configuration.getValidationFile());
		} catch (MalformedURLException e1) {
			LOGGER.error("failed to validate xml", e1);
		}

			if(isValidVar != null && !isValidVar.isEmpty()) {
			pageContext.setAttribute(isValidVar, valid, PageContext.PAGE_SCOPE);
		}
			if(valid || continueOnValidationError) {

			try {
			// Create the client threads and launch each one
			HashMap<Thread, SOAPClientThread> threads = new HashMap<>();
			for (SoapClientThreadConfiguration serviceItemConfig : configuration.getServices()) {

					// Replace ctm with real context path (for feature branches)
					if (!"ctm/".equals(EnvironmentService.getContextPath())
								&& (EnvironmentService.getEnvironment() == LOCALHOST
								|| EnvironmentService.getEnvironment() == NXI
								|| EnvironmentService.getEnvironment() == NXS)
								&& serviceItemConfig.getUrl().contains("/ctm/")) {
							serviceItemConfig.setUrl(serviceItemConfig.getUrl().replaceFirst("(https?\\://[^/]+)/ctm/", "$1/" + EnvironmentService.getContextPath()));
							LOGGER.debug("Modified service URL. {} ", kv("serviceItemConfig",  serviceItemConfig));
						}

					// Give each one a meaningful name
					String threadName = this.transactionId + " " + serviceItemConfig.getName();

					SOAPClientThread client;

					if (serviceItemConfig.getType() != null && serviceItemConfig.getType().equals("url-encoded")) {
					client = new HtmlFormClientThread(transactionId,
								configuration.getRootPath(), serviceItemConfig, xml, threadName, configuration, this::setupThreadVariable, this::clearThreadVariables);
				} else {
						client = new SOAPClientThread(transactionId,
								configuration.getRootPath(), serviceItemConfig, xml, threadName, configuration, this::setupThreadVariable, this::clearThreadVariables);
					}

				// Add the thread to the hash map and start it off
				Thread thread = new Thread(client, threadName);
				threads.put(thread, client);
				thread.start();
			}

			// Join each thread for their given timeout

			for (Thread thread : threads.keySet()) {
				long timeout = threads.get(thread).getTimeoutMillis();
				try {


					//Otherwise the aggregator times out before all the clients have had a chance too.
					timeout+= 2000; // ensure the main thread lasts slightly longer than the total of all service calls.

					thread.join(timeout);

				} catch (InterruptedException e) {
						LOGGER.error("Exception joining threads. {}", kv("timeout", timeout), e);
				}
			}

			// Get the merge root node
				XmlNode resultNode = new XmlNode(configuration.getMergeRoot());

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
						LOGGER.error("Failed to parse correctly. {} ", kv("client", client), e);
					}
				}
				// Check if the request timed out
				else if (client.getResponseTime() >= client.getTimeoutMillis()) {
					thisResult = new SOAPError(SOAPError.TYPE_TIMEOUT,
												0,
												"Client failed to return in time",
												client.getServiceName());
					LOGGER.error("Failed to return in time. {}", kv("client",client));
				}
				// Unknown problem
				else {
					thisResult = new SOAPError(SOAPError.TYPE_NO_BODY,
							0,
							"Response has no body",
							client.getServiceName());
					LOGGER.error("Response has no body. {}", kv("client", client));
				}

				thisResult.setAttribute("responseTime", String.valueOf(client.getResponseTime()));
				resultNode.addChild(thisResult);
			}

			// Write to the debug var (if passed)
			if (this.debugVar != null) {
				debugXml= resultNode.getXML(true);
				this.pageContext.setAttribute(debugVar, debugXml,
						PageContext.PAGE_SCOPE);
			}

			// If we have results, run them through the merge xsl
					if (configuration.getMergeXsl() != null && !configuration.getMergeXsl().isEmpty()) {
						resultNode = processMergeXSL(resultNode, parser);
			}

			// If result var was passed - put the resulting xml in the pagecontext's
			// variable
			if (this.var!= null) {
				resultXml= resultNode.getXML(true);
				this.pageContext.setAttribute(var, resultXml,
						PageContext.PAGE_SCOPE);
				// Otherwise - just splat it to the page
			} else {
				pageContext.getOut().write(resultNode.getXML(true));
			}

		} catch (IOException e) {
			LOGGER.error("Failed to execute body.", e);
		}
		}
			return super.doEndTag();
		} finally {
			cleanUp();
		}
	}

	private void clearThreadVariables() {
		LoggingVariables.clearLoggingContext();
	}

	private void setupThreadVariable() {
		correlationIdMaybe.ifPresent(LoggingVariables::setCorrelationId);
		LoggingVariables.setVerticalType(VerticalType.findByCode(verticalCode));
		LoggingVariables.setBrandCode(BrandCode.instanceOf(brand.getCode()));
		LoggingVariables.setTransactionId(TransactionId.instanceOf(parseLong(transactionId)));
	}

	private void setUpConfiguration() {
		if(configuration == null){
			configuration = new SoapAggregatorConfiguration();
		}

		SoapConfiguration.setUpConfigurationFromDatabase(configDbKey, configuration, brand, verticalCode, manuallySetProviderIds, authToken, pageContext.getRequest().getLocalPort());
	}

	private void cleanUp() {
		configuration = null;
		configDbKey = null;
		verticalCode = null;
		manuallySetProviderIds = "";
		xml = null;
		var = null;
		transactionId = null;
		debugVar = null;
		schemaValidation = new SchemaValidation();
		isValidVar = null;
		continueOnValidationError = false;
		brand = null;
		correlationIdMaybe = Optional.empty();
	}

	/**
	 * Log error.
	 *
	 * @param client the client
	 * @param message the message
	 */
	private void logError(SOAPClientThread client, String message) {
		LOGGER.error(client.getName() + " : " + message);
	}

	/**
	 * Log time.
	 *
	 * @param msg the message
	 * @param timer the timer
	 */
	private void logTime(String msg, long timer) {
		LOGGER.info(msg + ": " + (System.currentTimeMillis() - timer)
				+ "ms ");
	}

	/**
	 * Sets the configuration xml.
	 * TODO: remove me when xml configuration has been refactored
	 *
	 * @param configXmlString the new configuration xml
	 * @throws JspException thrown as a result of an error parsing the config xml
	 */
	public void setConfig(String configXmlString) throws JspException {
		try {
			configuration = SoapConfiguration.setUpConfigurationFromXml(configXmlString, new XmlParser(), pageContext.getRequest().getLocalPort());
		} catch (SAXException e) {
			throw new JspException(e);
		}
	}

	public void setConfigDbKey(String configDbKey){
		this.configDbKey = configDbKey;
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
	 *  used in go.tld
	 *
	 * @param xml the new xml
	 */
	@SuppressWarnings("unused")
	public void setXml(String xml) {
		this.xml = xml;
	}

	private XmlNode processMergeXSL(XmlNode resultNode, XmlParser parser){
		try {
			TransformerFactory transFactory = TransformerFactory.newInstance();
			// Make the transformer for out-bound data.
			// First, try on the classpath (assume given path has no leading slash)
			InputStream xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(configuration.getRootPath() + '/' + configuration.getMergeXsl());

			// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
			if ( xsltSourceInput == null ) {
				configuration.setRootPath("../" + configuration.getRootPath());
				xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(configuration.getRootPath() + '/' + configuration.getMergeXsl());
			}

			Source xsltSource = new StreamSource(xsltSourceInput);
			Transformer outboundTrans = transFactory.newTransformer(xsltSource);

			// Create a stream source from the data passed
			Source xmlSource = new StreamSource(new StringReader(resultNode.getXML(true)));

			// Create a string writer to hold the result of transforming
			// the XML using the out-bound XSL
			Writer resultXML = new StringWriter();
			outboundTrans.transform(xmlSource, new StreamResult(resultXML));

			return parser.parse(resultXML.toString());
		} catch (TransformerException | SAXException e) {
			LOGGER.error("Failed to process xml", e);
		}
		return resultNode;
	}

	public void setDebugVar(String debugVar){
		this.debugVar = debugVar;
	}

	public void setStyleCodeId(int styleCodeId) {
		 brand = ApplicationService.getBrandById(styleCodeId);
	}

	public String getVerticalCode() {
		return verticalCode;
	}

	public void setVerticalCode(String verticalCode) {
		this.verticalCode = verticalCode;
	}

	public String getManuallySetProviderIds() {
		return manuallySetProviderIds;
	}

	public void setManuallySetProviderIds(String manuallySetProviderIds) {
		this.manuallySetProviderIds = manuallySetProviderIds;
	}

}
