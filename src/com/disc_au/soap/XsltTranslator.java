package com.disc_au.soap;

import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Map.Entry;
import java.util.StringTokenizer;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.log4j.Logger;

public class XsltTranslator {

	Logger logger = Logger.getLogger(XsltTranslator.class.getName());

	/** The trans factory. */
	protected TransformerFactory transFactory;
	private String configRoot;
	private String encoding;

	public XsltTranslator(String configRoot, String encoding) {
		this.transFactory = TransformerFactory.newInstance();
		this.configRoot = configRoot;
		this.encoding = encoding;
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
	public String translate(String xslFile, String xml, String parms, Map<String, Object> params, boolean updateConfigRoot) {
		try {
			Source xsltSource = getXsltSource(xslFile, updateConfigRoot);
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

			if(params != null) {
				for(Entry<String, Object> param: params.entrySet()) {
					trans.setParameter(param.getKey(), param.getValue());
				}
			}

			// Add today's date
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			trans.setParameter("today",sdf.format(new Date()));

			// Create a stream source from the data passed
			Source xmlSource = new StreamSource(new StringReader(xml));

			// Create a string writer to hold the result of transforming
			// the XML using the out-bound XSL
			Writer soapRequest = new StringWriter();
			trans.setOutputProperty(OutputKeys.ENCODING, this.encoding);
			trans.transform(xmlSource, new StreamResult(soapRequest));
			return soapRequest.toString();
		} catch (TransformerConfigurationException e) {
			logger.error("failed to translate" , e);
		} catch (TransformerException e) {
			logger.error("failed to translate" ,e);
		}
		return "";
	}

	protected Source getXsltSource(String xslFile, boolean updateConfigRoot) {

		InputStream xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(xslFile);

		// If that fails, do a folder hierarchy dance to support looking more locally (non-packed-WAR environment)
		if ( xsltSourceInput == null ) {
			if(updateConfigRoot) {
				this.configRoot = "../" + this.configRoot;
			}
			xslFile = "../" + xslFile;
			xsltSourceInput = this.getClass().getClassLoader().getResourceAsStream(xslFile);
		}

		Source xsltSource = new StreamSource(xsltSourceInput);
		URL systemId = this.getClass().getClassLoader().getResource(xslFile.replaceFirst("^(.+/)[^/]+$", "$1"));

		if ( systemId != null ) {
			xsltSource.setSystemId(systemId.toString());
		} else {
			logger.warn("No SystemID for given XSL " + xslFile);
		}
		return xsltSource;
	}
}
