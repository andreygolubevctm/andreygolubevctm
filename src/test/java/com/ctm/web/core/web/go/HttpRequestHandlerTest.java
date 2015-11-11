package com.ctm.web.core.web.go;

import com.ctm.web.core.web.go.xml.HttpRequestHandler;
import com.ctm.web.core.web.go.xml.XmlNode;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class HttpRequestHandlerTest {

	HttpServletRequest req = mock(HttpServletRequest.class);
	Vector<String> valuesVector;

	@Before
	public void setup() {
		valuesVector = new Vector<String>();
		valuesVector.add("foo_A");
		valuesVector.add("foo_B");

		String[] namesA =  new String[1];
		namesA[0] = "A1 ";

		String[] namesB =  new String[1];
		namesB[0] = "B1 ";

		when(req.getParameterNames()).thenReturn(valuesVector.elements());
		when(req.getParameterValues("foo_A")).thenReturn(namesA);
		when(req.getParameterValues("foo_B")).thenReturn(namesB);
	}

	@Test
	public void shouldTrimWhiteSpace() {
		XmlNode result = HttpRequestHandler.updateXmlNode(new XmlNode("data"), req, true, true);
		assertEquals(result.getFirstChild("foo").getFirstChild("A").getText() ,"A1");
		assertEquals(result.getFirstChild("foo").getFirstChild("B").getText() ,"B1");
	}

	@Test
	public void shouldNotTrimWhiteSpace() {
		XmlNode result = HttpRequestHandler.updateXmlNode(new XmlNode("data"), req, false);
		assertEquals(result.getFirstChild("foo").getFirstChild("A").getText() ,"A1 ");
		assertEquals(result.getFirstChild("foo").getFirstChild("B").getText() ,"B1 ");

		when(req.getParameterNames()).thenReturn(valuesVector.elements());

		result = HttpRequestHandler.updateXmlNode(new XmlNode("data"), req, true);
		assertEquals(result.getFirstChild("foo").getFirstChild("A").getText() ,"A1 ");
	}


}
