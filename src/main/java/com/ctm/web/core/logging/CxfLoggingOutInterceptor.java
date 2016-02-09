package com.ctm.web.core.logging;

import org.apache.cxf.interceptor.LoggingOutInterceptor;

import java.util.logging.Logger;

public class CxfLoggingOutInterceptor extends LoggingOutInterceptor {

    XMLOutputWriter xmloutputWriter;

    public CxfLoggingOutInterceptor(XMLOutputWriter xmloutputWriter) {
        this.xmloutputWriter = xmloutputWriter;
    }

    @Override
    protected void log(final Logger logger, final String message) {
        String type = XMLOutputWriter.REQ_OUT;
        xmloutputWriter.writeXmlToFile(message, type);
    }

}
