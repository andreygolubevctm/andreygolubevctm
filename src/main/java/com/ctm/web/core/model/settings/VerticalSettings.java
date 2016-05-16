package com.ctm.web.core.model.settings;


public class VerticalSettings {

    public static String getHomePage(Vertical.VerticalType vertical) {
        switch (vertical) {
            case HOME:
                return  "home_contents_quote.jsp";
            default:
                return vertical.getCode().toLowerCase() + "_quote.jsp";
        }
    }

    public static String getHomePageJsp(String vertical) {
        return VerticalSettings.getHomePage(Vertical.VerticalType.findByCode(vertical));
    }
}
