package com.ctm.web.core.model.settings;


import org.junit.Test;

import static org.junit.Assert.*;


public class VerticalSettingsTest {

    @Test
    public void getHomePageForVerticalHealth() throws Exception {
        assertEquals("health_quote.jsp" , VerticalSettings.getHomePageJsp("HEALTH"));

    }
}