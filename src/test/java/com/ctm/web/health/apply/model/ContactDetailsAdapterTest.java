package com.ctm.web.health.apply.model;

import com.ctm.web.health.model.form.*;
import org.junit.Test;

import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.*;

public class ContactDetailsAdapterTest {

    @Test
    public void testCreateContactDetailsEmpty() throws Exception {
        assertNull(ContactDetailsAdapter.createContactDetails(Optional.empty()));
    }

    @Test
    public void testCreateContactDetails() throws Exception {
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
    public void testCreateContactDetailsDiffPostal() throws Exception {
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
    public void testCreateAddressEmpty() throws Exception {
        assertNull(ContactDetailsAdapter.createAddress(Optional.empty()));
    }

    @Test
    public void testCreateAddress() throws Exception {
        final Address address = mock(Address.class);
        when(address.getFullAddressLineOne()).thenReturn("Address line");
        assertNotNull(ContactDetailsAdapter.createAddress(Optional.of(address)));
        verify(address, times(1)).getPostCode();
        verify(address, times(1)).getFullAddressLineOne();
        verify(address, times(1)).getSuburbName();
        verify(address, never()).getStreetNum();
        verify(address, times(1)).getDpId();
        verify(address, times(1)).getState();
    }

    @Test
    public void testCreateEmailHealthQuoteEmpty() throws Exception {
        assertNull(ContactDetailsAdapter.createEmail(Optional.empty()));
    }

    @Test
    public void testCreateEmailFromApplication() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getEmail()).thenReturn("test@test.com.au");
        assertEquals("test@test.com.au", ContactDetailsAdapter.createEmail(Optional.of(healthQuote)).get());
    }

    @Test
    public void testCreateEmailFromContactDetails() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getEmail()).thenReturn("test@test.com.au");
        assertEquals("test@test.com.au", ContactDetailsAdapter.createEmail(Optional.of(healthQuote)).get());
    }

    @Test
    public void testCreateEmailEmpty() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        assertNull(ContactDetailsAdapter.createEmail(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateMobileNumberHealthQuoteEmpty() throws Exception {
        assertNull(ContactDetailsAdapter.createMobileNumber(Optional.empty()));
    }

    @Test
    public void testCreateMobileNumberFromApplication() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getMobile()).thenReturn("0400000000");
        assertEquals("0400000000", ContactDetailsAdapter.createMobileNumber(Optional.of(healthQuote)).get());
    }

    @Test
    public void testCreateMobileNumberFromContactDetails() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        final ContactNumber contactNumber = mock(ContactNumber.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getContactNumber()).thenReturn(contactNumber);
        when(contactNumber.getMobile()).thenReturn("0400000000");
        assertEquals("0400000000", ContactDetailsAdapter.createMobileNumber(Optional.of(healthQuote)).get());
    }

    @Test
    public void testCreateMobileNumberEmpty() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        assertNull(ContactDetailsAdapter.createMobileNumber(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateOtherNumberHealthQuoteEmpty() throws Exception {
        assertNull(ContactDetailsAdapter.createOtherNumber(Optional.empty()));
    }

    @Test
    public void testCreateOtherNumberFromApplication() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getOther()).thenReturn("0700000000");
        assertEquals("0700000000", ContactDetailsAdapter.createOtherNumber(Optional.of(healthQuote)).get());
    }

    @Test
    public void testCreateOtherNumberFromContactDetails() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final ContactDetails contactDetails = mock(ContactDetails.class);
        final ContactNumber contactNumber = mock(ContactNumber.class);
        when(healthQuote.getContactDetails()).thenReturn(contactDetails);
        when(contactDetails.getContactNumber()).thenReturn(contactNumber);
        when(contactNumber.getOther()).thenReturn("0700000000");
        assertEquals("0700000000", ContactDetailsAdapter.createOtherNumber(Optional.of(healthQuote)).get());
    }

    @Test
    public void testCreateOtherNumberEmpty() throws Exception {
        final HealthQuote healthQuote = mock(HealthQuote.class);
        assertNull(ContactDetailsAdapter.createOtherNumber(Optional.of(healthQuote)));
    }

    @Test
    public void testCreateFullAddressOneLineEmpty() throws Exception {
        assertNull(ContactDetailsAdapter.createFullAddressOneLine(Optional.empty()));
    }

    @Test
    public void testCreateFullAddressOneLine() throws Exception {
        final Address address = mock(Address.class);
        when(address.getUnitType()).thenReturn("UN");
        when(address.getUnitShop()).thenReturn("1");
        when(address.getStreetNum()).thenReturn("35");
        when(address.getStreetName()).thenReturn("William Street");
        assertEquals("Unit 1 35 William Street", ContactDetailsAdapter.createFullAddressOneLine(Optional.of(address)).get());
    }

    @Test
    public void testCreateFullAddressOneLineUnknownUnitType() throws Exception {
        final Address address = mock(Address.class);
        when(address.getUnitType()).thenReturn("XX");
        when(address.getUnitShop()).thenReturn("1");
        when(address.getStreetNum()).thenReturn("35");
        when(address.getStreetName()).thenReturn("William Street");
        assertEquals("Other 1 35 William Street", ContactDetailsAdapter.createFullAddressOneLine(Optional.of(address)).get());
    }

}
