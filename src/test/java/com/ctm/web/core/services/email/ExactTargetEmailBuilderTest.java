package com.ctm.web.core.email.services;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.commonlogging.correlationid.CorrelationIdUtils;
import com.ctm.interfaces.common.types.CorrelationId;
import com.ctm.web.core.email.model.ExactTargetEmailModel;
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
        LoggingVariables.setCorrelationId(CorrelationId.instanceOf("test"));
        ExactTargetEmailBuilder.createPayload(emailModel, createRequest);
        assertEquals("test", createRequest.getObjects().get(0).getCorrelationID());

    }

}