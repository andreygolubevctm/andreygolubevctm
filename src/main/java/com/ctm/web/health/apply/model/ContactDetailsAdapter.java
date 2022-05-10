package com.ctm.web.health.apply.model;

import com.ctm.schema.health.v1_0_0.PreferredContactMethod;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.ContactNumber;
import com.ctm.web.health.model.form.HealthQuote;
import com.google.common.collect.ImmutableMap;

import java.util.Optional;

public class ContactDetailsAdapter {

    private static final ImmutableMap<String, com.ctm.schema.health.v1_0_0.PreferredContactMethod> PREFERRED_CONTACT_METHOD_MAP = ImmutableMap.<String, com.ctm.schema.health.v1_0_0.PreferredContactMethod>builder()
            .put("E", PreferredContactMethod.EMAIL)
            .put("S", PreferredContactMethod.SMS)
            .put("P", PreferredContactMethod.POST)
            .build();

    protected static com.ctm.schema.health.v1_0_0.ContactDetails createContactDetails(Optional<HealthQuote> quote) {
        final Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails = quote.map(HealthQuote::getContactDetails);
        final boolean isPostalMatch = quote.map(HealthQuote::getApplication)
                .map(Application::getPostalMatch)
                .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                .orElse(false);
        if (contactDetails.isPresent()) {
            return quote.map(HealthQuote::getContactDetails)
                    .map(cd -> new com.ctm.schema.health.v1_0_0.ContactDetails()
                            .withEmail(createEmail(quote))
                            .withOptInEmail(RequestAdapter.YES_INDICATOR.equalsIgnoreCase(contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getOptin).orElse(null)))
                            .withOptInCall(RequestAdapter.YES_INDICATOR.equalsIgnoreCase(quote.map(HealthQuote::getApplication).map(Application::getCall).orElse(null)))
                            .withResidentialAddress(createAddress(quote.map(HealthQuote::getApplication).map(Application::getAddress)))
                            .withPostalAddress(!isPostalMatch ?
                                    createAddress(quote.map(HealthQuote::getApplication).map(Application::getPostal)) :
                                    null)
                            .withPostalAddressMatch(isPostalMatch)
                            .withMobileNumber(createMobileNumber(quote))
                            .withOtherPhoneNumber(createOtherNumber(quote))
                            .withContactable(RequestAdapter.YES_INDICATOR.equalsIgnoreCase(quote.map(HealthQuote::getContactAuthority).orElse(null)))
                            .withPreferredContactMethod(getPreferredContactMethod(quote))
                    )
                    .orElse(null);
        } else {
            return null;
        }
    }

    private static com.ctm.schema.health.v1_0_0.PreferredContactMethod getPreferredContactMethod(Optional<HealthQuote> quote) {
        return quote.map(HealthQuote::getApplication)
                .map(Application::getContactPoint)
                .filter(PREFERRED_CONTACT_METHOD_MAP::containsKey)
                .map(PREFERRED_CONTACT_METHOD_MAP::get)
                .orElse(null);
    }

    protected static String createOtherNumber(Optional<HealthQuote> quote) {
        return quote.map(HealthQuote::getApplication)
                .map(Application::getOther)
                .orElse(createContactDetailsOtherNumber(quote.map(HealthQuote::getContactDetails)));
    }

    protected static String createContactDetailsOtherNumber(Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails) {
        return contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getContactNumber)
                .map(ContactNumber::getOther)
                .orElse(null);
    }

    protected static String createMobileNumber(Optional<HealthQuote> quote) {
        return quote.map(HealthQuote::getApplication)
                .map(Application::getMobile)
                .orElse(createContactDetailsMobileNumber(quote.map(HealthQuote::getContactDetails)));
    }

    protected static String createContactDetailsMobileNumber(Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails) {
        return contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getContactNumber)
                .map(ContactNumber::getMobile)
                .orElse(null);
    }

    protected static String createEmail(Optional<HealthQuote> quote) {
        return quote.map(HealthQuote::getApplication)
                .map(Application::getEmail)
                .orElse(createContactDetailsEmail(quote.map(HealthQuote::getContactDetails)));
    }

    protected static String createContactDetailsEmail(Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails) {
        return contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getEmail)
                .orElse(null);
    }

    protected static com.ctm.schema.address.v1_0_0.Address createAddress(Optional<com.ctm.web.health.model.form.Address> address) {
        if (address.isPresent()) {
            return new com.ctm.schema.address.v1_0_0.Address()
                    .withDpid(address.map(com.ctm.web.health.model.form.Address::getDpId).orElse(null))
                    .withUnitNumber(address.map(com.ctm.web.health.model.form.Address::getUnitShop).orElse(null))
                    .withUnitType(address.map(com.ctm.web.health.model.form.Address::getUnitType)
                            .orElse(address.map(com.ctm.web.health.model.form.Address::getNonStdUnitType).orElse(null)))
                    .withStreetNumber(address.map(com.ctm.web.health.model.form.Address::getStreetNum).orElse(null))
                    .withStreetName(address.map(com.ctm.web.health.model.form.Address::getStreetName)
                            .orElse(address.map(com.ctm.web.health.model.form.Address::getNonStdStreet).orElse(null)))
                    .withSuburb(address.map(com.ctm.web.health.model.form.Address::getSuburbName).orElse(null))
                    .withState(address.map(com.ctm.web.health.model.form.Address::getState)
                            .map(String::toUpperCase)
                            .map(com.ctm.schema.address.v1_0_0.State::fromValue)
                            .orElse(null))
                    .withPostcode(address.map(com.ctm.web.health.model.form.Address::getPostCode).orElse(null));
        } else {
            return null;
        }
    }
}
