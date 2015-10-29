package com.ctm.services;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.junit.Before;
import org.junit.Test;

import com.ctm.model.session.SessionData;
import com.ctm.web.core.web.go.Data;

public class WriteQuoteServiceTest {

	private long transactionId = 100000;
	private String transactionIdString = "100000";

	private HttpServletRequest request;

	private SessionData sessionData;
	private Vector<String> paramNames = new Vector<String>();
	@Before
	public void setUp() {
		request = mock(HttpServletRequest.class);
		HttpSession session = mock(HttpSession.class);
		sessionData = mock(SessionData.class);
		when(session.getAttribute("sessionData")).thenReturn(sessionData);
		when(request.getSession()).thenReturn(session);
	}

	@Test
	public void testShouldWriteToDataBucket() throws JSONException {
		String commencementDate = "21/08/2014";

		Data dataBucket = new Data();
		when(sessionData.getSessionDataForTransactionId(transactionIdString)).thenReturn(dataBucket);
		setToRequest("quote_options_commencementDate" , commencementDate);
		when(request.getParameterNames()).thenReturn(paramNames.elements());
		QuoteService service = new QuoteService();


		service.writeLite(request, transactionId, dataBucket );

		//verify written to session data bucket
		assertEquals(dataBucket.get("quote/options/commencementDate") , commencementDate);
	}

	private void setToRequest(String key, String value) {
		when(request.getParameter(key)).thenReturn(value);
		paramNames.add("quote_options_commencementDate");
		String[] values = new String[1] ;
		values[0] = value;
		when(request.getParameterValues("quote_options_commencementDate")).thenReturn(values);
	}


}
