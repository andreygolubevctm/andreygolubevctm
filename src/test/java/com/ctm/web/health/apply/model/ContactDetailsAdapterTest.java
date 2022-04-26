package com.ctm.web.health.apply.model;

import com.ctm.web.health.model.form.Address;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.ContactDetails;
import com.ctm.web.health.model.form.ContactNumber;
import com.ctm.web.health.model.form.HealthQuote;
import org.junit.Test;

import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class ContactDetailsAdapterTest {

    @Test
    public void testCreateContactDetailsEmpty() {
        assertNull(ContactDetailsAdapter.createContactDetails(Optional.empty()));
    }

    @Test
    public void testCreateContactDetails() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        final ContactNumber contactNumber = mock(ContactNumber.class);
        final Application application = mock(Application.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getContactNumber()).thenReturn(contactNumber);
        when(healthQuote.getApplication()).thenReturn(application);
        assertNotNull(ContactDetailsAdapter.createContactDetails(Optional.of(healthQuote)));
        verify(contactDetails, times(1)).getEmail();
        verify(contactDetails, times(1)).getOptin();
        verify(application, times(1)).getCall();
        verify(application, times(1)).getMobile();
        verify(application, times(1)).getOther();
        verify(application, times(1)).getPostalMatch();
        verify(application, times(1)).getPostal();
        verify(healthQuote, times(1)).getContactAuthority();
    }

    @Test
    public void testCreateContactDetailsDiffPostal() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        final ContactNumber contactNumber = mock(ContactNumber.class);
        final Application application = mock(Application.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getContactNumber()).thenReturn(contactNumber);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getPostalMatch()).thenReturn("Y");
        assertNotNull(ContactDetailsAdapter.createContactDetails(Optional.of(healthQuote)));
        verify(contactDetails, times(1)).getEmail();
        verify(contactDetails, times(1)).getOptin();
        verify(application, times(1)).getCall();
        verify(application, times(1)).getMobile();
        verify(application, times(1)).getOther();
        verify(application, times(1)).getPostalMatch();
        verify(application, never()).getPostal();
    }

    @Test
    public void testCreateAddressEmpty() {
        assertNull(ContactDetailsAdapter.createAddress(Optional.empty()));
    }

    @Test
    public void testCreateAddress() {
        final Address address = mock(Address.class);
        assertNotNull(ContactDetailsAdapter.createAddress(Optional.of(address)));
        verify(address, times(1)).getPostCode();
        verify(address, times(1)).getSuburbName();
        verify(address, times(1)).getStreetNum();
        verify(address, times(1)).getStreetName();
        verify(address, times(1)).getSuburbName();
        verify(address, times(1)).getDpId();
        verify(address, times(1)).getState();
    }

    @Test
    public void testCreateEmailHealthQuoteEmpty() {
        assertNull(ContactDetailsAdapter.createEmail(Optional.empty()));
    }

    @Test
    public void testCreateEmailFromApplication() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getEmail()).thenReturn("test@test.com.au");
        assertEquals("test@test.com.au", ContactDetailsAdapter.createEmail(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateEmailFromContactDetails() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getEmail()).thenReturn("test@test.com.au");
        assertEquals("test@test.com.au", ContactDetailsAdapter.createEmail(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateEmailEmpty() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        assertNull(ContactDetailsAdapter.createEmail(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateMobileNumberHealthQuoteEmpty() {
        assertNull(ContactDetailsAdapter.createMobileNumber(Optional.empty()));
    }

    @Test
    public void testCreateMobileNumberFromApplication() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getMobile()).thenReturn("0400000000");
        assertEquals("0400000000", ContactDetailsAdapter.createMobileNumber(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateMobileNumberFromContactDetails() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        final ContactNumber contactNumber = mock(ContactNumber.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getContactNumber()).thenReturn(contactNumber);
        when(contactNumber.getMobile()).thenReturn("0400000000");
        assertEquals("0400000000", ContactDetailsAdapter.createMobileNumber(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateMobileNumberEmpty() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        assertNull(ContactDetailsAdapter.createMobileNumber(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateOtherNumberHealthQuoteEmpty() {
        assertNull(ContactDetailsAdapter.createOtherNumber(Optional.empty()));
    }

    @Test
    public void testCreateOtherNumberFromApplication() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getOther()).thenReturn("0700000000");
        assertEquals("0700000000", ContactDetailsAdapter.createOtherNumber(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateOtherNumberFromContactDetails() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        final ContactNumber contactNumber = mock(ContactNumber.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getContactNumber()).thenReturn(contactNumber);
        when(contactNumber.getOther()).thenReturn("0700000000");
        assertEquals("0700000000", ContactDetailsAdapter.createOtherNumber(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateOtherNumberEmpty() {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        assertNull(ContactDetailsAdapter.createOtherNumber(Optional.of(healthQuote)));
    }
}
