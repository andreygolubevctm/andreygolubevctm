package com.ctm.logging;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ws.client.WebServiceClientException;
import org.springframework.ws.client.support.interceptor.ClientInterceptor;
import org.springframework.ws.context.MessageContext;

public class SpringWSLoggingInterceptor implements ClientInterceptor {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SpringWSLoggingInterceptor.class);
	
	XMLOutputWriter xmloutputWriter;

	public SpringWSLoggingInterceptor(XMLOutputWriter xmloutputWriter) {
		this.xmloutputWriter = xmloutputWriter;
	}
	
	@Override
	public void afterCompletion(MessageContext context, Exception exception) throws WebServiceClientException {
		xmloutputWriter.lastWriteXmlToFile("Finished SOAP Request Logging");
	}

	@Override
	public boolean handleFault(MessageContext arg0) throws WebServiceClientException {
		return false;
	}

	@Override
	public boolean handleRequest(MessageContext context) throws WebServiceClientException {
		writeLog(context);		
		return true;
	}

	@Override
	public boolean handleResponse(MessageContext context) throws WebServiceClientException {
		writeLog(context);
		return true;
	}
	
	private void writeLog(MessageContext context) {
		try {
			ByteArrayOutputStream out = new ByteArrayOutputStream();
			
			String type;
			if(context.hasResponse()) {
				context.getResponse().writeTo(out);
				type = XMLOutputWriter.RESP_IN;
			} else {
				context.getRequest().writeTo(out);
				type = XMLOutputWriter.REQ_OUT;
			}
			
			byte[] charData = out.toByteArray();
			String str = new String(charData, "ISO-8859-1");
			
			xmloutputWriter.writeXmlToFile(str, type);
		} catch (IOException e) {
			LOGGER.error("SOAP Request Logging Failed", e);
		}
	}

}
