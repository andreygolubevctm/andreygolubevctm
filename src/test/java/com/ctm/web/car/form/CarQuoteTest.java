package com.ctm.web.car.form;

import com.ctm.web.car.model.form.*;
import org.junit.Test;

import static org.mockito.Mockito.*;

public class CarQuoteTest {

    @Test
    public void testCreateLeadFeedInfo() throws Exception {
        final CarQuote carQuote = new CarQuote();
        final Contact contact = mock(Contact.class);
        when(contact.getOktocall()).thenReturn("Y");
        carQuote.setContact(contact);
        final Drivers drivers = mock(Drivers.class);
        carQuote.setDrivers(drivers);
        final Regular regular = mock(Regular.class);
        when(drivers.getRegular()).thenReturn(regular);
        final Vehicle vehicle = mock(Vehicle.class);
        carQuote.setVehicle(vehicle);
        final RiskAddress riskAddress = mock(RiskAddress.class);
        carQuote.setRiskAddress(riskAddress);

        carQuote.createLeadFeedInfo();
        verify(contact, times(1)).getOktocall();
        verify(regular, times(2)).getFirstname();
        verify(regular, times(2)).getSurname();
        verify(contact, times(1)).getPhone();
        verify(vehicle, times(1)).getRedbookCode();
        verify(riskAddress, times(2)).getState();
    }

    @Test
    public void testCreateLeadFeedInfoOkToCallN() throws Exception {
        final CarQuote carQuote = new CarQuote();
        final Contact contact = mock(Contact.class);
        when(contact.getOktocall()).thenReturn("N");
        carQuote.setContact(contact);
        final Drivers drivers = mock(Drivers.class);
        carQuote.setDrivers(drivers);
        final Regular regular = mock(Regular.class);
        when(drivers.getRegular()).thenReturn(regular);
        final Vehicle vehicle = mock(Vehicle.class);
        carQuote.setVehicle(vehicle);
        final RiskAddress riskAddress = mock(RiskAddress.class);
        carQuote.setRiskAddress(riskAddress);

        carQuote.createLeadFeedInfo();
        verify(contact, times(1)).getOktocall();
        verify(regular, never()).getFirstname();
        verify(regular, never()).getSurname();
        verify(contact, never()).getPhone();
        verify(vehicle, never()).getRedbookCode();
        verify(riskAddress, never()).getState();
    }
}