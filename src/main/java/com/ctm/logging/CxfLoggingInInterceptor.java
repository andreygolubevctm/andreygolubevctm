package com.ctm.logging;

import org.apache.cxf.interceptor.LoggingInInterceptor;
import org.apache.cxf.interceptor.LoggingMessage;
import org.apache.cxf.message.Message;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.io.Reader;


public class CxfLoggingInInterceptor extends LoggingInInterceptor {
    private static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(CxfLoggingInInterceptor.class);

    XMLOutputWriter xmloutputWriter;
    Long transactionId;

    public CxfLoggingInInterceptor(XMLOutputWriter xmloutputWriter, Long transactionId) {
        this.xmloutputWriter = xmloutputWriter;
        this.transactionId = transactionId;
    }

    @Override
    public void handleMessage(final Message message) {
        writeLog(message);
    }

    private void writeLog(Message message) {
        String id = (String) message.getExchange().get(LoggingMessage.ID_KEY);
        if (id == null) {
            id = LoggingMessage.nextId();
            message.getExchange().put(LoggingMessage.ID_KEY, id);
        }

        final LoggingMessage buffer = new LoggingMessage("Inbound Message\n----------------------------", id);
        String encoding = (String) message.get(Message.ENCODING);
        String ct = (String) message.get(Message.CONTENT_TYPE);

        InputStream is = message.getContent(InputStream.class);
        if (is != null) {
            logInputStream(message, is, buffer, encoding, ct);
        } else {
            Reader reader = message.getContent(Reader.class);
            if (reader != null) {
                logReader(message, reader, buffer);
            }
        }

        xmloutputWriter.writeXmlToFile(buffer.getPayload().toString(), XMLOutputWriter.RESP_IN);
        LOGGER.info(xmloutputWriter.getLoggerName());

    }
}
