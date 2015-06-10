package com.ctm.web.validation;

import org.apache.log4j.Logger;
import org.xml.sax.SAXParseException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

public class SchemaValidation {

	private final SchemaFactory factory;
	private final XMLInputFactory xmlInputFactory;
	Logger logger = Logger.getLogger(SchemaValidation.class.getName());

	private boolean valid;


	private String validationErrorsVar;


	private String prefixXpath = "";
	private List<SchemaValidationError> validationErrors;

	public SchemaValidation(SchemaFactory factory, XMLInputFactory xmlInputFactory) {
		this.factory = factory;
		this.xmlInputFactory = xmlInputFactory;

	}
	public SchemaValidation() {
		// Lookup a factory for the W3C XML Schema language
		this.factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
		this.xmlInputFactory = XMLInputFactory.newInstance();
	}

	public void setPrefixXpath(String prefixXpath) {
		this.prefixXpath = prefixXpath;
	}

	public void setValidationErrorsVar(String validationErrors) {
		this.validationErrorsVar = validationErrors;
	}

	public List<SchemaValidationError> getValidationErrors() {
		return this.validationErrors;
	}

	public boolean validateSchema(PageContext pageContext , String xml, String xsdLocation) throws JspException, MalformedURLException {
		//String xsdLocation = (String) config.get("validation-file/text()");

		if(xsdLocation != null && !xsdLocation.isEmpty()) {
			// Required by Tomcat8: resources start with slash
			if (!xsdLocation.startsWith("/")) xsdLocation = "/" + xsdLocation;
			
		URL schemaLocation = pageContext.getServletContext().getResource(xsdLocation);
			valid = validateSchema(pageContext , xml, schemaLocation);
		}else{
			valid = true;
		}

		reset();
		return valid;
	}

	public boolean validateSchema(PageContext pageContext , String xml, URL schemaLocation) throws JspException {
		this.valid = true;
			try {
				if(!xml.contains("<?xml")) {
					xml = "<?xml version='1.0' encoding='UTF-8'?> " + xml;
				}
				xml = xml.replaceAll("[^\\x20-\\x7e\\x0A]", "");

				// Compile the schema.

				Schema schema = factory.newSchema(schemaLocation);


					// Get a validator from the schema.
					Validator validator = schema.newValidator();

					// Parse the xml
					StreamSource streamSource  = new StreamSource(new StringReader(xml));
					XMLStreamReader reader = xmlInputFactory.createXMLStreamReader(streamSource);
				    VerboseErrorHandler errorHandler = new VerboseErrorHandler(reader, prefixXpath);
					validator.setErrorHandler(errorHandler);
					try {
						validator.validate(new StAXSource(reader));
						this.validationErrors = errorHandler.validationErrors;
						this.valid = errorHandler.valid;
					} catch (SAXParseException ex) {
						this.valid = false;
					}
				if(validationErrorsVar != null) {
					pageContext.setAttribute(validationErrorsVar, errorHandler.validationErrors, PageContext.PAGE_SCOPE);
				}
			} catch (Exception e) {
				throw new JspException(e);
			}
		return valid;
	}

	private void reset() {
		validationErrorsVar = null;
		validationErrors = null;
	}



	protected URL goUpADirectory(PageContext pageContext, String xsdLocation) throws MalformedURLException {
		URL schemaLocation;
		xsdLocation = "../" + xsdLocation;
		schemaLocation = pageContext.getServletContext().getResource(xsdLocation);
		return schemaLocation;
	}

}
