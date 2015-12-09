package com.ctm.web.car.form;

import com.ctm.web.car.model.form.*;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class CarQuoteTest {

    @Test
    public void testGetConvertedAccs() throws Exception {
        CarQuote quote = new CarQuote();

        Map<String, String> accs = new HashMap<>();

        accs.put("acc27.sel","C*");
        accs.put("acc27.inc","N");
        accs.put("acc27.prc","125");
        accs.put("acc13.sel","CH");
        accs.put("acc13.inc","N");
        accs.put("acc13.prc","125");
        accs.put("acc2.sel","CB");
        accs.put("acc2.inc","N");
        accs.put("acc2.prc", "500");
        accs.put("acc3.sel", "CA");
        accs.put("acc3.inc", "Y");

        quote.setAccs(accs);

        final Map<String, Acc> convertedAccs = quote.getConvertedAccs();

        assertEquals(4, convertedAccs.size());

        Acc acc27 = convertedAccs.get("acc27");
        assertNotNull(acc27);
        assertEquals("C*", acc27.getSel());
        assertEquals("N", acc27.getInc());
        assertEquals("125", acc27.getPrc());

        Acc acc13 = convertedAccs.get("acc13");
        assertNotNull(acc13);
        assertEquals("CH", acc13.getSel());
        assertEquals("N", acc13.getInc());
        assertEquals("125", acc13.getPrc());

        Acc acc2 = convertedAccs.get("acc2");
        assertNotNull(acc2);
        assertEquals("CB", acc2.getSel());
        assertEquals("N", acc2.getInc());
        assertEquals("500", acc2.getPrc());

        Acc acc3 = convertedAccs.get("acc3");
        assertNotNull(acc3);
        assertEquals("CA", acc3.getSel());
        assertEquals("Y", acc3.getInc());
        assertNull(acc3.getPrc());

    }

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
        verify(regular, times(1)).getFirstname();
        verify(regular, times(1)).getSurname();
        verify(contact, times(1)).getPhone();
        verify(vehicle, times(1)).getRedbookCode();
        verify(riskAddress, times(1)).getState();
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