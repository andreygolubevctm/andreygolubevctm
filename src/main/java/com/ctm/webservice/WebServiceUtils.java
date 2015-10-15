package com.ctm.webservice;

import com.ctm.logging.CxfLoggingInInterceptor;
import com.ctm.logging.CxfLoggingOutInterceptor;
import com.ctm.logging.XMLOutputWriter;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.interceptor.AbstractLoggingInterceptor;
import org.apache.cxf.interceptor.Interceptor;
import org.apache.cxf.message.Message;
import org.apache.cxf.ws.security.wss4j.WSS4JOutInterceptor;
import org.apache.wss4j.dom.WSConstants;
import org.apache.wss4j.dom.handler.WSHandlerConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WebServiceUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(WebServiceUtils.class);

    public static final String HTTP_PROTOCOL = "http";
    public static final String HTTPS_PROTOCOL = "https";
    public static final String HTTP_PROXY_USER = "http.proxyUser";
    public static final String HTTP_PROXY_PASSWORD = "http.proxyPassword";
    public static final String HTTPS_PROXY_USER = "https.proxyUser";
    public static final String HTTPS_PROXY_PASSWORD = "https.proxyPassword";

    public static void setWsSecurity(Endpoint cxfEndpoint, Map<String, Object> ctx, String username, String password) {
        Map<String, Object> outProps = new HashMap<>();

        outProps.put(WSHandlerConstants.ACTION, WSHandlerConstants.USERNAME_TOKEN);
        outProps.put(WSHandlerConstants.USER, username);
        outProps.put(WSHandlerConstants.PASSWORD_TYPE, WSConstants.PW_TEXT);

        ctx.put("password", password);

        Interceptor<SoapMessage> wssOut = new WSS4JOutInterceptor(outProps);
        cxfEndpoint.getOutInterceptors().add(wssOut);
    }

    public static void setLogging(Client client, PageSettings pageSettings, Long transactionId, String serviceName) {

        // Log copy of XML Request/Response in Debug folders
        String path = Vertical.VerticalType.GENERIC.getCode() + "/app-logs-debug";
        if (pageSettings.getVerticalCode() != null) {
            path = pageSettings.getVerticalCode() + "/app-logs-debug";
        }

        String fileName = "_" + serviceName;
        if (transactionId != null) {
            fileName = transactionId + fileName;
        }
        XMLOutputWriter writer = new XMLOutputWriter(fileName, path);

        clearLoggingInterceptor(client.getInInterceptors());
        clearLoggingInterceptor(client.getOutInterceptors());

        client.getEndpoint().getInInterceptors().add(new CxfLoggingInInterceptor(writer, transactionId));
        client.getEndpoint().getOutInterceptors().add(new CxfLoggingOutInterceptor(writer, transactionId));

    }

    private static void clearLoggingInterceptor(List<Interceptor<? extends Message>> interceptorList) {
        // Clear any existing logging interceptors
        ArrayList<Interceptor> removeList = new ArrayList<>();
        for (Interceptor interceptor : interceptorList) {
            if (interceptor instanceof AbstractLoggingInterceptor) {
                LOGGER.info("Removing pre-existing LoggingInterceptor: {}", interceptor.getClass().getName());
                removeList.add(interceptor);
            }
        }
        interceptorList.removeAll(removeList);
    }
}
