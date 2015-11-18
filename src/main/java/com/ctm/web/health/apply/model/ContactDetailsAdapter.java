package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.contactDetails.*;
import com.ctm.web.health.apply.model.request.contactDetails.Address.*;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.HealthQuote;

import java.util.Optional;

public class ContactDetailsAdapter {


    protected static ContactDetails createContactDetails(Optional<HealthQuote> quote) {
        final Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails = quote.map(HealthQuote::getContactDetails);
        PostalMatch postalMatch = quote.map(HealthQuote::getApplication)
                .map(Application::getPostalMatch)
                .map(PostalMatch::valueOf)
                .orElse(PostalMatch.N);
        if (contactDetails.isPresent()) {
            return new ContactDetails(
                    contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getEmail)
                            .map(Email::new)
                            .orElse(null),
                    contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getOptin)
                            .map(OptInEmail::valueOf)
                            .orElse(null),
                    quote.map(HealthQuote::getApplication)
                            .map(Application::getMobile)
                            .map(MobileNumber::new)
                            .orElse(null),
                    quote.map(HealthQuote::getApplication)
                            .map(Application::getOther)
                            .map(OtherNumber::new)
                            .orElse(null),
                    quote.map(HealthQuote::getApplication)
                            .map(Application::getCall)
                            .map(Call::valueOf)
                            .orElse(null),
                    postalMatch,
                    createAddress(quote.map(HealthQuote::getApplication)
                            .map(Application::getAddress)),
                    !PostalMatch.Y.equals(postalMatch) ?
                            createAddress(quote.map(HealthQuote::getApplication)
                                    .map(Application::getPostal)) : null,
                    quote.map(HealthQuote::getApplication)
                            .map(Application::getContactPoint)
                            .filter(c -> c.equals("E") || c.equals("P"))
                            .map(c -> c.equals("E") ? PreferredContact.EMAIL : PreferredContact.PHONE)
                            .orElse(null),
                    quote.map(HealthQuote::getContactAuthority)
                            .map(Contactable::valueOf)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static Address createAddress(Optional<com.ctm.web.health.model.form.Address> address) {
        if (address.isPresent()) {
            return new Address(
                    address.map(com.ctm.web.health.model.form.Address::getPostCode)
                            .map(Postcode::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getFullAddressLineOne)
                            .map(FullAddressOneLine::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getSuburbName)
                            .map(Suburb::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getStreetNum)
                            .map(StreetNumber::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getDpId)
                            .map(DPID::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getState)
                            .map(State::valueOf)
                            .orElse(null));
        } else {
            return null;
        }
    }

}
