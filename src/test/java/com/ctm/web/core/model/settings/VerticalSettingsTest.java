package com.ctm.web.core.model.settings;


import org.junit.Test;

import static org.junit.Assert.*;


public class VerticalSettingsTest {

    @Test
    public void getHomePageForVerticalHomeAndContents() throws Exception {
        assertEquals("home_contents_quote.jsp" , VerticalSettings.getHomePageJsp("HOME"));

    }

    @Test
    public void getHomePageForVerticalCar() throws Exception {
        assertEquals("car_quote.jsp" ,VerticalSettings.getHomePageJsp("CAR"));
    }

}