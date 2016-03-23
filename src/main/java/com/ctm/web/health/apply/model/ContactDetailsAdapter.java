package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.contactDetails.Address.*;
import com.ctm.web.health.apply.model.request.contactDetails.*;
import com.ctm.web.health.apply.model.request.contactDetails.Address.Address;
import com.ctm.web.health.apply.model.request.contactDetails.ContactDetails;
import com.ctm.web.health.model.form.*;
import org.apache.commons.lang3.StringUtils;

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
                    createEmail(quote),
                    contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getOptin)
                            .map(OptInEmail::valueOf)
                            .orElse(null),
                    createMobileNumber(quote),
                    createOtherNumber(quote),
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

    protected static OtherNumber createOtherNumber(Optional<HealthQuote> quote) {
        return quote.map(HealthQuote::getApplication)
                .map(Application::getOther)
                .map(OtherNumber::new)
                .orElse(createContactDetailsOtherNumber(quote.map(HealthQuote::getContactDetails)));
    }

    protected static OtherNumber createContactDetailsOtherNumber(Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails) {
        return contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getContactNumber)
                .map(ContactNumber::getOther)
                .map(OtherNumber::new)
                .orElse(null);
    }

    protected static MobileNumber createMobileNumber(Optional<HealthQuote> quote) {
        return quote.map(HealthQuote::getApplication)
                .map(Application::getMobile)
                .map(MobileNumber::new)
                .orElse(createContactDetailsMobileNumber(quote.map(HealthQuote::getContactDetails)));
    }

    protected static MobileNumber createContactDetailsMobileNumber(Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails) {
        return contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getContactNumber)
                .map(ContactNumber::getMobile)
                .map(MobileNumber::new)
                .orElse(null);
    }

    protected static Email createEmail(Optional<HealthQuote> quote) {
        return quote.map(HealthQuote::getApplication)
                .map(Application::getEmail)
                .map(Email::new)
                .orElse(createContactDetailsEmail(quote.map(HealthQuote::getContactDetails)));
    }

    protected static Email createContactDetailsEmail(Optional<com.ctm.web.health.model.form.ContactDetails> contactDetails) {
        return contactDetails.map(com.ctm.web.health.model.form.ContactDetails::getEmail)
                .map(Email::new)
                .orElse(null);
    }

    protected static Address createAddress(Optional<com.ctm.web.health.model.form.Address> address) {
        if (address.isPresent()) {
            return new Address(
                    address.map(com.ctm.web.health.model.form.Address::getPostCode)
                            .map(Postcode::new)
                            .orElse(null),
                    address.map(com.ctm.web.health.model.form.Address::getFullAddressLineOne)
                            .map(FullAddressOneLine::new)
                            .orElseGet(() -> createFullAddressOneLine(address)),
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

    private static FullAddressOneLine createFullAddressOneLine(Optional<com.ctm.web.health.model.form.Address> optionalAddress) {
        if (optionalAddress.isPresent()) {
            final com.ctm.web.health.model.form.Address address = optionalAddress.get();
            StringBuilder sb = new StringBuilder();
            if (StringUtils.isNotBlank(address.getUnitShop())) {
                sb.append(address.getUnitShop()).append(" ");
            }
            sb.append(address.getStreetNum()).append(" ").append(address.getStreetName());
            return new FullAddressOneLine(sb.toString());
        }
        return null;
    }

}
