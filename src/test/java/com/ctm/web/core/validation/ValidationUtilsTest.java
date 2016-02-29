package com.ctm.web.core.validation;

import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertTrue;


public class ValidationUtilsTest {

    private String xpath = "test";
    private List<SchemaValidationError> validationErrors;

    @Before
    public void setUp() throws Exception {
        validationErrors = new ArrayList<>();
    }

    @Test
    public void testGetValueAndAddToErrorsIfEmpty() throws Exception {
        ValidationUtils.getValueAndAddToErrorsIfEmpty("abc",  xpath,  validationErrors);
        assertTrue(validationErrors.isEmpty());
        ValidationUtils.getValueAndAddToErrorsIfEmpty("",  xpath,  validationErrors);
        assertFalse(validationErrors.isEmpty());
    }

    @Test
    public void testGetValueAndAddToErrorsIfNull() throws Exception {
        ValidationUtils.getValueAndAddToErrorsIfNull("abc",  xpath,  validationErrors);
        assertTrue(validationErrors.isEmpty());
        ValidationUtils.getValueAndAddToErrorsIfNull(null,  xpath,  validationErrors);
        assertFalse(validationErrors.isEmpty());
    }

    @Test
    public void testGetValueAndAddToErrorsIfEmptyNumeric() throws Exception {
        ValidationUtils.getValueAndAddToErrorsIfEmptyNumeric("123456",  xpath,  validationErrors);
        assertTrue(validationErrors.isEmpty());
        ValidationUtils.getValueAndAddToErrorsIfEmptyNumeric("abc",  xpath,  validationErrors);
        assertFalse(validationErrors.isEmpty());
    }
}