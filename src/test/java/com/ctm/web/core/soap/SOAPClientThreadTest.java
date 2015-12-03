package com.ctm.web.core.soap;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.commonlogging.correlationid.CorrelationIdUtils;
import com.ctm.interfaces.common.types.CorrelationId;
import com.ctm.test.TestUtils;
import com.ctm.web.core.model.soap.settings.SoapAggregatorConfiguration;
import com.ctm.web.core.model.soap.settings.SoapClientThreadConfiguration;
import com.ctm.web.core.utils.function.Action;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.net.HttpURLConnection;
import java.net.URL;

import static org.mockito.Mockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest({SOAPClientThread.class, CorrelationIdUtils.class})
public class SOAPClientThreadTest {

    private SoapAggregatorConfiguration aggregatorConfiguration;
    private String xmlData = "<test></test>";
    private SOAPClientThread soapClientThread;
    private HttpURLConnection connection;
    private String urlString = "http://www.google.com";
    private CorrelationId correlationId = CorrelationId.instanceOf("testcorrelationid");

    @Before
    public void setup() throws Exception {
        URL url = PowerMockito.mock(URL.class);
        PowerMockito.whenNew(URL.class).withArguments(urlString).thenReturn(url);
        connection = TestUtils.createFakeConnection();
        LoggingVariables.setCorrelationId(correlationId);

        when(url.openConnection()).thenReturn(connection);

        String tranId ="10000";
        String configRoot = "test";
        SoapClientThreadConfiguration configuration = new SoapClientThreadConfiguration(8080);
        configuration.setUrl(urlString);
        String threadName = "test";
        aggregatorConfiguration = new SoapAggregatorConfiguration();

        Action beforeRun = ()-> {};
        Action afterRun = ()-> {};
        soapClientThread =  new SOAPClientThread( tranId,  configRoot,  configuration,
                xmlData,  threadName,  aggregatorConfiguration,  beforeRun,  afterRun);

        PowerMockito.spy(CorrelationIdUtils.class);
    }

    @After
    public void tearDown() throws Exception {
        LoggingVariables.clearLoggingContext();
    }

    @Test
    public void shouldNotSendCorrelationId() throws Exception {
        aggregatorConfiguration.setSendCorrelationId(false);
        soapClientThread.processRequest(xmlData);

        PowerMockito.verifyStatic(Mockito.times(0));
        CorrelationIdUtils.setCorrelationIdRequestHeader(connection, correlationId); //Now verifyStatic knows what to verify.
    }

    @Test
    public void shouldSendCorrelationId() throws Exception {
        aggregatorConfiguration.setSendCorrelationId(true);

        soapClientThread.processRequest(xmlData);

        PowerMockito.verifyStatic(Mockito.times(1));
        CorrelationIdUtils.setCorrelationIdRequestHeader(connection, correlationId); //Now verifyStatic knows what to verify.
    }
}