package com.ctm.web.core.security.token.config;

import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.utils.SessionUtils;

import javax.servlet.http.HttpServletRequest;

public class TokenConfigFactory {

    public static TokenCreatorConfig getInstance(Vertical vertical, Touch.TouchType touchType, HttpServletRequest request) {
        Long secondsUntilToken = 0L;
        TokenCreatorConfig tokenCreatorConfig = new TokenCreatorConfig();
        tokenCreatorConfig.setTouchType(touchType);
        tokenCreatorConfig.setVertical(vertical.getCode());
        Long secondsUtilNextTokenConfig = Long.parseLong(vertical.getSettingValueForName("jwtSecondsUntilNextToken" + touchType.getCode()));
        switch (touchType) {
            case NEW:
                // no minimum seconds until next token if preload or loading a quote
                if (!isPreload(request) && !isAction(request)) {
                    secondsUntilToken = secondsUtilNextTokenConfig;
                }
                break;
            default:
                secondsUntilToken = secondsUtilNextTokenConfig;
                break;
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

    public static String getJwtSecretKey(Vertical vertical) {
        return vertical.getSettingValueForName("jwtSecretKey");
    }

    public static boolean getEnabled(Vertical vertical) {
        return Boolean.valueOf(vertical.getSettingValueForName("jwtEnabled"));
    }

    public static boolean getEnabled(Vertical vertical, HttpServletRequest request) {
        return TokenConfigFactory.getEnabled(vertical) && !SessionUtils.isCallCentre(request.getSession());
    }

}
