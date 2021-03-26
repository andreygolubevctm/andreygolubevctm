package com.ctm.web.core.model.settings;


public class VerticalSettings {

    private static String getHomePage(Vertical.VerticalType vertical) {
        return vertical.getCode().toLowerCase() + "_quote.jsp";
    }

    public static String getHomePageJsp(String vertical) {
        return VerticalSettings.getHomePage(Vertical.VerticalType.findByCode(vertical));
    }
}
