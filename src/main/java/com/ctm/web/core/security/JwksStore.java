package com.ctm.web.core.security;

import com.auth0.jwk.GuavaCachedJwkProvider;
import com.auth0.jwk.JwkProvider;
import com.auth0.jwk.UrlJwkProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.net.URL;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;

/*
    AuthTokenFilter is instantiated outside of the application context, and thus cannot read Spring's application properties
    This component acts as a config store.
 */
@Component
public class JwksStore {


    public static final String ANON_V1_KID_HEADER = "ANON_V1";
    public static final String ANON_V2_KID_HEADER = "ANON_V2";

    private static final long MAX_KEYS_CACHED= 10L; //we currently only have 3 keys. 10 should be sufficient


    // this value represents the amount of days that the keys will be cached for (should be set to how often will keys be rotated)
    @Value("${ctm.jwks.refresh.days:30}")
    private Long refreshDays;

    @Value("${ctm.jwks.connect.timeout:5000}")
    private Integer connectTimeout;

    @Value("${ctm.jwks.read.timeout:10000}")
    private Integer readTimeout;

    private JwkProvider jwkProvider;

    private AtomicBoolean isEnabled;

    private static final Logger LOGGER = LoggerFactory.getLogger(JwksStore.class);

    @Autowired
    public void setJwkProvider(@Value("${ctm.jwks}") String endpoint) {
        if (endpoint!=null) {
            try {
                URL url = new URL(endpoint);
                jwkProvider = new GuavaCachedJwkProvider(new UrlJwkProvider(url,connectTimeout,readTimeout),MAX_KEYS_CACHED,refreshDays, TimeUnit.DAYS);
            } catch (Exception e) {
                LOGGER.error("Unable to initialise JWKS, Auth filter switched off",e);
                isEnabled.set(false);
            }

        }
    }

    public JwkProvider getJwkProvider() {
        return jwkProvider;
    }

    @Autowired
    public void setIsEnabledValue(@Value("${ctm.authtokenfilter.enabled:false}") Boolean enabled) {
        isEnabled = new AtomicBoolean(enabled);

    }

    public boolean isFilterEnabled() {
        return isEnabled.get();
    }


    @PostConstruct
    public void cacheKeys() {
        if (isEnabled.get()) {
            try {
                // the jwkProvider constructs the JWKS when the first JWK is requested, we want to do this before the first request gets filtered
                LOGGER.info("Attempting to get JWKS from session-middleware");
                jwkProvider.get(ANON_V1_KID_HEADER);
                jwkProvider.get(ANON_V2_KID_HEADER);
                // Auth 0's kid header is subject  to change, thus not adding it.
            } catch (Exception e) {
                LOGGER.error("Token verification was enabled; however, the JWKS could not be retrieved.", e);
                isEnabled.set(false);

            }
        }
        LOGGER.info("Auth filtering is enabled? {}", isEnabled.get());
    }
}
