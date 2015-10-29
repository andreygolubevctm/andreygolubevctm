package com.ctm.web.car.leadfeed.router;

import com.ctm.model.settings.Vertical;
import com.ctm.web.car.leadfeed.services.CarLeadFeedService;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class CarLeadFeedRouterTest {
    private CarLeadFeedRouter router;

    @Before
    public void setup(){
        router = new CarLeadFeedRouter();

    }

    @Test
    public void shouldGetLeadFeedService(){
        assertEquals(CarLeadFeedService.class , router.getLeadFeedService().getClass());
    }

    @Test
    public void shouldGetVertical(){
        assertEquals(Vertical.VerticalType.CAR.getCode() , router.getVerticalCode());
    }

}