package com.ctm.web.core.model.settings;

import com.ctm.web.core.email.services.LoadQuoteService;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by lbuchanan on 16/05/2016.
 */
public class VerticalSettingsTest {

    @Test
    public void getHomePageForVerticalHomeAndContents() throws Exception {
        assertEquals("home_contents_quote.jsp" , VerticalSettings.getHomePageJsp("HOME"));

    }

    @Test
    public void getHomePageForVerticalHomeLoan() throws Exception {
        assertEquals("homeloan_quote.jsp" , VerticalSettings.getHomePageJsp("HOMELOAN"));
    }

    @Test
    public void getHomePageForVerticalCar() throws Exception {
        assertEquals("car_quote.jsp" ,VerticalSettings.getHomePageJsp("CAR"));
    }

}