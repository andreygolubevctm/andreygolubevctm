package com.ctm.web.core.webservice;

import com.ctm.web.core.logging.CxfLoggingInInterceptor;
import com.ctm.web.core.logging.CxfLoggingOutInterceptor;
import com.ctm.web.core.logging.XMLOutputWriter;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.interceptor.AbstractLoggingInterceptor;
import org.apache.cxf.interceptor.Interceptor;
import org.apache.cxf.message.Message;
import org.apache.cxf.transport.http.HTTPConduit;
import org.apache.cxf.transports.http.configuration.HTTPClientPolicy;
import org.apache.cxf.ws.security.wss4j.WSS4JOutInterceptor;
import org.apache.wss4j.dom.WSConstants;
import org.apache.wss4j.dom.handler.WSHandlerConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WebServiceUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(WebServiceUtils.class);

    public static final String HTTP_PROTOCOL = "http";
    public static final String HTTPS_PROTOCOL = "https";
    public static final String HTTPS_PROXY_HOST = "https.proxyHost";
    public static final String HTTPS_PROXY_PORT = "https.proxyPort";
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

        client.getEndpoint().getInInterceptors().add(new CxfLoggingInInterceptor(writer));
        client.getEndpoint().getOutInterceptors().add(new CxfLoggingOutInterceptor(writer));

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

    public static void initProxy(Client cxfClient) {
        // If system properties for proxy are set, then configure the httpconduit for cxf
        HTTPConduit conduit = (HTTPConduit) cxfClient.getConduit();

        String proxyHost = System.getenv(HTTPS_PROXY_HOST);
        if (proxyHost != null) {
            HTTPClientPolicy httpClientPolicy = new HTTPClientPolicy();
            httpClientPolicy.setProxyServer(proxyHost);
            httpClientPolicy.setProxyServerPort(Integer.parseInt(System.getenv(HTTPS_PROXY_PORT)));
            httpClientPolicy.setAllowChunking(false);
            conduit.setClient(httpClientPolicy);
        }

        try {
            URL webAddressUrl = new URL(conduit.getAddress());
            if (webAddressUrl.getProtocol().equals(HTTP_PROTOCOL) &&
                    System.getProperty(HTTP_PROXY_USER) != null) {
                conduit.getProxyAuthorization().setUserName(System.getProperty(HTTP_PROXY_USER));
                conduit.getProxyAuthorization().setPassword(System.getProperty(HTTP_PROXY_PASSWORD));
            }
            if (webAddressUrl.getProtocol().equals(HTTPS_PROTOCOL) &&
                    System.getProperty(HTTPS_PROXY_USER) != null) {
                conduit.getProxyAuthorization().setUserName(System.getProperty(HTTPS_PROXY_USER));
                conduit.getProxyAuthorization().setPassword(System.getProperty(HTTPS_PROXY_PASSWORD));
            }
        } catch (MalformedURLException mue) {
            LOGGER.error("Failed to parse ws address: [{}]", conduit.getAddress());
        }
    }
}
