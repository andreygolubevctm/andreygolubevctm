package com.ctm.services.email;

import com.ctm.logging.CorrelationIdUtils;
import com.ctm.web.core.model.email.ExactTargetEmailModel;
import com.exacttarget.wsdl.partnerapi.CreateRequest;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class ExactTargetEmailBuilderTest {

    @Test
    public void shouldSetCorrelationId() throws Exception {
        ExactTargetEmailModel emailModel = new ExactTargetEmailModel();
        emailModel.setBrand("brand");
        emailModel.setSubscriberKey("subscriberKey");
        CreateRequest createRequest = new CreateRequest();
        CorrelationIdUtils.setCorrelationId("test");
        ExactTargetEmailBuilder.createPayload(emailModel, createRequest);
        assertEquals("test", createRequest.getObjects().get(0).getCorrelationID());

    }

}