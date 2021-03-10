package com.ctm.test.webservice;

import  com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.webservice.WebServiceUtils;
import com.exacttarget.wsdl.partnerapi.PartnerAPI;
import com.exacttarget.wsdl.partnerapi.Soap;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.frontend.ClientProxy;
import org.apache.cxf.interceptor.AbstractLoggingInterceptor;
import org.apache.cxf.interceptor.Interceptor;
import org.apache.cxf.ws.security.wss4j.WSS4JOutInterceptor;
import org.apache.wss4j.dom.WSConstants;
import org.apache.wss4j.dom.handler.WSHandlerConstants;
import org.junit.Test;

import javax.xml.ws.BindingProvider;
import javax.xml.ws.Service;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

/**
 * Created by dkocovski on 16/10/2015.
 */
public class WebServiceUtilsTest {

    @Test
    public void testSetWsSecurity() throws Exception {
        String user = "user";
        String password = "password";

        Service service = new PartnerAPI();
        Soap port = service.getPort(Soap.class);
        BindingProvider bp = (BindingProvider) port;
        bp.getRequestContext().put(BindingProvider.ENDPOINT_ADDRESS_PROPERTY, "http://some.url");
        Client client = ClientProxy.getClient(port);
        Endpoint cxfEndpoint = client.getEndpoint();

        Map<String, Object> ctx = ((BindingProvider) port).getRequestContext();
        WebServiceUtils.setWsSecurity(cxfEndpoint, ctx, user, password);

        WSS4JOutInterceptor wss4JOutInterceptor = null;
        for (Interceptor interceptor : cxfEndpoint.getOutInterceptors()) {
            if (interceptor instanceof WSS4JOutInterceptor) {
                wss4JOutInterceptor = (WSS4JOutInterceptor) interceptor;
                break;
            }
        }
        assertNotNull(wss4JOutInterceptor);

        assertEquals(wss4JOutInterceptor.getOption(WSHandlerConstants.ACTION), WSHandlerConstants.USERNAME_TOKEN);
        assertEquals(wss4JOutInterceptor.getOption(WSHandlerConstants.USER), user);
        assertEquals(wss4JOutInterceptor.getOption(WSHandlerConstants.PASSWORD_TYPE), WSConstants.PW_TEXT);
        assertEquals(ctx.get("password"), password);


    }

    @Test
    public void testSetLogging() throws Exception {
        Service service = new PartnerAPI();
        Soap port = service.getPort(Soap.class);
        BindingProvider bp = (BindingProvider) port;
        bp.getRequestContext().put(BindingProvider.ENDPOINT_ADDRESS_PROPERTY, "http://some.url");
        Client client = ClientProxy.getClient(port);

        PageSettings pageSettings = new PageSettings();
        Vertical vertical = new Vertical();
        vertical.setType(Vertical.VerticalType.HEALTH);
        pageSettings.setVertical(vertical);
        WebServiceUtils.setLogging(client, pageSettings, 1L, "SERVICE_NAME");
        int inLogInterceptors = 0;
        for (Interceptor interceptor : client.getEndpoint().getInInterceptors()) {
            if (interceptor instanceof AbstractLoggingInterceptor) {
                ++inLogInterceptors;
            }
        }
        assertEquals(inLogInterceptors, 1);

        int outLogInterceptors = 0;
        for (Interceptor interceptor : client.getEndpoint().getOutInterceptors()) {
            if (interceptor instanceof AbstractLoggingInterceptor) {
                ++outLogInterceptors;
            }
        }
        assertEquals(outLogInterceptors, 1);
    }
}