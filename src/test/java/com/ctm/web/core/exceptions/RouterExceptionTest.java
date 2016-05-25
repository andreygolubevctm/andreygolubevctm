package com.ctm.web.core.exceptions;


import com.ctm.web.core.validation.SchemaValidationError;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class RouterExceptionTest {

    private Long transactionId =  100000L;

    @Test
    public void testShouldGetValidationErrors() throws Exception {
        List<SchemaValidationError> validationErrors = new ArrayList<>();
        RouterException exception = new RouterException(transactionId , validationErrors);
        assertEquals(validationErrors, exception.getValidationErrors());

    }
}