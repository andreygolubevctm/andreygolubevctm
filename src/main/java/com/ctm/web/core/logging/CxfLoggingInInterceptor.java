package com.ctm.web.core.logging;

import org.apache.cxf.interceptor.LoggingInInterceptor;

import java.util.logging.Logger;

public class CxfLoggingInInterceptor extends LoggingInInterceptor {

    XMLOutputWriter xmloutputWriter;

    public CxfLoggingInInterceptor(XMLOutputWriter xmloutputWriter) {
        this.xmloutputWriter = xmloutputWriter;
    }

    @Override
    protected void log(final Logger logger, final String message) {
        xmloutputWriter.lastWriteXmlToFile(message, XMLOutputWriter.RESP_IN);
    }

}
