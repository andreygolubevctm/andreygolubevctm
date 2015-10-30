package com.ctm.model.health.results;

import com.ctm.utils.ObjectMapperUtil;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class HealthResultTest {

    @Test
    public void testToJsonSuccess() throws Exception {

        final String expected = "{\"result\":{\"transactionId\":0,\"success\":true,\"confirmationID\":\"123-123\"}}";

        HealthResultWrapper resultWrapper = new HealthResultWrapper();
        final HealthApplicationResult response = new HealthApplicationResult();
        response.setSuccess(true);
        response.setConfirmationID("123-123");
        resultWrapper.setResult(response);
        assertEquals(expected, ObjectMapperUtil.getObjectMapper().writeValueAsString(resultWrapper));
    }

    @Test
    public void testToJsonFailureWithErrors() throws Exception {

        final String expected = "{\"result\":{\"transactionId\":0,\"success\":false,\"pendingID\":\"123-123\",\"errors\":[{\"code\":\"000\",\"text\":\"Error 000\"},{\"code\":\"111\",\"text\":\"Error 111\"}]}}";

        HealthResultWrapper resultWrapper = new HealthResultWrapper();
        final HealthApplicationResult response = new HealthApplicationResult();
        response.setSuccess(false);
        response.setPendingID("123-123");
        List<ResponseError> responseErrors = new ArrayList<>();
        final ResponseError e1 = new ResponseError();
        e1.setCode("000");
        e1.setText("Error 000");
        responseErrors.add(e1);
        final ResponseError e2 = new ResponseError();
        e2.setCode("111");
        e2.setText("Error 111");
        responseErrors.add(e2);
        response.setErrors(responseErrors);
        resultWrapper.setResult(response);
        assertEquals(expected, ObjectMapperUtil.getObjectMapper().writeValueAsString(resultWrapper));

    }

    @Test
    public void testToJsonFailureWithErrorsAndCallCentre() throws Exception {

        final String expected = "{\"result\":{\"transactionId\":0,\"success\":false,\"callcentre\":true,\"pendingID\":\"123-123\",\"errors\":[{\"code\":\"000\",\"text\":\"Error 000\"},{\"code\":\"111\",\"text\":\"Error 111\"}]}}";

        HealthResultWrapper resultWrapper = new HealthResultWrapper();
        final HealthApplicationResult response = new HealthApplicationResult();
        response.setSuccess(false);
        response.setPendingID("123-123");
        response.setCallcentre(true);
        List<ResponseError> responseErrors = new ArrayList<>();
        final ResponseError e1 = new ResponseError();
        e1.setCode("000");
        e1.setText("Error 000");
        responseErrors.add(e1);
        final ResponseError e2 = new ResponseError();
        e2.setCode("111");
        e2.setText("Error 111");
        responseErrors.add(e2);
        response.setErrors(responseErrors);
        resultWrapper.setResult(response);
        assertEquals(expected, ObjectMapperUtil.getObjectMapper().writeValueAsString(resultWrapper));

    }

}