package com.ctm.web.car.model.request.propensityscore;

import com.ctm.web.core.services.UserAgentSniffer;

/**
 * device type based on user agent sniffing.
 * Note: Data Robot requires deviceType to be lowercase string.
 */
public enum DeviceType {
    DESKTOP("desktop"),
    MOBILE("mobile"),
    TABLET("tablet");

    private String name;

    DeviceType(String name){
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public static String getDeviceType(final String userAgent) {
        final String devicetype = UserAgentSniffer.getDeviceType(userAgent);
        switch (devicetype.toUpperCase()){
            case "COMPUTER":
            case "DESKTOP":
                return DESKTOP.getName();
            case "MOBILE":
            case "SMARTPHONE":
                return MOBILE.getName();
            case "TABLET":
                return TABLET.getName();
            default:
                return null;
        }
    }
}
