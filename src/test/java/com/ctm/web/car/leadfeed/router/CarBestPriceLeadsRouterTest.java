package com.ctm.web.car.leadfeed.router;

import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.car.leadfeed.services.CarLeadFeedService;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class CarBestPriceLeadsRouterTest {

    private CarBestPriceLeadsRouter router;

    @Before
    public void setup(){
        router = new CarBestPriceLeadsRouter();

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