package com.ctm.services;

import com.ctm.aglead.ws.Request;
import com.ctm.aglead.ws.Response;
import com.ctm.model.settings.PageSettings;
import org.apache.log4j.Logger;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

import java.io.IOException;

public class AgLeadFeedService extends WebServiceGatewaySupport {

    private Logger logger = Logger.getLogger(AgLeadFeedService.class);

    public Response request(PageSettings settings,  Request request) throws IOException {
        try {
            Jaxb2Marshaller marshaller = marshaller();
            String uri = settings.getSetting("agLeadFeedUrl");
            setMarshaller(marshaller);
            setUnmarshaller(marshaller);
            return (Response) getWebServiceTemplate().marshalSendAndReceive(uri, request);
        } catch (Exception e) {
            logger.error("a&g lead feed ws failed", e);
            throw new IOException(e);
        }
    }

    private Jaxb2Marshaller marshaller() {
        Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
        marshaller.setContextPaths("com.ctm.aglead.ws");
        return marshaller;
    }

}
