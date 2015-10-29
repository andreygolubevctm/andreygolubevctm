package com.ctm.web.validation;

import com.ctm.web.core.web.validation.SchemaValidationError;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.w3c.dom.ls.LSResourceResolver;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import javax.servlet.ServletContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.xml.namespace.QName;
import javax.xml.stream.FactoryConfigurationError;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.stax.StAXSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest(SchemaValidation.class)
public class TestSchemaValidation {

	private SchemaValidation validationTag;
	private PageContext pageContext = mock(PageContext.class);
	private String xsd = "/WebContent/WEB-INF/xsd/roadside/roadsidePriceResult.xsd";
	private Schema schema;
	private XMLStreamReader reader;

	@Before
	public void setup() throws Exception {
		reader = mock(XMLStreamReader.class);
		StAXSource staxReader = mock(StAXSource.class);
		PowerMockito.whenNew(StAXSource.class).withArguments(reader).thenReturn(staxReader);

		SchemaFactory factory = mock(SchemaFactory.class);
		schema = mock(Schema.class);
		URL url = new URL("http://test1");
		when(factory.newSchema(url)).thenReturn(schema);
		XMLInputFactory xmlInputFactory = mock(XMLInputFactory.class);
		when(xmlInputFactory.createXMLStreamReader((Source) anyObject())).thenReturn(reader);
		validationTag = new SchemaValidation(factory, xmlInputFactory);
		ServletContext value = mock(ServletContext.class);
		when(pageContext.getServletContext()).thenReturn(value);
		when(value.getResource(xsd)).thenReturn(url);
	}

	@SuppressWarnings("unchecked")
	@Test
	public void testShouldValidateValidXml() throws MalformedURLException, JspException {
		when(schema.newValidator()).thenReturn(new Validator(){

			public VerboseErrorHandler errorHandler;

			@Override
			public void reset() {
			}

			@Override
			public void validate(Source source, Result result) throws SAXException, IOException {
			}

			@Override
			public void setErrorHandler(ErrorHandler errorHandler) {
				this.errorHandler = (VerboseErrorHandler) errorHandler;
			}

			@Override
			public ErrorHandler getErrorHandler() {
				return null;
			}

			@Override
			public void setResourceResolver(LSResourceResolver resourceResolver) {

			}

			@Override
			public LSResourceResolver getResourceResolver() {
				return null;
			}
		});


		validationTag.setValidationErrorsVar("test1");
		boolean valid = validationTag.validateSchema(pageContext, "", xsd);
		assertTrue(valid);
	}

	@Test
	public void testShouldValidateInvalidXml() throws JspException, IOException, SAXException, XMLStreamException {
		when(schema.newValidator()).thenReturn(new Validator(){

			public VerboseErrorHandler errorHandler;

			@Override
			public void reset() {
			}

			@Override
			public void validate(Source source, Result result) throws SAXException, IOException {
				when(reader.isStartElement()).thenReturn(true);
				QName name = new QName("http://test", "state", "test");
				when(reader.getName()).thenReturn(name);
						//check there is an error to validate
						SAXParseException e = new SAXParseException("of element 'state' is not valid.", "state", "state",
								1, 1);
				errorHandler.warning(e);
			}

			@Override
			public void setErrorHandler(ErrorHandler errorHandler) {
				this.errorHandler = (VerboseErrorHandler) errorHandler;
			}

			@Override
			public ErrorHandler getErrorHandler() {
				return null;
			}

			@Override
			public void setResourceResolver(LSResourceResolver resourceResolver) {

			}

			@Override
			public LSResourceResolver getResourceResolver() {
				return null;
			}
		});
		boolean valid;

		ArgumentCaptor<Object> attributeCaptor = ArgumentCaptor.forClass(Object.class);

		validationTag.setValidationErrorsVar("test2");
		valid = validationTag.validateSchema(pageContext, "", xsd);
		verify(pageContext, times(1)).setAttribute(eq("test2"), attributeCaptor.capture(), anyInt());
		List<SchemaValidationError> validationErrors = (List<SchemaValidationError>) attributeCaptor.getValue();
		assertInvalid(SchemaValidationError.INVALID, "state", valid, validationErrors);
	}


	private void assertInvalid(String expectedMessage, String expectedElement, boolean valid, List<SchemaValidationError> validationErrors) throws IOException, SAXException, XMLStreamException, FactoryConfigurationError, JspException {
		assertTrue(validationErrors.size() > 0);
		String message = validationErrors.get(0).getMessage();
		assertEquals(expectedMessage,message);
		String element = validationErrors.get(0).getElementXpath();
		assertEquals(expectedElement,element);
		assertFalse(valid);
	}

}
