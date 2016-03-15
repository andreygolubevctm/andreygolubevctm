package com.ctm.web.health.validation;

import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Simples;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class HealthQuoteValidationTest {

    private HealthQuoteValidation healthQuoteValidation;
    private HealthRequest request;

    @Before
    public void setUp() throws Exception {
        request = new HealthRequest();
        HealthQuote health = new HealthQuote();
        Simples simples = new Simples();
        String contactType = "contactType";
        simples.setContactType(contactType);
        health.setSimples(simples);
        request.setHealth(health);
        healthQuoteValidation = new HealthQuoteValidation();
    }


    @Test
    public void testValidateRequestNoSimplesIsCallCentre() throws Exception {
        boolean isCallCentre = true;
        request.getHealth().setSimples(null);
        List<SchemaValidationError> result =  healthQuoteValidation.validate( request, isCallCentre);
        assertFalse(result.isEmpty());
    }

    @Test
    public void testValidateRequestNoContactTypeIsCallCentre() throws Exception {
        boolean isCallCentre = true;
        request.getHealth().getSimples().setContactType(null);
        List<SchemaValidationError> result =  healthQuoteValidation.validate( request, isCallCentre);
        assertFalse(result.isEmpty());
    }


    @Test
    public void testValidateRequestNoSimplesNotCallCentre() throws Exception {
        boolean isCallCentre = false;
        request.getHealth().setSimples(null);
        List<SchemaValidationError> result =  healthQuoteValidation.validate( request, isCallCentre);
        assertTrue(result.isEmpty());
    }

    @Test
    public void testValidateRequestNoContactTypeNotCallCentre() throws Exception {
        boolean isCallCentre = false;
        request.getHealth().getSimples().setContactType(null);
        List<SchemaValidationError> result =  healthQuoteValidation.validate( request, isCallCentre);
        assertTrue(result.isEmpty());
    }
}