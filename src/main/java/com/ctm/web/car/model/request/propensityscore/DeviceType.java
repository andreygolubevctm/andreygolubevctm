package com.ctm.web.car.model.request.propensityscore;

import com.ctm.web.core.services.UserAgentSniffer;

/**
 * device type based on user agent sniffing.
 */
public enum DeviceType {
    DESKTOP("Desktop"),
    MOBILE("Mobile"),
    TABLET("Tablet");

    private String name;

    DeviceType(String name){
        this.name = name;
    }

    public static DeviceType getDeviceType(final String userAgent) {
        final String devicetype = UserAgentSniffer.getDeviceType(userAgent);
        switch (devicetype.toUpperCase()){
            case "COMPUTER":
            case "DESKTOP":
                return DESKTOP;
            case "MOBILE":
            case "SMARTPHONE":
                return MOBILE;
            case "TABLET":
                return TABLET;
            default:
                return null;
        }
    }
}
