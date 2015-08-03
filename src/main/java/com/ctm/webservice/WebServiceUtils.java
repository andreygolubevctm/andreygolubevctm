package com.ctm.webservice;

import java.util.HashMap;
import java.util.Map;

import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.saaj.SAAJOutInterceptor;
import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.interceptor.Interceptor;
import org.apache.cxf.interceptor.LoggingInInterceptor;
import org.apache.cxf.interceptor.LoggingOutInterceptor;
import org.apache.cxf.ws.security.wss4j.WSS4JOutInterceptor;
import org.apache.log4j.Logger;
import org.apache.wss4j.dom.WSConstants;
import org.apache.wss4j.dom.handler.WSHandlerConstants;

public class WebServiceUtils {

	static Logger logger = Logger.getLogger(WebServiceUtils.class.getName());

	public static void setWsSecurity(Endpoint cxfEndpoint, Map<String, Object> ctx, String username, String password) {
		Map<String, Object> outProps = new HashMap<String, Object>();

		outProps.put(WSHandlerConstants.ACTION, WSHandlerConstants.USERNAME_TOKEN);
		outProps.put(WSHandlerConstants.USER, username);
		outProps.put(WSHandlerConstants.PASSWORD_TYPE, WSConstants.PW_TEXT);

		ctx.put("password", password);

		Interceptor<SoapMessage> wssOut = new WSS4JOutInterceptor(outProps);
		cxfEndpoint.getOutInterceptors().add(wssOut);
	}

	public static void setLogging(Endpoint endPoint) {
		if(logger.isDebugEnabled()){
			Map<String, Object> outProperties = new HashMap<String, Object>();
			WSS4JOutInterceptor wssOut = new WSS4JOutInterceptor( outProperties );
			endPoint.getOutInterceptors().add( wssOut );
			endPoint.getOutInterceptors().add( new SAAJOutInterceptor() );
			endPoint.getInInterceptors().add( new LoggingInInterceptor() );
			endPoint.getOutInterceptors().add( new LoggingOutInterceptor() );
			endPoint.getOutInterceptors().add(wssOut);
		}
	}

}
