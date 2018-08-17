package com.ctm.web.health.email.services;

import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.health.model.form.*;

import java.util.Optional;


public class HealthEmailMapper {

    public static String getFirstName(EmailMaster emailDetails, Optional<HealthRequest> data) {
        return data.map(HealthRequest::getQuote)
                .map(HealthQuote::getApplication)
                .map(Application::getPrimary)
                .map(Person::getFirstname)
                .filter(name -> !name.isEmpty())
                .orElse(data.map(HealthRequest::getQuote)
                        .map(HealthQuote::getContactDetails)
                        .map(ContactDetails::getName)
                        .filter(name -> !name.isEmpty())
                        .orElse(emailDetails.getFirstName()));
    }
}
