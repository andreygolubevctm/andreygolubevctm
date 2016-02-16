package com.ctm.web.simples.router;

import com.ctm.httpclient.jackson.DefaultJacksonMappers;
import com.ctm.interfaces.common.exception.InvalidQuoteException;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.simples.phone.inin.InInIcwsService;
import com.ctm.web.simples.phone.inin.model.PauseResumeResponse;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {DefaultJacksonMappers.class, Jackson2ObjectMapperBuilder.class})
public class PhoneControllerTest {
	@Autowired
	private SerializationMappers jacksonMappers;

	@Mock
	private InInIcwsService inInIcwsService;
	@Mock
	private SessionDataServiceBean sessionDataServiceBean;
	@Mock
	private ApplicationService applicationService;

    private PhoneController phoneController;
    private InvalidQuoteException exceptionMock;

    @Before
	public void setUp() throws Exception {
		initMocks(this);
         phoneController = new PhoneController(sessionDataServiceBean,
                inInIcwsService,
                applicationService);
        exceptionMock = mock(InvalidQuoteException.class);
        when(exceptionMock.getMessage()).thenReturn("Failed!");
	}

	@Test
	public void testHandleException() throws Exception {

		ErrorInfo info = phoneController.handleException(exceptionMock);
		Assert.assertEquals("Failed!", info.getErrors().get("message"));

		// {"trackingKey":null,"transactionId":null,"errors":{"message":"Failed"}}
		String actual = jacksonMappers.getJsonMapper().writeValueAsString(info);
		assertTrue(actual.contains("\"errors\":{\"message\":\"Failed!\"}"));
	}

    @Test
    public void testHandleExceptionPauseResumeFailed() throws Exception {
        ErrorInfo info = phoneController.handleException(exceptionMock);
        Assert.assertEquals("Failed!", info.getErrors().get("message"));

        // {"success":false,"errors":[{"message":"PauseResume fail"}]}
        String actual = jacksonMappers.getJsonMapper().writeValueAsString(PauseResumeResponse.fail("PauseResume fail"));
        assertTrue(actual.contains("\"errors\":{\"message\":\"PauseResume fail\"}"));
    }
}