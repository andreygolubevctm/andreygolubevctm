package com.disc_au.web.go.tags;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.net.URL;

import javax.servlet.jsp.JspException;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLStreamException;

import org.junit.Test;
import org.xml.sax.SAXException;

import com.ctm.web.validation.SchemaValidation;
import com.ctm.web.validation.SchemaValidationError;

public class TestSchemaValidationTag {

	private com.ctm.web.validation.SchemaValidation validationTag;

	@Test
	public void testShouldValidateRoadside() throws IOException, SAXException, XMLStreamException, FactoryConfigurationError, JspException {
		validationTag = new SchemaValidation();
		URL schemaLocation = new URL("file:///C:/Dev/web_ctm/WebContent/WEB-INF/xsd/roadside/roadsidePriceResult.xsd");
		String validRoadSideXML =
				"<?xml version='1.0' encoding='UTF-8' ?>" +
				"<roadside>" +
					"<vehicle>" +
						"<make>AUDI</make><makeDes/><vehicle><odometer>N</odometer><commercial>N</commercial></vehicle><year>2013</year>" +
					"</vehicle>" +
					"<riskAddress>" +
						"<state>QLD</state>" +
					"</riskAddress>" +
					"<transactionId>2029535</transactionId>" +
				"</roadside>";
		boolean valid = validationTag.validateSchema(null, validRoadSideXML, schemaLocation);
		assertTrue(valid);

		String inValidRoadSideXML =
				"<?xml version='1.0' encoding='UTF-8'?>" +
				"<roadside>" +
					"<vehicle>" +
						"<make>AUDI</make>" +
						"<makeDes/>" +
						"<vehicle>" +
							"<odometer>N</odometer>" +
							"<commercial>N</commercial>" +
						"</vehicle>" +
						"<year>2013</year>" +
					"</vehicle>" +
					"<riskAddress>" +
						"<state>APPLE</state>" +
					"</riskAddress>" +
					"<transactionId>2029535</transactionId>" +
				"</roadside>";
		valid = validationTag.validateSchema(null, inValidRoadSideXML, schemaLocation);
		String expectedElement = "state";
		assertInvalid(SchemaValidationError.INVALID, expectedElement);
		assertFalse(valid);

		validationTag = new SchemaValidation();
		inValidRoadSideXML =
				"<roadside>" +
						"<vehicle>" +
							"<makeDes>" +
							"</makeDes>" +
							"<make></make>" +
							"<year></year>" +
						"</vehicle>" +
						"<riskAddress>" +
							"<state>" +
							"</state>" +
						"</riskAddress>" +
						"<clientIpAddress>0:0:0:0:0:0:0:1</clientIpAddress>" +
						"<clientUserAgent>Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36</clientUserAgent>" +
						"<transactionId>2030500</transactionId>" +
				"</roadside>";
		valid = validationTag.validateSchema(null, inValidRoadSideXML, schemaLocation);
		assertInvalid(SchemaValidationError.REQUIRED, "make");
		assertFalse(valid);
	}

	private void assertInvalid(String expectedMessage, String expectedElement) throws IOException, SAXException, XMLStreamException, FactoryConfigurationError {
		String message = validationTag.getValidationErrors().get(0).getMessage();
		assertEquals(expectedMessage,message);
		String element = validationTag.getValidationErrors().get(0).getElementXpath();
		assertEquals(expectedElement,element);
	}

}
