package com.ctm.web.simples.router;

import com.ctm.httpclient.jackson.DefaultJacksonMappers;
import com.ctm.interfaces.common.exception.InvalidQuoteException;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.simples.phone.inin.InInIcwsService;
import com.ctm.web.simples.phone.inin.model.PauseResumeResponse;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {DefaultJacksonMappers.class, Jackson2ObjectMapperBuilder.class})
public class PhoneControllerTest {
	@Autowired
	private SerializationMappers jacksonMappers;



	@Test
	public void testHandleException() throws Exception {
		PhoneController phoneController = new PhoneController(mock(SessionDataServiceBean.class), mock(InInIcwsService.class), mock(IPAddressHandler.class));
		InvalidQuoteException exceptionMock = mock(InvalidQuoteException.class);
		when(exceptionMock.getMessage()).thenReturn("Failed!");

		ErrorInfo info = phoneController.handleException(exceptionMock);
		Assert.assertEquals("Failed!", info.getErrors().get("message"));

		// {"trackingKey":null,"transactionId":null,"errors":{"message":"Failed"}}
		String actual = jacksonMappers.getJsonMapper().writeValueAsString(info);
		assertTrue(actual.contains("\"errors\":{\"message\":\"Failed!\"}"));

		// {"success":false,"errors":[{"message":"PauseResume fail"}]}
		actual = jacksonMappers.getJsonMapper().writeValueAsString(PauseResumeResponse.fail("PauseResume fail"));
		assertTrue(actual.contains("\"errors\":{\"message\":\"PauseResume fail\"}"));
	}
}