package com.ctm.security.token.config;

import com.ctm.model.Touch;
import com.ctm.model.settings.Vertical;
import com.ctm.utils.RequestUtils;

import javax.servlet.http.HttpServletRequest;

public class TokenConfigFactory {

    public static TokenCreatorConfig getInstance(Vertical vertical, Touch.TouchType touchType, HttpServletRequest request) {
        Long secondsUntilToken = 0L;
        TokenCreatorConfig tokenCreatorConfig = new TokenCreatorConfig();
        tokenCreatorConfig.setTouchType(touchType);
            Long secondsUtilNextTokenConfig = Long.parseLong(vertical.getSettingValueForName("jwtSecondsUntilNextToken" + touchType.getCode()));
            if (!RequestUtils.isTestIp(request)) {
                switch (touchType) {
                    case NEW:
                        if (!isPreload(request) && !isAction(request)) {
                            // no minimum seconds until next token if preload or loading a quote
                            switch (vertical.getType()) {
                                case HEALTH:
                                    secondsUntilToken = secondsUtilNextTokenConfig;
                                    break;
                                case FUEL:
                                    secondsUntilToken = getSecondsUntilNextTokenFuel(secondsUtilNextTokenConfig, request);
                                    break;
                            }
                        }
                        break;
                }
            }
        tokenCreatorConfig.setSecondsUntilToken(secondsUntilToken);
        return tokenCreatorConfig;
    }

    private static boolean isAction(HttpServletRequest request) {
        String action = request.getParameter("action");
        return action != null && !action.isEmpty();
    }

    private static boolean isPreload(HttpServletRequest request) {
        String preLoad = request.getParameter("preload");
        return preLoad != null && preLoad.equals("true");
    }

    public static Long getSecondsUntilNextTokenFuel(Long secondsUtilNextTokenConfig, HttpServletRequest request) {
        String fuelLocation = request.getParameter("fuel_location");
        String fuelType = request.getParameter("fueltype");
        if(  (fuelLocation != null && !fuelLocation.isEmpty()) && (fuelType != null && !fuelType.isEmpty())) {
            return 0L;
        } else {
            return secondsUtilNextTokenConfig;
        }
    }

    public static String getJwtSecretKey(Vertical vertical) {
        return vertical.getSettingValueForName("jwtSecretKey");
    }

    public static boolean getEnabled(Vertical vertical) {
        return Boolean.valueOf(vertical.getSettingValueForName("jwtEnabled"));
    }

}
