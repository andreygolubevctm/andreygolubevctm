package com.ctm.security.model;

import com.ctm.model.Touch;
import com.ctm.model.settings.Vertical;
import com.ctm.utils.RequestUtils;
import io.jsonwebtoken.SignatureAlgorithm;

import javax.servlet.http.HttpServletRequest;

public class TransactionVerifierConfig {

    public static final String TRANSACTION_ID_CLAIM = "transactionId";
    public static final SignatureAlgorithm SIGNATURE_ALGORITHM = SignatureAlgorithm.HS512;

    private Long secondsUntilToken = 0L;
    boolean enabled;
    private Touch.TouchType touchType;


    public TransactionVerifierConfig(Vertical vertical, Touch.TouchType touchType, HttpServletRequest request) {
        this. touchType = touchType;
        setEnabled(Boolean.valueOf(vertical.getSettingForName("jwtEnabled").getValue()));
        if(enabled) {
            Long secondsUtilNextTokenConfig = Long.parseLong(vertical.getSettingForName("jwtSecondsUtilNextToken" + touchType.getCode()).getValue());
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
        }
    }

    public static String getJwtSecretKey(Vertical vertical) {
        return vertical.getSettingForName("jwtSecretKey").getValue();
    }

    private boolean isAction(HttpServletRequest request) {
        String action = request.getParameter("action");
        return action != null && !action.isEmpty();
    }

    private boolean isPreload(HttpServletRequest request) {
        String preLoad = request.getParameter("preload");
        return preLoad != null && preLoad.equals("true");
    }

    public Long getSecondsUntilNextTokenFuel(Long secondsUtilNextTokenConfig, HttpServletRequest request) {
        String fuelLocation = request.getParameter("fuel_location");
        String fuelType = request.getParameter("fueltype");
        if(  (fuelLocation != null && !fuelLocation.isEmpty()) && (fuelType != null && !fuelType.isEmpty())) {
            return 0L;
        } else {
            return secondsUtilNextTokenConfig;
        }
    }


    public Long getSecondsUntilNextToken() {
        return secondsUntilToken;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }

    public boolean getEnabled() {
        return enabled;
    }

    public Touch.TouchType getTouchType() {
        return touchType;
    }
}
