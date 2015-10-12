package com.ctm.logging;

import org.apache.cxf.interceptor.LoggingOutInterceptor;
import org.slf4j.LoggerFactory;

public class CxfLoggingOutInterceptor extends LoggingOutInterceptor {
    private static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(CxfLoggingOutInterceptor.class);

    XMLOutputWriter xmloutputWriter;
    Long transactionId;

    public CxfLoggingOutInterceptor(XMLOutputWriter xmloutputWriter, Long transactionId) {
        this.xmloutputWriter = xmloutputWriter;
        this.transactionId = transactionId;
    }

}
