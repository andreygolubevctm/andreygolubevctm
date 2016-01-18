package com.ctm.web.core.services;

import com.ctm.aglead.ws.Request;
import com.ctm.aglead.ws.Response;
import com.ctm.web.core.logging.SpringWSLoggingInterceptor;
import com.ctm.web.core.logging.XMLOutputWriter;
import com.ctm.web.core.model.settings.PageSettings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

import java.io.IOException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * This class should only be used by Life/IP.
 * A more current refactor was started for AGIS leads to be used on Car.
 * Use com.ctm.web.core.services.leadfeed.AGISLeadFeedService.java instead
 */
public class AgLeadFeedService extends WebServiceGatewaySupport {

	private static final Logger LOGGER = LoggerFactory.getLogger(AgLeadFeedService.class);
    
    private String transactionId;
    
    public void setTransactionId(String transactionId) {
    	this.transactionId = transactionId;
    }

    public Response request(PageSettings settings,  Request request) throws IOException {
        String folderPath = EnvironmentService.getEnvironment() == EnvironmentService.Environment.LOCALHOST ? "app-logs-debug" : "debug";
        String path = settings.getVerticalCode() + "/" + folderPath;
        String fileName = "_AGIS_LEADFEED";
        if(transactionId != null)
        	fileName = transactionId + fileName;
        
        XMLOutputWriter writer = new XMLOutputWriter(fileName, path);
        
    	setInterceptors(new SpringWSLoggingInterceptor[]{ new SpringWSLoggingInterceptor(writer)});
    	
        try {
            Jaxb2Marshaller marshaller = marshaller();
            String uri = settings.getSetting("agLeadFeedUrl");
            setMarshaller(marshaller);
            setUnmarshaller(marshaller);

            Object r =  getWebServiceTemplate().marshalSendAndReceive(uri, request);

            return (Response) r; 
        } catch (Exception e) {
            LOGGER.error("A&G lead feed webservice failed {}, {}", kv("settings", settings), kv("transactionId", transactionId), e);
            throw new IOException(e);
        }
    }

    private Jaxb2Marshaller marshaller() {
        Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
        marshaller.setContextPaths("com.ctm.aglead.ws");
        return marshaller;
    }

}
