package com.ctm.web.health.apply.model;

import com.ctm.web.health.model.form.*;
import org.junit.Test;

import java.util.Optional;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

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
        assertNotNull(ContactDetailsAdapter.createAddress(Optional.of(address)));
        verify(address, times(1)).getPostCode();
        verify(address, times(1)).getFullAddressLineOne();
        verify(address, times(1)).getSuburbName();
        verify(address, times(1)).getStreetNum();
        verify(address, times(1)).getDpId();
        verify(address, times(1)).getState();
    }

}
