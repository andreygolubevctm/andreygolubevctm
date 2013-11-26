package com.disc_au.web.go.tags;

import java.io.IOException;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;

public class SchemaValidationTag extends BaseTag {
	private static final long serialVersionUID = 5179213397254632727L;

	private boolean valid;

	private List<ValidationError> validationErrors= new ArrayList<ValidationError>();

	private String xml;
	private String xsd;

	private String validationErrorsVar;
	private String isValidVar;

	/** The parser. */
	private XmlParser parser = new XmlParser();

	private List<String> validated = new ArrayList<String>();

	private String configRoot;

	public void setValidationErrorsVar(String validationErrors) {
		this.validationErrorsVar = validationErrors;
	}

	public void setIsValidVar(String isValidVar) {
		this.isValidVar = isValidVar;
	}

	public void setXml(String xml) {
		this.xml = xml;
	}

	public void setXsd(String xsd) {
		this.xsd = xsd;
	}

	public List<ValidationError> getValidationErrors() {
		return this.validationErrors;
	}

	/**
	 * Sets the configuration xml.
	 *
	 * @param config the new configuration xml
	 * @throws JspException thrown as a result of an error parsing the cofnig xml
	 */
	public void setConfig(String configXml) throws JspException {
		// Load up the configuration
		try {
			XmlNode config = this.parser.parse(configXml);
			configRoot = (String) config.get("validation-dir/text()");
		} catch (SAXException e) {
			throw new JspException(e);
		}

	}

	@Override
	public int doEndTag() throws JspException {
		try {
			validateSchema();
		} catch (Exception e) {
			throw new JspException(e);
		}
		if(validationErrorsVar != null) {
			this.pageContext.setAttribute(validationErrorsVar, validationErrors, PageContext.PAGE_SCOPE);
		}
		this.pageContext.setAttribute(isValidVar, valid, PageContext.PAGE_SCOPE);
		reset();
		return EVAL_PAGE;
	}

	private void reset() {
		valid = false;
		xml = null;
		xsd = null;
		validationErrorsVar = null;
		validated = new ArrayList<String>();
		validationErrors = new ArrayList<ValidationError>();
		isValidVar = null;
	}

	private class VerboseErrorHandler implements ErrorHandler {

		private XMLStreamReader reader;

		public VerboseErrorHandler(XMLStreamReader reader) {
			this.reader = reader;
		}

		@Override
		public void error(SAXParseException e) throws SAXException {
			warning(e);
			valid = false;
		}

		@Override
		public void fatalError(SAXParseException e) throws SAXException {
			warning(e);
			valid = false;
			throw e;
		}

		@Override
		public void warning(SAXParseException e) throws SAXException {
			if(reader.isStartElement()) {
				createValidationErrorObject(reader.getName().getLocalPart(), e.getMessage());
			}  else if(reader.isEndElement()) {
				createValidationErrorObject(reader.getName().getLocalPart(), e.getMessage());
			}
		}
	}

	private void createValidationErrorObject(String element, String message) {
		ValidationError error = new ValidationError();
		if(!validated.contains(element)) {
			if(message.contains("The content of element '" + element + "' is not complete. One of ")) {
				Pattern p = Pattern.compile(" One of \'\\{(.*?)\\}\' is expected.");
				Matcher m = p.matcher(message);
				String expected = "";
				if (m.find()) {
					expected = m.group(1); // => "3"
				}

				if(!expected.equals(element)) {
					error.setElementName(element + "/" + expected);
				} else {
					error.setElementName(element);
				}
				error.setMessage("ELEMENT REQUIRED");
				validated.add(element);
			} else if(message.contains("is not complete. One of") || message.contains("\'\' is not a valid value for") || message.contains("Value \'\' is not facet-valid")) {
				error.setMessage("ELEMENT REQUIRED");
				error.setElementName(element);
				validated.add(element);
			} else if(message.contains("of element \'" + element + "\' is not valid.") || message.contains("is not facet-valid with respect to enumeration")) {
				if(message.contains("is not facet-valid with respect to enumeration \'")) {
					validated.add(element);
				}
				error.setMessage(ValidationError.INVALID);
				error.setElementName(element);
			} else {
				error.setMessage(message);
				error.setElementName(element);
			}
			validationErrors.add(error);
		}
	}

	public boolean validateSchema() throws SAXException, XMLStreamException, FactoryConfigurationError, IOException {
		this.valid = true;
		if(!xml.contains("<?xml")) {
			xml = "<?xml version='1.0' encoding='UTF-8'?> " + xml;
		}
		xml = xml.replaceAll("[^\\x20-\\x7e\\x0A]", "");
		// Lookup a factory for the W3C XML Schema language
		SchemaFactory factory =
			SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");

		// Compile the schema.
		URL schemaLocation = pageContext.getServletContext().getResource(configRoot + '/' + this.xsd);

		Schema schema = factory.newSchema(schemaLocation);


			// Get a validator from the schema.
			Validator validator = schema.newValidator();

			// Parse the xml
			StreamSource streamSource  = new StreamSource(new StringReader(xml));
			XMLStreamReader reader = XMLInputFactory.newFactory().createXMLStreamReader(streamSource);
			validator.setErrorHandler(new VerboseErrorHandler(reader));
			try {
				validator.validate(new StAXSource(reader));
			} catch (SAXParseException ex) {
				this.valid = false;
		}
		return this.valid;
	}

	protected URL goUpADirectory() throws MalformedURLException {
		URL schemaLocation;
		configRoot = "../" + configRoot;
		schemaLocation = pageContext.getServletContext().getResource(configRoot + '/' + this.xsd);
		return schemaLocation;
	}

}
