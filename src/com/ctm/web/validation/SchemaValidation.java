package com.ctm.web.validation;

import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class SchemaValidation {

	private boolean valid;

	private List<SchemaValidationError> validationErrors= new ArrayList<SchemaValidationError>();

	private String validationErrorsVar;

	private List<String> validated = new ArrayList<String>();


	private String prefixXpath = "";

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
				// Lookup a factory for the W3C XML Schema language
				SchemaFactory factory =
					SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");

				// Compile the schema.

				Schema schema = factory.newSchema(schemaLocation);


					// Get a validator from the schema.
					Validator validator = schema.newValidator();

					// Parse the xml
					StreamSource streamSource  = new StreamSource(new StringReader(xml));
					XMLStreamReader reader = XMLInputFactory.newInstance().createXMLStreamReader(streamSource);
					validator.setErrorHandler(new VerboseErrorHandler(reader));
					try {
						validator.validate(new StAXSource(reader));
					} catch (SAXParseException ex) {
						this.valid = false;
					}
			} catch (Exception e) {
				throw new JspException(e);
			}
			if(validationErrorsVar != null) {
				pageContext.setAttribute(validationErrorsVar, validationErrors, PageContext.PAGE_SCOPE);
			}
		return valid;
	}

	private void reset() {
		validationErrorsVar = null;
		validated = new ArrayList<String>();
		validationErrors = new ArrayList<SchemaValidationError>();
	}

	private class VerboseErrorHandler implements ErrorHandler {

		private XMLStreamReader reader;

		public VerboseErrorHandler(XMLStreamReader reader) {
			this.reader = reader;
		}

		@Override
		public void error(SAXParseException e) throws SAXException {
			warning(e);
		}

		@Override
		public void fatalError(SAXParseException e) throws SAXException {
			warning(e);
			valid = false;
			throw e;
		}

		@Override
		public void warning(SAXParseException e) throws SAXException {
			//check there is an error to validate
			if(reader.isStartElement() || reader.isEndElement()) {
				createValidationErrorObject(reader.getName().getLocalPart(), e.getMessage());
			}
		}
	}

	private void createValidationErrorObject(String element, String message) {
		if(!validated.contains(element)) {
			boolean notCompleteErrorMultiple =  message.contains("The content of element '"+ element + "' is not complete. One of '{");
			boolean unspecifiedField = message.contains("Invalid content was found starting with element '" + element + "'. One of ")
					||  message.contains("Invalid content was found starting with element '" + element + "'. No child element is expected at this point.");

			SchemaValidationError error = new SchemaValidationError();
			if(unspecifiedField) {
				System.out.println("unspecified Field : " + element);
				//This is most likely intentional carry on
			} else if(notCompleteErrorMultiple) {
				error.setMessage("ELEMENT REQUIRED");
				Pattern p = Pattern.compile(" One of \'\\{(.*?)\\}\' is expected.");
				Matcher m = p.matcher(message);
				String expected = "";
				if (m.find()) {
					expected = m.group(1);
				}

				// multiple missing fields
				if(!expected.equals(element)) {
					error.setElements(expected);
					error.setElementXpath(prefixXpath + element);
				} else {
					error.setElementXpath(prefixXpath + element);
				}
				validated.add(element);
				valid = false;
				validationErrors.add(error);
			} else if(message.contains("is not complete. One of") || message.contains("\'\' is not a valid value for") || message.contains("Value \'\' is not facet-valid")) {
				error.setMessage("ELEMENT REQUIRED");
				error.setElementXpath(prefixXpath  + element);
				validated.add(element);
				valid = false;
				validationErrors.add(error);
			} else if(message.contains("of element \'" + element + "\' is not valid.") || message.contains("is not facet-valid")) {
				validated.add(element);
				error.setMessage(SchemaValidationError.INVALID);
				error.setElementXpath(prefixXpath  + element);
				valid = false;
				validationErrors.add(error);
			} else {
				error.setMessage(message);
				error.setElementXpath(prefixXpath  + element);
				valid = false;
				validationErrors.add(error);
			}
		}
	}


	protected URL goUpADirectory(PageContext pageContext, String xsdLocation) throws MalformedURLException {
		URL schemaLocation;
		xsdLocation = "../" + xsdLocation;
		schemaLocation = pageContext.getServletContext().getResource(xsdLocation);
		return schemaLocation;
	}

}
