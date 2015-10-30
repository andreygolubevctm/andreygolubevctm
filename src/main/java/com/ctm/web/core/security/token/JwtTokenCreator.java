package com.ctm.security.token;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.security.token.config.TokenConfigFactory;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.services.SettingsService;
import io.jsonwebtoken.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.web.core.logging.LoggingArguments.kv;
import static com.ctm.security.token.config.TokenCreatorConfig.SIGNATURE_ALGORITHM;
import static com.ctm.security.token.config.TokenCreatorConfig.TRANSACTION_ID_CLAIM;
import static com.ctm.security.token.config.TokenCreatorConfig.TOUCH_CLAIM;
import static com.ctm.security.token.config.TokenCreatorConfig.SECONDS_UNTIL_NEXT_CLAIM;

public class JwtTokenCreator {

    private static final Logger LOGGER = LoggerFactory.getLogger(JwtTokenCreator.class);

    private final TokenCreatorConfig config;
    private SettingsService settingsService;

    public JwtTokenCreator(SettingsService settingsService , TokenCreatorConfig config) {
        this.config = config;
        this.settingsService = settingsService;
    }

    public String createToken(String source , Long transactionId, long expiresSec) {
          return createToken(source, transactionId, config.getSecondsUntilNextToken(), expiresSec, config.getTouchType().getCode());
    }


    private String createToken(String source, Object transactionId, Object secondsUntilNextClaim, long expiresSec, Object touchType) {
        JwtBuilder builder = createBuilder(source, transactionId, touchType, secondsUntilNextClaim);
        Date notAfter = Date.from(LocalDateTime.now().plusSeconds(expiresSec).atZone(ZoneId.systemDefault()).toInstant());
        builder =builder.setExpiration(notAfter);
        builder.setHeaderParam("kid", config.getVertical());
        return builder.signWith(SIGNATURE_ALGORITHM, getSigningKey(config.getVertical())).compact();
    }


    private JwtBuilder createBuilder(String source, Object transactionId, Object touchType, Object secondsUntilNextClaim) {
        Map<String,Object> claims = new HashMap<>();
        claims.put(TRANSACTION_ID_CLAIM, transactionId);
        claims.put(TOUCH_CLAIM, touchType);
        claims.put(SECONDS_UNTIL_NEXT_CLAIM, secondsUntilNextClaim);
        return Jwts.builder().setClaims(claims).setSubject(source);
    }

    public String refreshToken(String token, long timeoutSeconds) {
        String tokenToReturn = token;
        Jws<Claims> decodedPayloadFull = getClaimsJws(token);
        if(decodedPayloadFull != null) {
            Claims decodedPayload = decodedPayloadFull.getBody();
            tokenToReturn = createToken((String) decodedPayload.get("source"), decodedPayload.get(TRANSACTION_ID_CLAIM), decodedPayload.get(SECONDS_UNTIL_NEXT_CLAIM), timeoutSeconds, decodedPayload.get(TOUCH_CLAIM));
        }
        return tokenToReturn;
    }

    public String refreshToken(String token, Long transactionId,  long timeoutSeconds) {
        String tokenToReturn = token;
        Jws<Claims>  decodedPayloadFull = getClaimsJws(token);
        if(decodedPayloadFull != null) {
            Claims decodedPayload = decodedPayloadFull.getBody();
            tokenToReturn = createToken((String) decodedPayload.get("source"), transactionId, decodedPayload.get(SECONDS_UNTIL_NEXT_CLAIM), timeoutSeconds, decodedPayload.get(TOUCH_CLAIM));
        }
        return tokenToReturn;
    }

    public Jws<Claims> getClaimsJws(String token) {
        Jws<Claims> decodedPayloadFull = null;
        try {
        JwtParser parser = Jwts.parser();
        decodedPayloadFull = parser.setSigningKeyResolver(new SigningKeyResolverAdapter() {
            @Override
            public byte[] resolveSigningKeyBytes(JwsHeader header, Claims claims) {
                //inspect the header or claims, lookup and return the signing key
                String keyId = header.getKeyId();
                return getSigningKey(keyId);
            }}).parseClaimsJws(token);
        } catch (ClaimJwtException  e) {
            LOGGER.warn("Failed to update token. {},{}", kv("originalToken", token), e);
        }
        return decodedPayloadFull;
    }


    private byte[] getSigningKey(String keyId) {
        try {
            config.setVertical(keyId);
            return TokenConfigFactory.getJwtSecretKey(settingsService.getVertical(keyId)).getBytes();
        } catch (DaoException e) {
            throw new RuntimeException(e);
        }
    }

}