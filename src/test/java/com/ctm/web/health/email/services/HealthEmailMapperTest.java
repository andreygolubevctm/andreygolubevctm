package com.ctm.web.health.email.services;

import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.health.model.form.*;
import org.junit.Test;

import java.util.Optional;

import static org.junit.Assert.*;


public class HealthEmailMapperTest {

    @Test
    public void shouldPreferRequestForGetFirstName() throws Exception {
        String emailMasterName = "emailMasterName";
        String applyFirstName = "applyFirstName";
        EmailMaster emailDetails = new EmailMaster();
        emailDetails.setFirstName(emailMasterName);
        Optional<HealthRequest> data = getHealthRequest(applyFirstName);
        String result = HealthEmailMapper.getFirstName( emailDetails, data);
        assertEquals(applyFirstName, result);
    }

    @Test
    public void shouldGetQuoteIfNoApplyForGetFirstName() throws Exception {
        String emailMasterName = "emailMasterName";
        String contactName = "contactName";
        EmailMaster emailDetails = new EmailMaster();
        emailDetails.setFirstName(emailMasterName);
        HealthRequest healthRequest = new HealthRequest();
        HealthQuote health = new HealthQuote();
        healthRequest.setHealth(health);
        ContactDetails contactDetails = new ContactDetails();
        contactDetails.setName(contactName);
        health.setContactDetails(contactDetails);
        String result = HealthEmailMapper.getFirstName( emailDetails, Optional.of(healthRequest));
        assertEquals(contactName, result);
    }

    @Test
    public void shouldUseEmailMasterIfNoFirstName() throws Exception {
        String contactDetailsName = "emailMasterName";
        String applyFirstName = "";
        EmailMaster emailDetails = new EmailMaster();
        emailDetails.setFirstName(contactDetailsName);
        Optional<HealthRequest> data = getHealthRequest(applyFirstName);
        String result = HealthEmailMapper.getFirstName( emailDetails, data);
        assertEquals(contactDetailsName, result);
    }

    private Optional<HealthRequest> getHealthRequest(String firstName) {
        HealthRequest healthRequest = new HealthRequest();
        HealthQuote health = new HealthQuote();
        Application application = new Application();
        Person primary = new Person();
        primary.setFirstname(firstName);
        application.setPrimary(primary);
        health.setApplication(application);
        healthRequest.setHealth(health);
        return Optional.of(healthRequest);
    }

}