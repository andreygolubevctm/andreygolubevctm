package com.ctm.security.token.config;

import com.ctm.model.Touch;
import io.jsonwebtoken.SignatureAlgorithm;

public class TokenCreatorConfig {

    public static final String TRANSACTION_ID_CLAIM = "transactionId";
    public static final SignatureAlgorithm SIGNATURE_ALGORITHM = SignatureAlgorithm.HS512;

    private Long secondsUntilToken = 0L;
    boolean enabled;
    private Touch.TouchType touchType;

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

    public void setSecondsUntilNextToken(Long secondsUntilToken) {
        this.secondsUntilToken = secondsUntilToken;
    }

    public void setTouchType(Touch.TouchType touchType) {
        this.touchType = touchType;
    }

    public void setSecondsUntilToken(Long secondsUntilToken) {
        this.secondsUntilToken = secondsUntilToken;
    }
}
