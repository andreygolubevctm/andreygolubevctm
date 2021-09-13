package com.ctm.web.core.email.services;

import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.formatter.ExactTargetFormatter;
import com.ctm.web.core.email.model.EmailModel;
import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.exacttarget.wsdl.partnerapi.CreateResponse;
import com.exacttarget.wsdl.partnerapi.CreateResult;
import com.exacttarget.wsdl.partnerapi.Soap;
import org.apache.cxf.interceptor.Fault;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Matchers;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.powermock.core.classloader.annotations.PowerMockIgnore;

import java.net.SocketTimeoutException;
import java.util.Collections;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

@PowerMockIgnore({"javax.crypto.*"})
public class ExactTargetEmailSenderTest {

    private ExactTargetEmailSender emailSender;

    @Mock
    private PageSettings pageSettings;

    @Mock
    private Vertical vertical;

    @Mock
    private ExactTargetFormatter exactTargetFormatter;

    @Mock
    private EmailModel emailModel;

    @Mock
    private ServiceConfigurationServiceBean serviceConfigurationServiceBean;

    @Mock
    private ServiceConfiguration serviceConfiguration;

    @Mock
    private ExactTargetEmailModel exactTargetEmailModel;

    @Before
    public void setup() throws Exception {
        initMocks(this);

        when(serviceConfigurationServiceBean.getServiceConfiguration("exactTargetService", vertical)).thenReturn(serviceConfiguration);

        //encrypted using the old method that uses ECB; unecrypted value = testPassword
        //the test value is so because the 'servicePassword' from the database was encrypted using the old encrypt method
        String testEncryptedServicePasswordOld = "389HrYdNEbR-vfqCxqpXoA";

        when(serviceConfiguration.getPropertyValueByKey(eq("serviceUrl"), anyInt(), anyInt(), anyObject())).thenReturn("testurl");
        when(serviceConfiguration.getPropertyValueByKey(eq("serviceUser"), anyInt(), anyInt(), anyObject())).thenReturn("testUser");
        when(serviceConfiguration.getPropertyValueByKey(eq("servicePassword"), anyInt(), anyInt(), anyObject())).thenReturn(testEncryptedServicePasswordOld);

        when(pageSettings.getSetting("sendClientId")).thenReturn("1");
        when(exactTargetFormatter.convertToExactTarget(emailModel)).thenReturn(exactTargetEmailModel);
        emailSender = new ExactTargetEmailSender(pageSettings, 100L, vertical, 0, 0, serviceConfigurationServiceBean);
        emailSender = Mockito.spy(emailSender);
    }

    @Test(expected = SendEmailException.class)
    public void sendWithUncaughtException() throws SendEmailException {
        Soap soap = Mockito.mock(Soap.class);
        doReturn(soap).when(emailSender).initWebserviceClient(100L);
        when(soap.create(Matchers.anyObject())).thenThrow(new Fault(new SocketTimeoutException()));
        try {
            emailSender.sendToExactTarget(exactTargetFormatter, emailModel);
        } catch (SendEmailException e) {
            assertEquals("failed to call exact target web service", e.getMessage());
            assertEquals(Fault.class, e.getCause().getClass());
            throw e;
        }
    }

    @Test
    public void sendSuccessful() throws SendEmailException {
        Soap soap = Mockito.mock(Soap.class);
        CreateResponse response = mock(CreateResponse.class);
        when(response.getOverallStatus()).thenReturn("OK");
        doReturn(soap).when(emailSender).initWebserviceClient(100L);
        when(soap.create(Matchers.anyObject())).thenReturn(response);
        emailSender.sendToExactTarget(exactTargetFormatter, emailModel);
    }

    @Test(expected = SendEmailException.class)
    public void sendFailed() throws SendEmailException {
        Soap soap = Mockito.mock(Soap.class);
        CreateResponse response = mock(CreateResponse.class);
        CreateResult result = mock(CreateResult.class);
        when(response.getOverallStatus()).thenReturn("FAIL");
        when(response.getResults()).thenReturn(Collections.singletonList(result));
        when(result.getErrorCode()).thenReturn(400);
        doReturn(soap).when(emailSender).initWebserviceClient(100L);
        when(soap.create(Matchers.anyObject())).thenReturn(response);
        try {
            emailSender.sendToExactTarget(exactTargetFormatter, emailModel);
        } catch (SendEmailException e) {
            assertEquals("error returned from exact target error code:400", e.getMessage());
            throw e;
        }
    }


}