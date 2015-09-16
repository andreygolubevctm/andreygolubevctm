package com.ctm.services.car;

import com.ctm.model.car.form.CarRequest;
import com.ctm.model.car.results.CarResult;
import com.ctm.model.results.ResultProperty;
import junit.framework.TestCase;
import org.mockito.Mock;

import java.util.ArrayList;
import java.util.List;

import static org.mockito.MockitoAnnotations.initMocks;

public class CarQuoteServiceTest extends TestCase {

    private CarQuoteService service = new CarQuoteService();

    @Mock
    private CarRequest carRequest;

    public void setup() {
        initMocks(this);
    }

    public void testGetResultProperties() throws Exception {
        final List<CarResult> carResults = new ArrayList<>();
        final List<ResultProperty> resultProperties = service.getResultProperties(carRequest, carResults);
        assertTrue(resultProperties.isEmpty());
    }
}