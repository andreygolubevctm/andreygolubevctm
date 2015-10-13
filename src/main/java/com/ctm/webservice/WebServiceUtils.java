package com.ctm.webservice;

import com.ctm.logging.CxfLoggingInInterceptor;
import com.ctm.logging.CxfLoggingOutInterceptor;
import com.ctm.logging.XMLOutputWriter;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.saaj.SAAJOutInterceptor;
import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.interceptor.Interceptor;
import org.apache.cxf.ws.security.wss4j.WSS4JOutInterceptor;
import org.apache.wss4j.dom.WSConstants;
import org.apache.wss4j.dom.handler.WSHandlerConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
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
		Map<String, Object> outProps = new HashMap<String, Object>();

		outProps.put(WSHandlerConstants.ACTION, WSHandlerConstants.USERNAME_TOKEN);
		outProps.put(WSHandlerConstants.USER, username);
		outProps.put(WSHandlerConstants.PASSWORD_TYPE, WSConstants.PW_TEXT);

		ctx.put("password", password);

		Interceptor<SoapMessage> wssOut = new WSS4JOutInterceptor(outProps);
		cxfEndpoint.getOutInterceptors().add(wssOut);
	}

	public static void setLogging(Endpoint endPoint, PageSettings pageSettings, Long transactionId) {

		// Log copy of XML Request/Response in Debug folders
		String path = "";
		if(pageSettings.getVertical().getType() == Vertical.VerticalType.CAR){
			path = "get_prices/app-logs-debug";
		}else{
			path = pageSettings.getVerticalCode()+"/app-logs-debug";
		}

		String fileName = "_EXACT_TARGET_EMAIL";
		if(transactionId != null) {
			fileName = transactionId + fileName;
		}
		XMLOutputWriter writer = new XMLOutputWriter(fileName, path);

		Map<String, Object> outProperties = new HashMap<>();
		WSS4JOutInterceptor wssOut = new WSS4JOutInterceptor( outProperties );
		endPoint.getOutInterceptors().add( wssOut );
		endPoint.getOutInterceptors().add( new SAAJOutInterceptor() );
		endPoint.getInInterceptors().add( new CxfLoggingInInterceptor(writer, transactionId) );
		endPoint.getOutInterceptors().add( new CxfLoggingOutInterceptor(writer, transactionId) );
		endPoint.getOutInterceptors().add(wssOut);
	}

}
