package com.ctm.security.token.config;

import com.ctm.model.Touch;
import io.jsonwebtoken.SignatureAlgorithm;

public class TokenCreatorConfig {

    public static final String TRANSACTION_ID_CLAIM = "transactionId";
    public static final String TOUCH_CLAIM = "touch";
    public static final String SECONDS_UNTIL_NEXT_CLAIM = "secondsUntilNextToken";
    public static final SignatureAlgorithm SIGNATURE_ALGORITHM = SignatureAlgorithm.HS512;

    private Long secondsUntilToken = 0L;
    private Touch.TouchType touchType;
    private String vertical;

    public Long getSecondsUntilNextToken() {
        return secondsUntilToken;
    }

    public Touch.TouchType getTouchType() {
        return touchType;
    }

    public void setSecondsUntilNextToken(Long secondsUntilToken) {
        this.secondsUntilToken = secondsUntilToken;
    }

    public void setTouchType(Touch.TouchType touchType) {
        this.touchType = touchType;
    }

    public void setSecondsUntilToken(Long secondsUntilToken) {
        this.secondsUntilToken = secondsUntilToken;
    }

    public String getVertical() {
        return vertical;
    }

    public void setVertical(String vertical) {
        this.vertical = vertical;
    }
}
