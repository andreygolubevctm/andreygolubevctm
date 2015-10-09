package com.ctm.providers.car.carquote.model;

import com.ctm.model.car.form.CarQuote;
import com.ctm.model.car.form.Vehicle;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class RequestAdapterTest {

    @Mock
    private CarQuote carQuote;

    @Mock
    private Vehicle vehicle;

    @Before
    public void setup() throws Exception {
        initMocks(this);
        when(carQuote.getVehicle()).thenReturn(vehicle);

//        when(carQuote.getConvertedAccs()).thenReturn();
    }

    @Test
    public void testCreateVehicle() throws Exception {
        RequestAdapter.createVehicle(carQuote);
        verify(carQuote, times(1)).getVehicle();
        verify(vehicle, times(1)).getMake();
        verify(vehicle, times(1)).getModel();
        verify(vehicle, times(1)).getYear();
        verify(vehicle, times(1)).getBody();
        verify(vehicle, times(1)).getTrans();
        verify(vehicle, times(1)).getFuel();
        verify(vehicle, times(1)).getRedbookCode();
        verify(vehicle, times(1)).getAnnualKilometres();
        verify(vehicle, times(1)).getDamage();
        verify(vehicle, times(1)).getFinance();
        verify(vehicle, times(1)).getMarketValue();
        verify(vehicle, times(1)).getModifications();
        verify(vehicle, times(1)).getRegistrationYear();
        verify(vehicle, times(1)).getSecurityOption();
        verify(vehicle, times(1)).getUse();
        verify(carQuote, times(1)).getConvertedAccs();

    }

    @Test
    public void testConvertedAccs() throws Exception {

    }


}