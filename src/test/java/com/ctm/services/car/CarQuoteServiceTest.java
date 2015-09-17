package com.ctm.services.car;

import com.ctm.model.car.form.CarQuote;
import com.ctm.model.car.form.CarRequest;
import com.ctm.model.car.results.CarResult;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.resultsData.AvailableType;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.*;
import static org.mockito.MockitoAnnotations.initMocks;

public class CarQuoteServiceTest {

    private CarQuoteService service = new CarQuoteService();

    @Mock
    private CarRequest carRequest;
    @Mock
    private CarQuote carQuote;

    @Before
    public void setup() {
        initMocks(this);
    }

    @Test
    public void testGetResultPropertiesEmpty() throws Exception {
        when(carRequest.getQuote()).thenReturn(carQuote);
        final List<CarResult> carResults = new ArrayList<>();
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertTrue(resultProperties.isEmpty());
    }

    @Test
    public void testGetResultProperties() throws Exception {
        when(carRequest.getQuote()).thenReturn(carQuote);
        final List<CarResult> carResults = new ArrayList<>();
        final CarResult carResult = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult.getAvailable()).thenReturn(AvailableType.Y);
        carResults.add(carResult);
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertFalse(resultProperties.isEmpty());
        assertEquals(12, resultProperties.size());
    }

    @Test
    public void testGetResultProperties2() throws Exception {
        when(carRequest.getQuote()).thenReturn(carQuote);
        final List<CarResult> carResults = new ArrayList<>();
        final CarResult carResult1 = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult1.getAvailable()).thenReturn(AvailableType.Y);
        carResults.add(carResult1);
        final CarResult carResult2 = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult2.getAvailable()).thenReturn(AvailableType.Y);
        carResults.add(carResult2);
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertFalse(resultProperties.isEmpty());
        assertEquals(24, resultProperties.size());
    }

    @Test
    public void testGetResultProperties3() throws Exception {
        when(carRequest.getQuote()).thenReturn(carQuote);
        final List<CarResult> carResults = new ArrayList<>();
        final CarResult carResult1 = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult1.getAvailable()).thenReturn(AvailableType.Y);
        carResults.add(carResult1);
        final CarResult carResult2 = mock(CarResult.class, RETURNS_MOCKS);
        when(carResult2.getAvailable()).thenReturn(AvailableType.N);
        carResults.add(carResult2);
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertFalse(resultProperties.isEmpty());
        assertEquals(12, resultProperties.size());
    }
}