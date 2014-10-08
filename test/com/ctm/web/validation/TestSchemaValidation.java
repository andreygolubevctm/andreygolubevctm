package com.ctm.web.validation;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.net.URL;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLStreamException;

import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.xml.sax.SAXException;

public class TestSchemaValidation {

	private SchemaValidation validationTag;

	@SuppressWarnings("unchecked")
	@Test
	public void testShouldValidateRoadside() throws IOException, SAXException, XMLStreamException, FactoryConfigurationError, JspException {
		validationTag = new SchemaValidation();
		String xsd = "/WebContent/WEB-INF/xsd/roadside/roadsidePriceResult.xsd";

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
		PageContext pageContext = mock(PageContext.class);
		ServletContext value = mock(ServletContext.class);

		when(pageContext.getServletContext()).thenReturn(value);
		URL url = new URL("file:///C:/Dev/web_ctm" + xsd);
		when(value.getResource(xsd)).thenReturn(url);


		validationTag.setValidationErrorsVar("test1");
		boolean valid = validationTag.validateSchema(pageContext, validRoadSideXML, xsd);
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

		ArgumentCaptor<Object> peopleCaptor = ArgumentCaptor.forClass(Object.class);

		validationTag.setValidationErrorsVar("test2");
		valid = validationTag.validateSchema(pageContext, inValidRoadSideXML, xsd);
		verify(pageContext, times(2)).setAttribute(anyString(), peopleCaptor.capture(), anyInt());
		List<Object> validationErrors = peopleCaptor.getAllValues();
		assertInvalid(SchemaValidationError.INVALID, "state", valid, (List<SchemaValidationError>)validationErrors.get(1));
	}

	@SuppressWarnings("unchecked")
	@Test
	public void testShouldValidateRoadsideMissingMake() throws IOException, SAXException, XMLStreamException, FactoryConfigurationError, JspException {
		validationTag = new SchemaValidation();
		String xsd = "/WebContent/WEB-INF/xsd/roadside/roadsidePriceResult.xsd";

		PageContext pageContext = mock(PageContext.class);
		ServletContext value = mock(ServletContext.class);

		when(pageContext.getServletContext()).thenReturn(value);
		URL url = new URL("file:///C:/Dev/web_ctm" + xsd);
		when(value.getResource(xsd)).thenReturn(url);
		validationTag.setValidationErrorsVar("test1");

		validationTag = new SchemaValidation();
		String inValidRoadSideXML = "<roadside>" +
				"<vehicle>" +
					"<makeDes>foo</makeDes>" +
					"<year>2007</year>" +
				"</vehicle>" +
				"<riskAddress>" +
					"<state>QLD</state>" +
				"</riskAddress>" +
				"<clientIpAddress>0:0:0:0:0:0:0:1</clientIpAddress>" +
				"<clientUserAgent>Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.69 Safari/537.36</clientUserAgent>" +
				"<transactionId>2030500</transactionId>" +
		"</roadside>";
		validationTag.setValidationErrorsVar("test3");
		Boolean valid = validationTag.validateSchema(pageContext, inValidRoadSideXML, xsd);
		ArgumentCaptor<Object> peopleCaptor = ArgumentCaptor.forClass(Object.class);
		verify(pageContext, times(1)).setAttribute(anyString(), peopleCaptor.capture(), anyInt());
		List<Object> validationErrors = peopleCaptor.getAllValues();
		assertInvalid(SchemaValidationError.REQUIRED, valid, (List<SchemaValidationError>)validationErrors.get(0));
	}

	private void assertInvalid(String expectedMessage, String expectedElement, boolean valid, List<SchemaValidationError> validationErrors) throws IOException, SAXException, XMLStreamException, FactoryConfigurationError, JspException {
		assertTrue(validationErrors.size() > 0);
		String message = validationErrors.get(0).getMessage();
		assertEquals(expectedMessage,message);
		String element = validationErrors.get(0).getElementXpath();
		assertEquals(expectedElement,element);
		assertFalse(valid);
	}

	private void assertInvalid(String expectedMessage, boolean valid, List<SchemaValidationError> validationErrors) throws IOException, SAXException, XMLStreamException, FactoryConfigurationError, JspException {
		assertTrue(validationErrors.size() > 0);
		String message = validationErrors.get(0).getMessage();
		assertEquals(expectedMessage,message);
		assertFalse(valid);
	}

}
